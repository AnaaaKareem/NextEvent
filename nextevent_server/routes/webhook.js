const express = require("express");
const router = express.Router();
const stripe = require("stripe")(process.env.STRIPE_SECRET_KEY);
const { v4: uuidv4 } = require("uuid");
const db = require("../config/db");

// Handle Stripe webhook events
router.post("/", async (req, res) => {
  let event;

  try {
    // Verify webhook signature
    const sig = req.headers["stripe-signature"];
    event = stripe.webhooks.constructEvent(
      req.body,
      sig,
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
    const eventId = parseInt(session.metadata.eventId);
    const selectedSeats = JSON.parse(session.metadata.seats || "[]");

    console.log("Stripe Checkout Metadata:", { userId, eventId, selectedSeats });

    try {
      // Insert tickets into database
      for (let seat of selectedSeats) {
        const qrCode = `QR-${uuidv4()}`;
        await db.execute(
          `INSERT INTO tickets (event_id, user_id, qr_code, seat, purchased_at)
           VALUES (?, ?, ?, ?, NOW())`,
          [eventId, userId, qrCode, seat]
        );
        console.log(`Ticket added: QR=${qrCode}, Seat=${seat}`);
      }

      // Remove seats from basket
      if (selectedSeats.length > 0) {
        const placeholders = selectedSeats.map(() => '?').join(',');
        const deleteQuery = `
          DELETE FROM basket
          WHERE user_id = ? AND event_id = ? AND seat IN (${placeholders})
        `;
        await db.execute(deleteQuery, [userId, eventId, ...selectedSeats]);
        console.log(`Deleted from basket: ${selectedSeats}`);
      }
    } catch (dbError) {
      // Generate error
      console.error("DB Error during webhook:", dbError);
    }
  }
  // Return success status
  res.status(200).json({ received: true });
});

// Export as webhook route
module.exports = router;