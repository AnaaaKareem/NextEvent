require("dotenv").config();
const db = require('../config/db');

// Clean up old events and related tickets
async function cleanUpOldEvents() {
  try {
    console.log("Starting cleanup of past events and tickets...");

    // Remove tickets for past events
    await db.execute(`
      DELETE t FROM tickets t
      JOIN events e ON t.event_id = e.event_id
      WHERE e.end_date < NOW()
    `);
    console.log("Old tickets deleted.");

    // Remove past events
    await db.execute(`
      DELETE FROM events WHERE end_date < NOW()
    `);
    console.log("Past events deleted.");

  } catch (err) {
    // Generate error
    console.error("Cleanup failed:", err);
  }
}

// Export cleanup function
module.exports = cleanUpOldEvents;

// Allow manual execution via terminal
if (require.main === module) {
  cleanUpOldEvents().then(() => process.exit(0));
}
