const express = require('express');
const router = express.Router();

const paystack = require('../services/paystack');
const flutterwave = require('../services/flutterwave');
const mock = require('../services/mock');

const providers = {
  paystack,
  flutterwave,
  mock,
};
// Uncomment when you add routes that use these:
// const vtpass = require('../services/vtpass');
// const monnify = require('../services/monnify');



// Initialize a payment (card/bank)
async function initializePayment(req, res) {
  const { provider = 'paystack', amount, email, redirectUrl } = req.body || {};

  if (!amount || Number(amount) <= 0) {
    return res.status(400).json({ error: 'A valid amount is required' });
  }
  if (!email) {
    return res.status(400).json({ error: 'Email is required' });
  }

  const service = providers[provider];
  if (!service) {
    return res.status(400).json({ error: `Unsupported provider: ${provider}` });
  }

  try {
    const resp = await service.initializePayment({ amount, email, redirectUrl });
    return res.json(resp);
  } catch (err) {
    console.error(`[payments] ${provider} initialize failed:`, err.message);
    return res.status(500).json({ error: err.message });
  }
}

// Both paths work, so the frontend can call either one
router.post('/charge', initializePayment);
router.post('/initialize', initializePayment);

module.exports = router;
