const express = require('express');
const router = express.Router();
const pool = require('../config/db');
const jwt = require('jsonwebtoken');

// Middleware to check if a user is an organizer
const isOrganizer = (req, res, next) => {
  const authHeader = req.headers.authorization;

  // Check if Authorization header is missing
  if (!authHeader) {
    return res.status(401).json({ message: 'Unauthorized' });
  } 

  // Get token value without 'Bearer'
  const token = authHeader.split(' ')[1];

  try {
    // Check if user is an organizer by using the token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    // Return error if role is not organizer
    if (decoded.role !== 'organizer') {
      return res.status(403).json({ message: 'Forbidden' });
    }
    // Assign organizerID with userID
    req.organizer_id = decoded.user_id;
    next();
  } catch (err) {
    // Generate error
    console.error('JWT Error:', err);
    res.status(403).json({ message: 'Invalid token' });
  }
};

// Create a new event
router.post('/', isOrganizer, async (req, res) => {
  const { event_name, event_type, description, location, budget, start_date, end_date } = req.body;

  // Check if one field is empty
  if (!event_name || !event_type || !description || !location || !budget || !start_date || !end_date) {
    return res.status(400).json({ message: 'All fields are required' });
  }

  try {
    // Insert new event into the database
    const [result] = await pool.execute(
      `INSERT INTO EVENTS 
        (organizer_id, event_name, event_type, description, location, budget, start_date, end_date)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [
        req.organizer_id,
        event_name,
        event_type,
        description,
        location,
        parseFloat(budget),
        start_date,
        end_date
      ]
    );

    // Return success status
    res.status(201).json({ message: 'Event created', event_id: result.insertId });
  } catch (error) {
    // Generate error
    console.error("Create Event Error:", error);
    res.status(500).json({ message: 'Database error', error: error.message });
  }
});

// Get all events
router.get('/', async (req, res) => {
  try {
    // Get all events ordered by start date
    const [rows] = await pool.execute('SELECT * FROM EVENTS ORDER BY start_date DESC');

    // Return success status
    res.status(200).json(rows);
  } catch (err) {
    // Generate error
    console.error("Fetch Events Error:", err);
    res.status(500).json({ message: 'Server error' });
  }
});

// Get taken seats for a specific event
router.get('/:eventId/seats', async (req, res) => {
  const eventId = req.params.eventId;

  try {
    // Get all taken seats from the tickets table
    const [rows] = await pool.execute(
      `SELECT seat FROM tickets WHERE event_id = ? AND seat IS NOT NULL`,
      [eventId]
    );

    // Map seat numbers into a list
    const takenSeats = rows.map(row => row.seat);
    console.log(`Taken seats for event ${eventId}:`, takenSeats);

    // Return success status
    res.json(takenSeats);
  } catch (error) {
    // Generate error
    console.error("Error fetching taken seats:", error);
    res.status(500).json({ message: 'Error fetching taken seats', error });
  }
});

// Create an itinerary for an event
router.post('/:eventId/itineraries', isOrganizer, async (req, res) => {
  const eventId = req.params.eventId;
  const { title, description, start_time, end_time } = req.body;

  // Check if one field is empty
  if (!title || !start_time || !end_time) {
    return res.status(400).json({ message: 'Title, start time, and end time are required' });
  }

  try {
    // Insert new itinerary into database
    await pool.execute(
      `INSERT INTO itineraries (event_id, title, description, start_time, end_time)
       VALUES (?, ?, ?, ?, ?)`,
      [eventId, title, description || null, start_time, end_time]
    );

    // Return success status
    res.status(201).json({ message: "Itinerary created" });
  } catch (error) {
    // Generate error
    console.error("Error creating itinerary:", error);
    res.status(500).json({ message: "Server error", error });
  }
});

// Get itineraries for a specific event
router.get('/:eventId/itineraries', async (req, res) => {
  const eventId = req.params.eventId;

  try {
    // Get all itineraries ordered by start time
    const [rows] = await pool.execute(
      `SELECT * FROM itineraries WHERE event_id = ? ORDER BY start_time ASC`,
      [eventId]
    );

    // Return success status
    res.status(200).json(rows);
  } catch (error) {
    // Generate error
    console.error("Error fetching itineraries:", error);
    res.status(500).json({ message: "Server error", error });
  }
});

// Export as events route
module.exports = router;