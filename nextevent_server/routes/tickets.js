const express = require("express");
const router = express.Router();
const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);
const { v4: uuidv4 } = require("uuid");
const { authenticate } = require("../middlewares/auth");
const db = require("../config/db");

// Purchase tickets with seat selection
router.post("/checkout", authenticate, async (req, res) => {
  // Get checkout details
  const { event_id, quantity, selectedSeats } = req.body;
  const userId = req.user.userId;

  // Check if event does not exist
  if (!event_id) {
    return res.status(400).json({ message: "Missing event_id" });
  }
  // Check if ticket quantity does not exist
  if (!quantity || quantity < 1) {
    return res.status(400).json({ message: "Quantity must be at least 1" });
  }
  // Check if seats list does not exist
  if (!Array.isArray(selectedSeats)) {
    return res.status(400).json({ message: "selectedSeats must be an array" });
  }
  // Compare seat list length and quantity of tickets
  if (selectedSeats.length !== quantity) {
    return res.status(400).json({ message: "selectedSeats length must match quantity" });
  }

  try {
    // Get event details
    const [eventRows] = await db.execute(
      "SELECT event_name, budget FROM events WHERE event_id = ?",
      [event_id]
    );

    // Check if event doesn't exist
    if (eventRows.length === 0) {
      return res.status(404).json({ message: "Event not found" });
    }

    // Assign event data
    const { event_name, budget } = eventRows[0];
    const priceInCents = Math.round(budget * 100);

    // Start Stripe checkout session
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ["card"],
      line_items: [
        {
          price_data: {
            currency: "usd",
            product_data: {
              name: event_name,
              description: `Ticket for ${event_name}`,
            },
            unit_amount: priceInCents,
          },
          quantity,
        },
      ],
      mode: "payment",
      success_url: `${process.env.CLIENT_URL}/success?session_id={CHECKOUT_SESSION_ID}`,
      cancel_url: `${process.env.CLIENT_URL}/cancel`,
      metadata: {
        userId: String(userId),
        event_id: String(event_id),
        quantity: String(quantity),
        seats: JSON.stringify(selectedSeats),
      },
    });

    // Return success status
    res.json({ checkout_url: session.url });
  } catch (error) {
    // Generate error
    console.error("Stripe Checkout Error:", error);
    res.status(500).json({ message: "Payment processing error", error });
  }
});

// Stripe webhook to store ticket data
router.post("/stripe/webhook", express.raw({ type: "application/json" }), async (req, res) => {
  let event;

  try {
    // Verify webhook signature
    event = stripe.webhooks.constructEvent(
      req.body,
      req.headers["stripe-signature"],
      process.env.STRIPE_WEBHOOK_SECRET
    );
  } catch (err) {
    // Generate error
    console.error("Webhook signature verification failed:", err.message);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  // Handle checkout session completion
  if (event.type === "checkout.session.completed") {
    // Get session metadata
    const session = event.data.object;
    const userId = parseInt(session.metadata.userId);
    const eventId = parseInt(session.metadata.event_id);
    const quantity = parseInt(session.metadata.quantity);
    const selectedSeats = JSON.parse(session.metadata.seats || "[]");

    try {
      // Check if user exists
      const [userCheck] = await db.execute("SELECT user_id FROM users WHERE user_id = ?", [userId]);
      if (userCheck.length === 0) {
        // Generate error
        console.error("Webhook Error: userId does not exist:", userId);
        return res.status(400).json({ message: "Invalid userId" });
      }

      // Insert tickets into database (Generate QR-Code tickets)
      for (let i = 0; i < quantity; i++) {
        const qrCode = `QR-${uuidv4()}`;
        const seat = selectedSeats[i] ?? null;

        await db.execute(
          `INSERT INTO tickets (event_id, user_id, qr_code, seat, purchased_at)
           VALUES (?, ?, ?, ?, NOW())`,
          [eventId, userId, qrCode, seat]
        );
      }
    } catch (dbError) {
      // Generate error
      console.error("Database error adding tickets:", dbError);
    }
  }

  // Return success status
  res.json({ received: true });
});

// Get tickets for logged-in user
router.get("/", authenticate, async (req, res) => {
  const userId = req.user.userId;

  try {
    // Get user tickets
    const [tickets] = await db.query(
      `SELECT t.ticket_id AS id, t.event_id, t.qr_code, t.seat, e.event_name AS title, e.start_date AS date
       FROM tickets t 
       INNER JOIN events e ON t.event_id = e.event_id 
       WHERE t.user_id = ?`,
      [userId]
    );

    // Return success status
    res.json(
      tickets.map(ticket => ({
        id: ticket.id,
        event_id: ticket.event_id,
        title: ticket.title,
        date: ticket.date,
        qr_code: ticket.qr_code,
        seat: ticket.seat,
      }))
    );
  } catch (error) {
    // Generate error
    console.error("Error fetching tickets:", error);
    res.status(500).json({ message: "Server Error" });
  }
});

// Export as ticket route
module.exports = router;