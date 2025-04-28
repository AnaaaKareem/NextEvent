const jwt = require("jsonwebtoken");
const SECRET_KEY = process.env.JWT_SECRET || "your_jwt_secret_key";

// Middleware to authenticate users
const authenticate = (req, res, next) => {
  try {
    // Get token value without 'Bearer'
    const token = req.headers.authorization?.split(" ")[1];

    // Check if token exists
    if (!token) {
      return res.status(401).json({ message: "Access Denied" });
    }

    // Verify token
    jwt.verify(token, SECRET_KEY, (err, decoded) => {
    if (err) {
        return res.status(403).json({ message: "Invalid Token" });
    }

      // Assign normalized user data
      req.user = {
        ...decoded,
        userId: decoded.userId || decoded.user_id || decoded.id
      };

      // Check if userId is missing
      if (!req.user.userId) {
        return res.status(400).json({ message: "Invalid token payload: Missing userId" });
      }

      next();
    });
  } catch (error) {
    // Generate error
    console.error("Auth Middleware Error:", error);
    res.status(500).json({ message: "Server error" });
  }
};

// Middleware to check if user is an admin
const isAdmin = (req, res, next) => {
  // Check if user is not admin
  if (req.user.role !== "admin") {
    return res.status(403).json({ message: "Access Denied: Admins only" });
  }
  next();
};

// Middleware to check if user is an organizer or admin
const isOrganizer = (req, res, next) => {
  // Check if user is neither organizer nor admin
  if (req.user.role !== "organizer" && req.user.role !== "admin") {
    return res.status(403).json({ message: "Access Denied: Organizers only" });
  }
  next();
};

// Export middleware functions
module.exports = { authenticate, isOrganizer, isAdmin };