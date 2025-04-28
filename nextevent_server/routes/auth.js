const express = require('express');
const router = express.Router();
const pool = require('../config/db');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

// Register
router.post('/register', async (req, res) => {
  // Set user attributes
  const {
    first_name,
    middle_name = '',
    last_name,
    email,
    password,
    phone_number = '',
    user_type,
    date_of_birth = '',
    address = ''
  } = req.body;

  // Check if one field is empty
  if (!first_name || !last_name || !email || !password || !user_type) {
    return res.status(400).json({ message: 'All required fields must be filled' });
  }

  try {
    // Check if emails exists
    const [existing] = await pool.execute('SELECT * FROM USERS WHERE email = ?', [email]);
    if (existing.length > 0) {
      return res.status(400).json({ message: 'Email is already registered' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Insert into USERS table
    const [result] = await pool.execute(
      `INSERT INTO USERS (first_name, middle_name, last_name, email, password, phone_number, user_type, date_of_birth, address)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [first_name, middle_name, last_name, email, hashedPassword, phone_number, user_type, date_of_birth, address]
    );

    // Get user ID
    const user_id = result.insertId;

    // Insert into ORGANIZERS table if user_type is organizer
    if (user_type === 'organizer') {
      await pool.execute(
        `INSERT INTO ORGANIZERS (organizer_id, user_id) VALUES (?, ?)`,
        [user_id, user_id]
      );
    }

    // Generate user token based on their id
    const token = jwt.sign({ user_id, role: user_type }, process.env.JWT_SECRET, {
      expiresIn: '1d'
    });

    // Register user with a success status
    res.status(201).json({
      user_id,
      token,
      first_name,
      middle_name,
      last_name,
      email,
      phone_number,
      user_type
    });
  } catch (error) {
    // Generate registeration error 
    console.error('Register Error:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Login
router.post('/login', async (req, res) => {
  // Get email and password
  const { email, password } = req.body;

  try {
    // Search for email address
    const [users] = await pool.execute('SELECT * FROM USERS WHERE email = ?', [email]);

    // Check if user doesn't exists
    if (users.length === 0) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    // Get user's email and password
    const user = users[0];
    // Compare the password received from the user and the hashed password from the database
    const validPassword = await bcrypt.compare(password, user.password);

    // Check if password is incorrect
    if (!validPassword) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    // Generate session token
    const token = jwt.sign({ user_id: user.user_id, role: user.user_type }, process.env.JWT_SECRET, {
      expiresIn: '1d'
    });

    // Login user with a success status
    res.status(200).json({
      message: 'Login successful',
      token,
      user: {
        user_id: user.user_id,
        first_name: user.first_name,
        middle_name: user.middle_name,
        last_name: user.last_name,
        email: user.email,
        phone_number: user.phone_number,
        user_type: user.user_type
      }
    });
  } catch (error) {
    // Generate login error 
    console.error('Login Error:', error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Export as auth route
module.exports = router;