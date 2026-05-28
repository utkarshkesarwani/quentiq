const express = require('express');
const router = express.Router();
const { complaints, workers, getNextComplaintId, complaintStatuses } = require('../data/store');
const { categorizeComplaint } = require('../services/aiService');

router.get('/', (req, res) => {
  const { residentId, status, category } = req.query;
  let filtered = [...complaints];

  if (residentId) {
    filtered = filtered.filter(c => c.residentName && c.residentName.toLowerCase().includes(residentId.toLowerCase()));
  }
  if (status) {
    filtered = filtered.filter(c => c.status === status);
  }
  if (category) {
    filtered = filtered.filter(c => c.category === category);
  }

  res.json(filtered);
});

router.get('/queue', (req, res) => {
  const queue = complaints.filter(c => c.status === 'submitted' || c.status === 'assigned');
  res.json(queue);
});

router.get('/:id', (req, res) => {
  const complaint = complaints.find(c => c.id === req.params.id);
  if (!complaint) {
    return res.status(404).json({ error: 'Complaint not found' });
  }
  res.json(complaint);
});

router.post('/', (req, res) => {
  const { title, description, residentName, unit } = req.body;

  if (!title || !description) {
    return res.status(400).json({ error: 'Title and description are required' });
  }

  const aiResult = categorizeComplaint(title, description);
  const id = getNextComplaintId();

  const newComplaint = {
    id,
    title,
    description,
    category: aiResult.category,
    status: 'submitted',
    priority: aiResult.priority,
    updatedAt: new Date(),
    residentName: residentName || 'Anonymous',
    unit: unit || 'N/A',
    workerName: null,
    eta: null,
    timeline: [
      {
        title: 'Complaint submitted',
        subtitle: `AI detected: ${aiResult.category.charAt(0).toUpperCase() + aiResult.category.slice(1)} · ${aiResult.priority.charAt(0).toUpperCase() + aiResult.priority.slice(1)} priority`,
        time: new Date().toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' }),
        isActive: true,
        isCompleted: false
      }
    ]
  };

  complaints.unshift(newComplaint);
  res.status(201).json({ complaint: newComplaint, aiInsights: aiResult });
});

router.put('/:id/status', (req, res) => {
  const { status, workerName, eta } = req.body;
  const complaint = complaints.find(c => c.id === req.params.id);

  if (!complaint) {
    return res.status(404).json({ error: 'Complaint not found' });
  }

  if (status && !complaintStatuses.includes(status)) {
    return res.status(400).json({ error: 'Invalid status' });
  }

  if (status) complaint.status = status;
  if (workerName) complaint.workerName = workerName;
  if (eta) complaint.eta = eta;
  complaint.updatedAt = new Date();

  const timelineEvent = {
    title: status === 'assigned' ? 'Technician assigned' : 
           status === 'inProgress' ? 'Work in progress' :
           status === 'resolved' ? 'Complaint resolved' : 'Status updated',
    subtitle: workerName ? `${workerName}${eta ? ` · ETA ${eta}` : ''}` : 'Status changed',
    time: new Date().toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' }),
    isActive: status !== 'resolved',
    isCompleted: status === 'resolved'
  };

  complaint.timeline.push(timelineEvent);
  complaint.timeline.forEach((event, idx) => {
    if (idx < complaint.timeline.length - 1) {
      event.isActive = false;
      event.isCompleted = true;
    }
  });

  res.json(complaint);
});

router.get('/stats/summary', (req, res) => {
  const total = complaints.length;
  const open = complaints.filter(c => c.status !== 'resolved').length;
  const inProgress = complaints.filter(c => c.status === 'inProgress').length;
  const resolved = complaints.filter(c => c.status === 'resolved').length;

  const categoryCounts = {};
  complaints.forEach(c => {
    categoryCounts[c.category] = (categoryCounts[c.category] || 0) + 1;
  });

  res.json({
    total,
    open,
    inProgress,
    resolved,
    categoryCounts,
    insights: [
      { label: 'Avg resolution', value: '4.2h', trend: '-18%', isUp: false },
      { label: 'Open complaints', value: open.toString(), trend: '+5%', isUp: true },
      { label: 'AI accuracy', value: '94%', trend: '+2%', isUp: false },
      { label: 'Satisfaction', value: '4.6', trend: '+0.3', isUp: false }
    ]
  });
});

module.exports = router;
