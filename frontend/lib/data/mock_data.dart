import 'package:quentiq/models/complaint_models.dart';

abstract final class MockData {
  static const activeComplaints = [
    ComplaintItem(
      id: 'QT-2847',
      title: 'Bathroom tap leaking',
      category: ComplaintCategory.plumbing,
      status: ComplaintStatus.inProgress,
      priority: ComplaintPriority.high,
      updatedAt: '2h ago',
      workerName: 'Ravi Kumar',
      eta: 'Today, 6 PM',
    ),
    ComplaintItem(
      id: 'QT-2831',
      title: 'Room AC not cooling',
      category: ComplaintCategory.electrical,
      status: ComplaintStatus.assigned,
      priority: ComplaintPriority.medium,
      updatedAt: '5h ago',
      workerName: 'Suresh Patel',
      eta: 'Tomorrow',
    ),
  ];

  static const recentUpdates = [
    ('AI categorized your complaint as Plumbing', '1h ago'),
    ('Technician Ravi assigned to QT-2847', '2h ago'),
    ('Your water supply issue was resolved', 'Yesterday'),
  ];

  static const timeline = [
    TimelineEvent(
      title: 'Complaint submitted',
      subtitle: 'AI detected: Plumbing · High priority',
      time: '10:24 AM',
      isCompleted: true,
    ),
    TimelineEvent(
      title: 'Routed to plumbing queue',
      subtitle: 'Auto-assigned to Block A team',
      time: '10:25 AM',
      isCompleted: true,
    ),
    TimelineEvent(
      title: 'Technician assigned',
      subtitle: 'Ravi Kumar · ETA Today 6 PM',
      time: '11:02 AM',
      isCompleted: true,
    ),
    TimelineEvent(
      title: 'Work in progress',
      subtitle: 'Parts procured · On-site visit started',
      time: '2:15 PM',
      isActive: true,
    ),
    TimelineEvent(
      title: 'Resolution',
      subtitle: 'Pending verification',
      time: '—',
    ),
  ];

  static const notifications = [
    NotificationItem(
      title: 'AI Update',
      body: 'Your plumbing complaint is 75% likely to resolve today based on similar cases.',
      time: '12m ago',
      type: 'ai',
      isAi: true,
    ),
    NotificationItem(
      title: 'Maintenance alert',
      body: 'Water supply maintenance scheduled for Block B tomorrow 9–11 AM.',
      time: '1h ago',
      type: 'alert',
    ),
    NotificationItem(
      title: 'Repair progress',
      body: 'Ravi Kumar marked QT-2847 as in progress. Tap replacement underway.',
      time: '2h ago',
      type: 'progress',
    ),
    NotificationItem(
      title: 'Complaint resolved',
      body: 'Wi-Fi connectivity issue QT-2799 closed. Rate your experience.',
      time: 'Yesterday',
      type: 'resolved',
    ),
  ];

  static const queueComplaints = [
    ComplaintItem(
      id: 'QT-2851',
      title: 'No hot water in shower',
      category: ComplaintCategory.water,
      status: ComplaintStatus.submitted,
      priority: ComplaintPriority.urgent,
      updatedAt: '15m ago',
      residentName: 'Priya Sharma',
      unit: 'Room 204, Block A',
    ),
    ComplaintItem(
      id: 'QT-2847',
      title: 'Bathroom tap leaking',
      category: ComplaintCategory.plumbing,
      status: ComplaintStatus.inProgress,
      priority: ComplaintPriority.high,
      updatedAt: '2h ago',
      residentName: 'Amit Verma',
      unit: 'Room 112, Block B',
    ),
    ComplaintItem(
      id: 'QT-2840',
      title: 'Common area not cleaned',
      category: ComplaintCategory.cleaning,
      status: ComplaintStatus.assigned,
      priority: ComplaintPriority.medium,
      updatedAt: '4h ago',
      residentName: 'Neha Gupta',
      unit: 'Flat 3B, Tower 2',
    ),
    ComplaintItem(
      id: 'QT-2835',
      title: 'Lift making unusual noise',
      category: ComplaintCategory.maintenance,
      status: ComplaintStatus.submitted,
      priority: ComplaintPriority.high,
      updatedAt: '6h ago',
      residentName: 'Rajesh Iyer',
      unit: 'Tower 1 Lobby',
    ),
  ];

  static const categoryCounts = {
    ComplaintCategory.plumbing: 12,
    ComplaintCategory.electrical: 8,
    ComplaintCategory.cleaning: 15,
    ComplaintCategory.water: 6,
    ComplaintCategory.maintenance: 9,
  };

  static const insights = [
    InsightMetric(
      label: 'Avg resolution',
      value: '4.2h',
      trend: '-18%',
      isUp: false,
    ),
    InsightMetric(
      label: 'Open complaints',
      value: '47',
      trend: '+5%',
      isUp: true,
    ),
    InsightMetric(
      label: 'AI accuracy',
      value: '94%',
      trend: '+2%',
      isUp: false,
    ),
    InsightMetric(
      label: 'Satisfaction',
      value: '4.6',
      trend: '+0.3',
      isUp: false,
    ),
  ];

  static const recurringIssues = [
    ('Water pressure low', 'Block B', 14),
    ('AC cooling issues', 'Block A', 11),
    ('Common area cleaning', 'All blocks', 9),
    ('Power fluctuation', 'Tower 2', 7),
  ];

  static const weeklyTrend = [12.0, 18.0, 14.0, 22.0, 16.0, 19.0, 11.0];
}
