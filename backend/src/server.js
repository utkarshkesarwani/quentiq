require('dotenv').config();
const express = require('express');
const cors = require('cors');

const authRoutes = require('./routes/auth');
const complaintRoutes = require('./routes/complaints');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.json({ 
    message: 'Quentiq Backend API is running!',
    version: '1.0.0',
    endpoints: {
      auth: '/api/auth',
      complaints: '/api/complaints'
    }
  });
});

app.use('/api/auth', authRoutes);
app.use('/api/complaints', complaintRoutes);


236


























3






















app.listen(PORT, () => {
  console.log(`Quentiq Backend is running on port ${PORT}`);
  console.log(`API available at http://localhost:${PORT}`);
});
