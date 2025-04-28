const express = require('express');
const router = express.Router();
const { authenticate } = require('../middlewares/auth');
const db = require('../config/db');
const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);
const { v4: uuidv4 } = require("uuid");

// Add selected seats to user's basket
router.post("/add-seats", authenticate, async (req, res) => {
  const userId = req.user.userId;
  const { eventId, selectedSeats } = req.body;

  // Check if event or seats do not exist
  if (!eventId || !Array.isArray(selectedSeats) || selectedSeats.length === 0) {
    return res.status(400).json({ message: "Missing or invalid data" });
  }

  try {
    // Add selected seats to user's basket
    for (const seat of selectedSeats) {
      await db.execute(
        `INSERT INTO basket (user_id, event_id, seat) VALUES (?, ?, ?)`,
        [userId, eventId, seat]
      );
    }

    // Return a success status
    return res.status(200).json({ message: "Seats added to basket" });
  } catch (error) {
    // Generate error
    console.error("Error adding to basket:", error);
    return res.status(500).json({ message: "Server error", error: error.message });
  }
});

// Get tickets from basket
router.get("/", authenticate, async (req, res) => {
  const userId = req.user.userId;

  try {
    // Get tickets from basket based on the user_id
    const [rows] = await db.execute(
      `SELECT basket_id, event_id, seat, created_at FROM basket WHERE user_id = ? ORDER BY created_at DESC`,
      [userId]
    );

    // Return a success status
    return res.status(200).json(rows);
  } catch (error) {
    // Generate error
    console.error("Error fetching basket:", error);
    return res.status(500).json({ message: "Server error" });
  }
});

// Remove a ticket from it's basket by its ID
router.delete("/:basketId", authenticate, async (req, res) => {
  const userId = req.user.userId;
  const basketId = parseInt(req.params.basketId, 10);

  // Check if basket exists
  if (isNaN(basketId)) {
    return res.status(400).json({ message: "Invalid basket ID" });
  }

  try {
    // Remove tickets from basket
    const [result] = await db.execute(
      `DELETE FROM basket WHERE basket_id = ? AND user_id = ?`,
      [basketId, userId]
    );

    // Check if query worked
    if (result.affectedRows === 0) {
      return res.status(404).json({ message: "Basket item not found or not owned by user" });
    }

    // Return success status
    res.status(200).json({ message: "Basket item removed" });
  } catch (error) {
    // Generate error
    console.error("Error removing basket item:", error);
    res.status(500).json({ message: "Server error" });
  }
});

// Checkout
router.post("/checkout", authenticate, async (req, res) => {
  const userId = req.user.userId;

  try {
    // Get tickets from basket using seats and eventID
    const [basketItems] = await db.execute(
      `SELECT event_id, seat FROM basket WHERE user_id = ?`,
      [userId]
    );

    // Check if tickets exist
    if (!basketItems.length) {
      return res.status(400).json({ message: "Basket is empty" });
    }

    // Assign eventID and a list of seats
    const eventId = basketItems[0].event_id;
    const seatIds = basketItems.map(item => item.seat);

    // Get budget of the event
    const [eventRows] = await db.execute(
      `SELECT event_name, budget FROM events WHERE event_id = ?`,
      [eventId]
    );

    // Check if event exists
    if (!eventRows.length) {
      return res.status(404).json({ message: "Event not found" });
    }

    // Assign event data, budget of the event 
    const event = eventRows[0];
    const seatPrice = parseFloat(event.budget);
    // Price of ticket derived from the event's budget
    const totalAmount = Math.round(seatPrice * 100) * seatIds.length;

    // Start Stripe checkout session
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ['card'],
      line_items: [{
        price_data: {
          currency: 'usd',
          product_data: {
            // Pass event name and seats as stripe products
            name: `${event.event_name} - Seats: ${seatIds.join(", ")}`,
          },
          // Pass the price of each ticket
          unit_amount: Math.round(seatPrice * 100),
        },
        // Get the number of tickets in a list as a quantity parameter
        quantity: seatIds.length,
      }],
      mode: 'payment',
      success_url: `${process.env.CLIENT_URL}/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${process.env.CLIENT_URL}/cancel`,
      metadata: {
        userId: String(userId),
        eventId: String(eventId),
        seats: JSON.stringify(seatIds),
      },
    });

    // Return a success status
    res.status(200).json({ checkout_url: session.url });
  } catch (error) {
    // Generate Error
    console.error("Checkout error:", error);
    res.status(500).json({ message: "Server error", error: error.message });
  }
});

// Export as basket route
module.exports = router;