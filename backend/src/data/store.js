let complaintIdCounter = 2852;
const complaintCategories = ['plumbing', 'electrical', 'cleaning', 'water', 'maintenance'];
const complaintPriorities = ['low', 'medium', 'high', 'urgent'];
const complaintStatuses = ['submitted', 'assigned', 'inProgress', 'resolved'];

let complaints = [
  {
    id: 'QT-2847',
    title: 'Bathroom tap leaking',
    category: 'plumbing',
    status: 'inProgress',
    priority: 'high',
    updatedAt: new Date(Date.now() - 2 * 60 * 60 * 1000),
    residentName: 'Amit Verma',
    unit: 'Room 112, Block B',
    workerName: 'Ravi Kumar',
    eta: 'Today, 6 PM',
    description: 'The bathroom tap is leaking continuously and needs immediate attention.',
    timeline: [
      {
        title: 'Complaint submitted',
        subtitle: 'AI detected: Plumbing · High priority',
        time: '10:24 AM',
        isCompleted: true,
        isActive: false
      },
      {
        title: 'Routed to plumbing queue',
        subtitle: 'Auto-assigned to Block A team',
        time: '10:25 AM',
        isCompleted: true,
        isActive: false
      },
      {
        title: 'Technician assigned',
        subtitle: 'Ravi Kumar · ETA Today 6 PM',
        time: '11:02 AM',
        isCompleted: true,
        isActive: false
      },
      {
        title: 'Work in progress',
        subtitle: 'Parts procured · On-site visit started',
        time: '2:15 PM',
        isActive: true,
        isCompleted: false
      }
    ]
  },
  {
    id: 'QT-2831',
    title: 'Room AC not cooling',
    category: 'electrical',
    status: 'assigned',
    priority: 'medium',
    updatedAt: new Date(Date.now() - 5 * 60 * 60 * 1000),
    residentName: 'Suresh Patel',
    unit: 'Flat 3A, Tower 1',
    workerName: 'Suresh Patel',
    eta: 'Tomorrow',
    description: 'The AC is running but not cooling the room properly.',
    timeline: [
      {
        title: 'Complaint submitted',
        subtitle: 'AI detected: Electrical · Medium priority',
        time: '8:15 AM',
        isCompleted: true,
        isActive: false
      },
      {
        title: 'Technician assigned',
        subtitle: 'Suresh Patel · ETA Tomorrow',
        time: '9:00 AM',
        isActive: true,
        isCompleted: false
      }
    ]
  },
  {
    id: 'QT-2851',
    title: 'No hot water in shower',
    category: 'water',
    status: 'submitted',
    priority: 'urgent',
    updatedAt: new Date(Date.now() - 15 * 60 * 1000),
    residentName: 'Priya Sharma',
    unit: 'Room 204, Block A',
    workerName: null,
    eta: null,
    description: 'There is no hot water in the shower since last night.',
    timeline: [
      {
        title: 'Complaint submitted',
        subtitle: 'AI detected: Water · Urgent priority',
        time: new Date().toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' }),
        isActive: true,
        isCompleted: false
      }
    ]
  },
  {
    id: 'QT-2840',
    title: 'Common area not cleaned',
    category: 'cleaning',
    status: 'assigned',
    priority: 'medium',
    updatedAt: new Date(Date.now() - 4 * 60 * 60 * 1000),
    residentName: 'Neha Gupta',
    unit: 'Flat 3B, Tower 2',
    workerName: 'Cleaning Staff',
    eta: 'Today',
    description: 'The common area on the 3rd floor has not been cleaned today.',
    timeline: [
      {
        title: 'Complaint submitted',
        subtitle: 'AI detected: Cleaning · Medium priority',
        time: '10:00 AM',
        isCompleted: true,
        isActive: false
      },
      {
        title: 'Assigned to cleaning team',
        subtitle: 'Cleaning Staff · ETA Today',
        time: '10:30 AM',
        isActive: true,
        isCompleted: false
      }
    ]
  },
  {
    id: 'QT-2835',
    title: 'Lift making unusual noise',
    category: 'maintenance',
    status: 'submitted',
    priority: 'high',
    updatedAt: new Date(Date.now() - 6 * 60 * 60 * 1000),
    residentName: 'Rajesh Iyer',
    unit: 'Tower 1 Lobby',
    workerName: null,
    eta: null,
    description: 'The lift in Tower 1 is making a loud unusual noise when moving.',
    timeline: [
      {
        title: 'Complaint submitted',
        subtitle: 'AI detected: Maintenance · High priority',
        time: '7:30 AM',
        isActive: true,
        isCompleted: false
      }
    ]
  }
];

const workers = [
  { id: 1, name: 'Ravi Kumar', specialization: 'plumbing' },
  { id: 2, name: 'Suresh Patel', specialization: 'electrical' },
  { id: 3, name: 'Cleaning Staff', specialization: 'cleaning' },
  { id: 4, name: 'Water Technician', specialization: 'water' },
  { id: 5, name: 'Maintenance Team', specialization: 'maintenance' }
];

const users = [
  { id: 1, phone: '9876543210', name: 'Amit Verma', role: 'resident', unit: 'Room 112, Block B' },
  { id: 2, phone: '9876543211', name: 'Priya Sharma', role: 'resident', unit: 'Room 204, Block A' },
  { id: 3, phone: '9876543212', name: 'Manager', role: 'manager', unit: null }
];

module.exports = {
  complaints,
  workers,
  users,
  complaintCategories,
  complaintPriorities,
  complaintStatuses,
  getNextComplaintId: () => `QT-${complaintIdCounter++}`
};
