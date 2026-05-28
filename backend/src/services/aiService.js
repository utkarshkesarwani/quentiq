const { complaintCategories, complaintPriorities } = require('../data/store');

const keywords = {
  plumbing: ['tap', 'leak', 'pipe', 'drain', 'toilet', 'bathroom', 'sink', 'plumber', 'water leakage'],
  electrical: ['ac', 'electricity', 'light', 'bulb', 'fan', 'switch', 'socket', 'power', 'electrical', 'cooling'],
  cleaning: ['clean', 'dirty', 'garbage', 'dust', 'common area', 'washroom', 'toilet cleaning'],
  water: ['water', 'hot water', 'cold water', 'supply', 'pressure', 'shower', 'no water'],
  maintenance: ['lift', 'elevator', 'maintenance', 'noise', 'breakdown', 'repair', 'machine']
};

const priorityKeywords = {
  urgent: ['urgent', 'emergency', 'immediately', 'asap', 'critical', 'no water', 'no electricity'],
  high: ['high', 'important', 'needs attention', 'not working', 'leaking'],
  medium: ['medium', 'normal', 'can wait', 'minor issue'],
  low: ['low', 'minor', 'small', 'cosmetic', 'not urgent']
};

function categorizeComplaint(title, description) {
  const text = `${title} ${description}`.toLowerCase();
  
  let categoryScores = {};
  complaintCategories.forEach(cat => categoryScores[cat] = 0);

  for (const [category, keys] of Object.entries(keywords)) {
    for (const key of keys) {
      if (text.includes(key)) {
        categoryScores[category] += 1;
      }
    }
  }

  let maxScore = 0;
  let selectedCategory = 'maintenance';
  
  for (const [cat, score] of Object.entries(categoryScores)) {
    if (score > maxScore) {
      maxScore = score;
      selectedCategory = cat;
    }
  }

  let priority = 'medium';
  for (const [prio, keys] of Object.entries(priorityKeywords)) {
    for (const key of keys) {
      if (text.includes(key)) {
        priority = prio;
        break;
      }
    }
    if (priority !== 'medium') break;
  }

  return { category: selectedCategory, priority, confidence: Math.min(95, 70 + maxScore * 5) };
}

module.exports = { categorizeComplaint };
