import React, { useState } from 'react'
import axios from 'axios'

export default function PayForm(){
  const [email, setEmail] = useState('');
  const [amount, setAmount] = useState(1000);

  async function handlePay(e) {
  e.preventDefault();

  try {
    const API = import.meta.env.VITE_API_URL || 'http://localhost:5000';
    const resp = await axios.post(`${API}/api/payments/initialize`, {
      provider: 'paystack',
      email: email.trim(),
      amount: Number(amount),
      redirectUrl: window.location.origin,
    });

    const url =
      resp.data?.authorization_url ||
      resp.data?.data?.authorization_url ||
      resp.data?.data?.link;

    if (url) {
      window.location.href = url;
    } else {
      console.error('Payment init failed:', resp.data);
      alert('Payment initialization failed');
    }
  } catch (err) {
    const msg = err.response?.data?.error || err.message;
    console.error('Payment init error:', msg);
    alert(msg);
  }
}

  return (
    <form onSubmit={handlePay} className="space-y-4">
      <input className="w-full p-2 border rounded" value={email} onChange={e=>setEmail(e.target.value)} placeholder="you@example.com" />
      <input type="number" className="w-full p-2 border rounded" value={amount} onChange={e=>setAmount(e.target.value)} />
      <button className="w-full p-2 bg-blue-600 text-white rounded">Pay</button>
    </form>
  )
}
