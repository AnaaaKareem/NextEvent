const express = require("express");
const mysql = require("mysql2/promise");
const jwt = require("jsonwebtoken");
const router = express.Router();
const SECRET_KEY = process.env.JWT_SECRET || "your_jwt_secret_key";

// Database connection pool
const db = mysql.createPool({
  host: process.env.DB_HOST || "localhost",
  port: process.env.DB_PORT || 5432,
  user: process.env.DB_USER || "",
  password: process.env.DB_PASSWORD || "",
  database: process.env.DB_NAME || "ems_db",
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0,
});

// Middleware to authenticate users
const authenticate = (req, res, next) => {
  // Get token value without 'Bearer'
  const token = req.headers.authorization?.split(" ")[1];

  // Check if token is exists
  if (!token) {
    return res.status(401).json({ message: "Access Denied" });
  }

  try {
    // Verify token
    jwt.verify(token, SECRET_KEY, (err, user) => {
      if (err) {
        return res.status(403).json({ message: "Invalid Token" });
      }

      // Assign decoded user to request
      req.user = user;
      next();
    });
  } catch (error) {
    // Generate error
    console.error("JWT Error:", error);
    res.status(403).json({ message: "Invalid Token" });
  }
};

// Middleware to check if user is an attendee
const isAttendee = (req, res, next) => {
  // Check if user is not attendee
  if (req.user.role !== "attendee") {
    return res.status(403).json({ message: "Access Denied: Attendees only" });
  }
  next();
};

// Get all itineraries for an event using an eventID
router.get("/events/:eventId/itineraries", authenticate, async (req, res) => {
  const eventId = req.params.eventId;

  try {
    // Get itineraries for a specific event
    const [itineraries] = await db.query(
      `SELECT * FROM itinerary WHERE event_id = ?`,
      [eventId]
    );

    // Check if itineraries doesn't exist
    if (itineraries.length === 0) {
      return res.status(404).json({ message: "No itineraries found for this event" });
    }

    // Return success status
    res.status(200).json(itineraries);
  } catch (err) {
    // Generate error
    console.error(`Error fetching itineraries for event ${eventId}:`, err);
    res.status(500).json({ message: "Database error", error: err.message });
  }
});

// Submit feedback for an itinerary
router.post("/feedback", authenticate, isAttendee, async (req, res) => {
  const { itinerary_id, rating, comment } = req.body;
  const attendeeId = req.user.userId;

  // Check if itinerary doesn't exist
  if (!itinerary_id) {
    return res.status(400).json({ message: "Itinerary ID is required" });
  }

  // Check if rating is inavlid or doesn't exist
  if (!rating || rating < 1 || rating > 5) {
    return res.status(400).json({ message: "Rating must be between 1 and 5" });
  }

  try {
    // Get a specific itinerary
    const [itineraryRows] = await db.execute(
      "SELECT event_id FROM ITINERARIES WHERE itinerary_id = ?",
      [itinerary_id]
    );

    // Check if itinerary doesn't exist
    if (itineraryRows.length === 0) {
      return res.status(404).json({ message: "Itinerary not found" });
    }

    // Check if feedback alright exist
    const [existingFeedback] = await db.execute(
      "SELECT * FROM FEEDBACK WHERE itinerary_id = ? AND attendee_id = ?",
      [itinerary_id, attendeeId]
    );

    // Check if feedback already exist
    if (existingFeedback.length > 0) {
      return res.status(400).json({ message: "You have already submitted feedback for this itinerary" });
    }

    // Insert new feedback into the database
    await db.execute(
      "INSERT INTO FEEDBACK (itinerary_id, attendee_id, rating, comment) VALUES (?, ?, ?, ?)",
      [itinerary_id, attendeeId, rating, comment || null]
    );

    // Return success status
    res.status(201).json({ message: "Feedback submitted successfully" });
  } catch (error) {
    // Generate error
    console.error("Error submitting feedback:", error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
});

// Export as feedback route
module.exports = router;