const express = require("express");
const mysql = require("mysql2/promise");
const router = express.Router();

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
  
  // Check if token doesn't exists
  if (!token) {
    return res.status(401).json({ message: "Access Denied" });
  }
  
  // Verify token
  jwt.verify(token, SECRET_KEY, (err, user) => {
    if (err) {
      return res.status(403).json({ message: "Invalid Token" })
    };
    
    // Assign decoded user to request
    req.user = user;
    next();
  });
};

// Get all itineraries for an event by eventID
router.get("/events/:eventId/itineraries", authenticate, async (req, res) => {
  const eventId = req.params.eventId;

  try {
    // Get itineraries for a specific event
    const [itineraries] = await db.query(
      "SELECT * FROM itinerary WHERE event_id = ?",
      [eventId]
    );

    // Check if itineraries don't exist
    if (itineraries.length === 0) {
      return res.status(404).json({ message: "No itineraries found for this event" });
    }

    // Return success status
    res.json(itineraries);
  } catch (err) {
    // Generate error
    console.error(`Error fetching itineraries for event ${eventId}:`, err);
    res.status(500).json({ message: "Database error", error: err.message });
  }
});

// Update an itinerary using an event and itinerary IDs
router.put("/events/:eventId/itineraries/:id", authenticate, isOrganizer, async (req, res) => {
  const eventId = req.params.eventId;
  const itineraryId = req.params.id;
  
  // Get itinerary details
  const { session_name, session_description, guest, date, start_time, end_time, total_seats } = req.body;

  // Check if one field is empty
  if (!session_name || !session_description || !guest || !date || !start_time || !end_time || !total_seats) {
    return res.status(400).json({ message: "All fields are required" });
  }

  try {
    // Get itinerary
    const [Itinerary] = await db.execute(
      "SELECT * FROM itinerary WHERE itinerary_id = ? AND event_id = ?",
      [itineraryId, eventId]
    );
    
    // Check if itinerary doesn't exist
    if (Itinerary.length === 0) {
      return res.status(404).json({ message: "Itinerary not found or does not belong to this event" });
    }

    // Update itinerary in database
    const sql = `
      UPDATE itinerary 
      SET 
        session_name = ?, 
        session_description = ?, 
        guest = ?, 
        date = ?, 
        start_time = ?, 
        end_time = ?, 
        total_seats = ?
      WHERE itinerary_id = ?
    `;
    await db.execute(sql, [
      session_name,
      session_description,
      guest,
      date,
      start_time,
      end_time,
      total_seats,
      itineraryId,
    ]);

    // Return success status
    res.json({ message: "Itinerary updated successfully" });
  } catch (err) {
    // Generate error
    console.error(`Error updating itinerary ${itineraryId}:`, err);
    res.status(500).json({ message: "Database error", error: err.message });
  }
});

// Delete an itinerary by event and itineraries IDs
router.delete("/events/:eventId/itineraries/:id", authenticate, isOrganizer, async (req, res) => {
  const eventId = req.params.eventId;
  const itineraryId = req.params.id;

  try {
    // Check if itinerary exists
    const [Itinerary] = await db.execute(
      "SELECT * FROM itinerary WHERE itinerary_id = ? AND event_id = ?",
      [itineraryId, eventId]
    );
    
    // Check if itinerary doesn't exist
    if (Itinerary.length === 0) {
      return res.status(404).json({ message: "Itinerary not found or does not belong to this event" });
    }

    // Remove itinerary from database
    await db.execute("DELETE FROM itinerary WHERE itinerary_id = ?", [itineraryId]);

    // Return success status
    res.json({ message: "Itinerary deleted successfully" });
  } catch (err) {
    // Generate error
    console.error(`Error deleting itinerary ${itineraryId}:`, err);
    res.status(500).json({ message: "Database error", error: err.message });
  }
});

// Export as itinerary route
module.exports = router;