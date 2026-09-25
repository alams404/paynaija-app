// Fake payment provider for testing. No account or API keys needed.
const crypto = require('crypto');

async function initializePayment({ amount, email, redirectUrl }) {
  const reference = 'MOCK-' + crypto.randomBytes(6).toString('hex').toUpperCase();
  const base = redirectUrl || 'http://localhost:3000';

  return {
    authorization_url: `${base}/?mock=success&reference=${reference}&amount=${amount}&email=${encodeURIComponent(email)}`,
    access_code: 'mock_access_code',
    reference,
  };
}

async function verifyTransaction(reference) {
  return { status: true, data: { status: 'success', reference } };
}

module.exports = { initializePayment, verifyTransaction };