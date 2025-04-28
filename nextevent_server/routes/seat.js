const express = require("express");
const mysql = require("mysql2/promise");
const jwt = require("jsonwebtoken");
const router = express.Router();
const SECRET_KEY = process.env.JWT_SECRET || "your_jwt_secret_key";

// Middleware to authenticate users
const authenticate = (req, res, next) => {
  // Get token value without 'Bearer'
  const token = req.headers.authorization?.split(" ")[1];
  
  // Check if token exists
  if (!token) {
    return res.status(401).json({ message: "Access Denied" });
  }

  // Verify token
  jwt.verify(token, SECRET_KEY, (err, user) => {
    if (err) {
      return res.status(403).json({ message: "Invalid Token" });
  }
    
    // Assign decoded user to request
    req.user = user;
    next();
  });
};

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

// Get seats for an event by eventID
router.get("/events/:eventId/seats", authenticate, async (req, res) => {
  const eventId = req.params.eventId;

  try {
    // Get seats for the event
    const [seats] = await db.query(
      `
        SELECT s.seat_column, s.seat_row, s.availability, v.venue_location
        FROM SEATS s
        INNER JOIN VENUES v ON s.venue_id = v.venue_id
        WHERE v.event_id = ?
      `,
      [eventId]
    );

    // Check if seats don't exist
    if (seats.length === 0) {
      return res.status(404).json({ message: "No seats found for this event" });
    }

    // Return success status
    res.json(seats);
  } catch (error) {
    // Generate error
    console.error(`Error fetching seats for event ${eventId}:`, error);
    res.status(500).json({ message: "Database error", error: error.message });
  }
});

// Book a seat for an event by eventID
router.post("/events/:eventId/seats/book", authenticate, async (req, res) => {
  const eventId = req.params.eventId;
  
  // Get seat details
  const { column, row } = req.body;

  // Check if one field is empty
  if (!column || !row) {
    return res.status(400).json({ message: "Seat column and row are required" });
  }

  try {
    // Get venue for the event
    const [venues] = await db.execute(
      "SELECT venue_id FROM VENUES WHERE event_id = ?",
      [eventId]
    );
    
    // Check if venue doesn't exist
    if (venues.length === 0) {
      return res.status(404).json({ message: "Venue not found for this event" });
    }
    
    // Assign venue ID
    const venueId = venues[0].venue_id;

    // Check if seat exists and is available
    const [seat] = await db.execute(
      "SELECT availability FROM SEATS WHERE seat_column = ? AND seat_row = ? AND venue_id = ?",
      [column, row, venueId]
    );

    // Check if seat doesn't exist
    if (seat.length === 0) {
      return res.status(404).json({ message: "Seat not found" });
    }

    // Check if seat is already booked
    if (!seat[0].availability) {
      return res.status(400).json({ message: "Seat is already booked" });
    }

    // Update seat availability
    await db.execute(
      "UPDATE SEATS SET availability = FALSE WHERE seat_column = ? AND seat_row = ? AND venue_id = ?",
      [column, row, venueId]
    );

    // Return success status
    res.json({ message: `Seat ${column}${row} booked successfully` });
  } catch (error) {
    // Generate error
    console.error(`Error booking seat for event ${eventId}:`, error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
});

// Update seat availability via column and row
router.put("/seats/:column/:row", authenticate, async (req, res) => {
  const { column, row } = req.params;
  
  // Get availability status
  const { availability } = req.body;

  // Check if ticket is available
  if (typeof availability !== "boolean") {
    return res.status(400).json({ message: "Availability must be a boolean" });
  }

  try {
    // Update seat in database
    await db.execute(
      "UPDATE SEATS SET availability = ? WHERE seat_column = ? AND seat_row = ?",
      [availability, column, row]
    );

    // Return success status
    res.json({ message: "Seat availability updated successfully" });
  } catch (error) {
    // Generate error
    console.error("Error updating seat availability:", error);
    res.status(500).json({ message: "Server error" });
  }
});

// Export as seat route
module.exports = router;