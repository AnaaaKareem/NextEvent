-- USERS
CREATE TABLE USERS (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(50) NOT NULL,
    phone_number VARCHAR(50),
    user_type VARCHAR(25) NOT NULL,
    CHECK (user_type IN ('attendee', 'organizer', 'check_in_staff'))
);

-- ATTENDEES
CREATE TABLE ATTENDEES (
    attendee_id INT PRIMARY KEY,
    user_id INT UNIQUE NOT NULL,
    date_of_birth DATE NOT NULL,
    address VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id)
);

-- ORGANIZERS
CREATE TABLE ORGANIZERS (
    organizer_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id)
);

-- CHECK_IN_STAFF
CREATE TABLE CHECK_IN_STAFF (
    staff_id INT AUTO_INCREMENT PRIMARY KEY,
    organizer_id INT NOT NULL,
    user_id INT UNIQUE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id),
    FOREIGN KEY (organizer_id) REFERENCES ORGANIZERS(organizer_id)
);

-- ORG_CIS
CREATE TABLE ORG_CIS (
    organizer_id INT NOT NULL,
    staff_id INT NOT NULL,
    FOREIGN KEY (organizer_id) REFERENCES ORGANIZERS(organizer_id),
    FOREIGN KEY (staff_id) REFERENCES CHECK_IN_STAFF(staff_id)
);

-- EVENTS
CREATE TABLE EVENTS (
    event_id INT AUTO_INCREMENT PRIMARY KEY,
    organizer_id INT NOT NULL,
    event_name VARCHAR(50) NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    description VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    status VARCHAR(50) NOT NULL,
    budget REAL NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    FOREIGN KEY (organizer_id) REFERENCES ORGANIZERS(organizer_id)
);

-- EVENT_IMAGES
CREATE TABLE EVENT_IMAGES (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    image VARCHAR(50) NOT NULL,
    FOREIGN KEY (event_id) REFERENCES EVENTS(event_id)
);

-- ITINERARIES (updated: no start_time or end_time)
CREATE TABLE ITINERARIES (
    itinerary_id INT AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    session_name VARCHAR(50) NOT NULL,
    session_description VARCHAR(50) NOT NULL,
    guest VARCHAR(50) NOT NULL,
    date DATE NOT NULL,
    FOREIGN KEY (event_id) REFERENCES EVENTS(event_id)
);

-- VENUES
CREATE TABLE VENUES (
    venue_id INT AUTO_INCREMENT PRIMARY KEY,
    venue_location VARCHAR(25) NOT NULL,
    capacity INT NOT NULL
);

-- VENUE_BOOKINGS (now handles timing)
CREATE TABLE VENUE_BOOKINGS (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    venue_id INT NOT NULL,
    itinerary_id INT NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    FOREIGN KEY (venue_id) REFERENCES VENUES(venue_id),
    FOREIGN KEY (itinerary_id) REFERENCES ITINERARIES(itinerary_id),
    CHECK (start_time < end_time)
);

-- SEATS (updated composite key: seat_row + seat_column + venue_id)
CREATE TABLE SEATS (
    seat_row CHAR(1) NOT NULL,
    seat_column INT NOT NULL,
    venue_id INT NOT NULL,
    booking_id INT,
    PRIMARY KEY (seat_row, seat_column, venue_id),
    FOREIGN KEY (venue_id) REFERENCES VENUES(venue_id),
    FOREIGN KEY (booking_id) REFERENCES VENUE_BOOKINGS(booking_id)
);

-- TICKETS
CREATE TABLE TICKETS (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT NOT NULL,
    price REAL NOT NULL,
    discount REAL NOT NULL DEFAULT 0,
    status VARCHAR(50) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES VENUE_BOOKINGS(booking_id)
);

-- BASKET
CREATE TABLE BASKET (
    basket_id INT AUTO_INCREMENT PRIMARY KEY,
    attendee_id INT NOT NULL,
    FOREIGN KEY (attendee_id) REFERENCES ATTENDEES(attendee_id)
);

-- TICKET_BASKET
CREATE TABLE TICKET_BASKET (
    ticket_id INT NOT NULL,
    basket_id INT NOT NULL,
    quantity INT NOT NULL,
    time_added TIME NOT NULL,
    PRIMARY KEY (ticket_id, basket_id),
    FOREIGN KEY (ticket_id) REFERENCES TICKETS(ticket_id),
    FOREIGN KEY (basket_id) REFERENCES BASKET(basket_id)
);

-- FEEDBACK
CREATE TABLE FEEDBACK (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    itinerary_id INT NOT NULL,
    attendee_id INT NOT NULL,
    rating INT NOT NULL,
    comment VARCHAR(150),
    FOREIGN KEY (itinerary_id) REFERENCES ITINERARIES(itinerary_id),
    FOREIGN KEY (attendee_id) REFERENCES ATTENDEES(attendee_id)
);

-- MANAGE_TICKETS
CREATE TABLE MANAGE_TICKETS (
    organizer_id INT NOT NULL,
    ticket_id INT NOT NULL,
    PRIMARY KEY (organizer_id, ticket_id),
    FOREIGN KEY (organizer_id) REFERENCES ORGANIZERS(organizer_id),
    FOREIGN KEY (ticket_id) REFERENCES TICKETS(ticket_id)
);

-- PAYMENTS
CREATE TABLE PAYMENTS (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    attendee_id INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL,
    amount REAL NOT NULL,
    FOREIGN KEY (attendee_id) REFERENCES ATTENDEES(attendee_id)
);

-- ORDERS
CREATE TABLE ORDERS (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    payment_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    FOREIGN KEY (payment_id) REFERENCES PAYMENTS(payment_id)
);

-- TICKET_PURCHASES
CREATE TABLE TICKET_PURCHASES (
    attendee_id INT NOT NULL,
    order_id INT NOT NULL,
    ticket_id INT NOT NULL,
    qr_code_value VARCHAR(50) NOT NULL,
    ticket_status VARCHAR(50) NOT NULL,
    PRIMARY KEY (attendee_id, order_id, ticket_id),
    FOREIGN KEY (attendee_id) REFERENCES ATTENDEES(attendee_id),
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
    FOREIGN KEY (ticket_id) REFERENCES TICKETS(ticket_id)
);
