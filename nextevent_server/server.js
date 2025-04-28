require("dotenv").config();
const express = require("express");
const cors = require("cors");
const helmet = require("helmet");
const morgan = require("morgan");
const winston = require("winston");
const cron = require("node-cron");
const cleanup = require("./scripts/cleanup");

const authRoutes = require("./routes/auth");
const eventRoutes = require("./routes/events");
const ticketRoutes = require("./routes/tickets");
const basketRoutes = require("./routes/basket");
const webhookRoutes = require("./routes/webhook");

const app = express();
const PORT = process.env.PORT || 5000;

// Configure Stripe webhook specifying JSON formatting
app.use("/api/tickets/stripe/webhook", express.raw({ type: "application/json" }));

// Global Middleware
app.use(cors());
app.use(helmet());
app.use(morgan("combined"));
app.use(express.json());

// Setup Logger
const logger = winston.createLogger({
  level: "info",
  format: winston.format.json(),
  transports: [
    new winston.transports.Console(),
    new winston.transports.File({ filename: "server.log" }),
  ],
});

// Define health check routes
app.get("/api", (req, res) => res.json({ message: "Welcome to EMS API" }));
app.get("/success", (req, res) => res.send("<h2>Payment Successful! You can now close this window.</h2>"));
app.get("/cancel", (req, res) => res.send("<h2>Payment Cancelled. Please try again.</h2>"));

// Mount API routes
app.use("/api/auth", authRoutes);
app.use("/api/events", eventRoutes);
app.use("/api/tickets", ticketRoutes);
app.use("/api/basket", basketRoutes);
app.use("/api/tickets/stripe/webhook", webhookRoutes);

// Handle errors
app.use((err, req, res, next) => {
  // Generate error
  logger.error(`Error: ${err.message}`);
  res.status(500).json({ message: "Server Error" });
});

// Schedule hourly cleanup
cron.schedule("0 * * * *", async () => {
  console.log("Scheduled cleanup running...");
  try {
    // Run cleanup function
    await cleanup();
  } catch (err) {
    // Generate error
    console.error("Scheduled cleanup error:", err);
  }
});

// Start Server
app.listen(PORT, "0.0.0.0", () => {
  // Log server status
  logger.info(`Server running on http://192.168.1.27:${PORT}`);
});
