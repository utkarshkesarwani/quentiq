const express = require('express');
const router = express.Router();
const { users } = require('../data/store');

let otpStore = {};

router.post('/send-otp', (req, res) => {
  const { phone } = req.body;
  
  if (!phone) {
    return res.status(400).json({ error: 'Phone number is required' });
  }

  const otp = '123456';
  otpStore[phone] = { otp, expiresAt: Date.now() + 10 * 60 * 1000 };

  console.log(`OTP for ${phone}: ${otp}`);
  res.json({ message: 'OTP sent successfully', success: true });
});

router.post('/verify-otp', (req, res) => {
  const { phone, otp } = req.body;

  if (!phone || !otp) {
    return res.status(400).json({ error: 'Phone and OTP are required' });
  }

  const stored = otpStore[phone];
  
  if (!stored || stored.otp !== otp || Date.now() > stored.expiresAt) {
    return res.status(401).json({ error: 'Invalid or expired OTP' });
  }

  delete otpStore[phone];

  let user = users.find(u => u.phone === phone);
  
  if (!user) {
    user = {
      id: users.length + 1,
      phone,
      name: 'Resident',
      role: 'resident',
      unit: null
    };
    users.push(user);
  }

  const token = `token_${Date.now()}_${Math.random().toString(36).substr(2)}`;
  
  res.json({
    success: true,
    token,
    user: {
      id: user.id,
      name: user.name,
      phone: user.phone,
      role: user.role,
      unit: user.unit
    }
  });
});

module.exports = router;
