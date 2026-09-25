require("dotenv").config();

const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const path = require("path");

const payments = require("./routes/payments");
const flights = require("./routes/flights");

const app = express();

// ===============================
// CORS
// ===============================
app.use(
  cors({
    origin: "http://localhost:3000",
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);

// Handle preflight requests
app.options("*", cors());

// ===============================
// Middleware
// ===============================
app.use(bodyParser.json());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ===============================
// API Routes
// ===============================
app.use("/api/payments", payments);
app.use("/api/flights", flights);

// ===============================
// Health Check
// ===============================
app.get("/ping", (req, res) => {
  res.json({
    success: true,
    message: "PayNaija backend is running",
  });
});

// ===============================
// Serve Frontend
// ===============================
app.use(express.static(path.join(__dirname, "../frontend/dist")));

// React frontend fallback
app.get("*", (req, res) => {
  res.sendFile(path.join(__dirname, "../frontend/dist/index.html"));
});

// ===============================
// Start Server
// ===============================
const PORT = process.env.PORT || 5000;

app.listen(PORT, "0.0.0.0", () => {
  console.log(`PayNaija server running on port ${PORT}`);
});
