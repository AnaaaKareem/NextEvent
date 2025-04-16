CREATE TABLE IF NOT EXISTS USERS (
    user_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50) NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(50) NOT NULL,
    phone_number VARCHAR(50) NULL,
    user_type VARCHAR(25) NOT NULL,
    CHECK (user_type IN ('attendee', 'organizer', 'check_in_staff'))
);

CREATE TABLE IF NOT EXISTS ATTENDEES (
    attendee_id INT NOT NULL PRIMARY KEY,
    user_id INT NOT NULL,
    date_of_birth DATE NOT NULL,
    address VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id)
);

CREATE TABLE IF NOT EXISTS ORGANIZERS (
    organizer_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id)
);

CREATE TABLE IF NOT EXISTS CHECK_IN_STAFF (
    staff_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES USERS(user_id)
);

CREATE TABLE IF NOT EXISTS ORG_STAFF (
    organizer_id  INT NOT NULL,
    staff_id      INT NOT NULL,
    PRIMARY KEY (organizer_id, staff_id),
    FOREIGN KEY (organizer_id) REFERENCES ORGANIZERS(organizer_id),
    FOREIGN KEY (staff_id)     REFERENCES CHECK_IN_STAFF(staff_id)
);

CREATE TABLE IF NOT EXISTS EVENTS (
    event_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    organizer_id INT NOT NULL,
    event_name VARCHAR(50) NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    description VARCHAR(50) NOT NULL,
    location VARCHAR(50) NOT NULL,
    budget REAL NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    FOREIGN KEY (organizer_id) REFERENCES ORGANIZERS(organizer_id),
    CHECK (event_type IN ('conference', 'workshop', 'concert', 'festival')),
);

CREATE TABLE IF NOT EXISTS EVENT_IMAGES (
    image_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    image VARCHAR(50) NOT NULL,
    FOREIGN KEY (event_id) REFERENCES EVENTS(event_id)
);

CREATE TABLE IF NOT EXISTS BASKET (
    basket_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    attendee_id INT NOT NULL,
    FOREIGN KEY (attendee_id) REFERENCES ATTENDEES(attendee_id)
);

CREATE TABLE IF NOT EXISTS ITINERARIES (
    itinerary_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    event_id INT NOT NULL,
    session_name VARCHAR(50) NOT NULL,
    session_description VARCHAR(50) NOT NULL,
    guest VARCHAR(50) NOT NULL,
    date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (event_id) REFERENCES EVENTS(event_id)
);

CREATE TABLE IF NOT EXISTS PICKS (
    attendee_id INT NOT NULL,
    itinerary_id INT NOT NULL,
    PRIMARY KEY (attendee_id, itinerary_id),
    FOREIGN KEY (attendee_id) REFERENCES ATTENDEES(attendee_id),
    FOREIGN KEY (itinerary_id) REFERENCES ITINERARIES(itinerary_id)
);

CREATE TABLE IF NOT EXISTS VENUES (
    venue_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    itinerary_id INT NOT NULL,
    venue_location VARCHAR(25) NOT NULL,
    FOREIGN KEY (itinerary_id) REFERENCES ITINERARIES(itinerary_id)
);

CREATE TABLE IF NOT EXISTS SEATS (
    seat_column VARCHAR(1) NOT NULL,
    seat_row INT NOT NULL,
    venue_id INT NOT NULL,
    availability BOOLEAN NOT NULL,
    PRIMARY KEY (seat_column, seat_row, venue_id),
    FOREIGN KEY (venue_id) REFERENCES VENUES(venue_id)
);

CREATE TABLE IF NOT EXISTS TICKETS (
    ticket_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    venue_id INT NOT NULL,
    seat_column VARCHAR(1) NOT NULL,
    seat_row INT NOT NULL,
    price REAL NOT NULL,
    discount REAL NOT NULL DEFAULT 0,
    status VARCHAR(50) NOT NULL,
    FOREIGN KEY (seat_column, seat_row, venue_id) REFERENCES SEATS(seat_column, seat_row, venue_id)
    CHECK (status IN ('for sale', 'booked'))
);

CREATE TABLE IF NOT EXISTS TICKET_BASKET (
    ticket_id INT NOT NULL,
    basket_id INT NOT NULL,
    time_added TIME NOT NULL,
    PRIMARY KEY (ticket_id, basket_id),
    FOREIGN KEY (ticket_id) REFERENCES TICKETS(ticket_id),
    FOREIGN KEY (basket_id) REFERENCES BASKET(basket_id)
);

CREATE TABLE IF NOT EXISTS FEEDBACK (
    feedback_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    itinerary_id INT NOT NULL,
    attendee_id INT NOT NULL,
    rating INT NOT NULL,
    comment VARCHAR(150) NULL,
    FOREIGN KEY (itinerary_id) REFERENCES ITINERARIES(itinerary_id),
    FOREIGN KEY (attendee_id) REFERENCES ATTENDEES(attendee_id)
);

CREATE TABLE IF NOT EXISTS MANAGE_TICKETS (
    organizer_id INT NOT NULL,
    event_id INT NOT NULL,
    ticket_id INT NOT NULL,
    PRIMARY KEY (organizer_id, event_id, ticket_id),
    FOREIGN KEY (organizer_id) REFERENCES ORGANIZERS(organizer_id),
    FOREIGN KEY (event_id) REFERENCES EVENTS(event_id),
    FOREIGN KEY (ticket_id) REFERENCES TICKETS(ticket_id)
);

CREATE TABLE IF NOT EXISTS PAYMENTS (
    payment_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    attendee_id INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL,
    amount REAL NOT NULL,
    FOREIGN KEY (attendee_id) REFERENCES ATTENDEES(attendee_id),
    CHECK (status IN ('failed', 'successful'))
);

CREATE TABLE IF NOT EXISTS ORDERS (
    order_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    payment_id INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    FOREIGN KEY (payment_id) REFERENCES PAYMENTS(payment_id)
);

CREATE TABLE IF NOT EXISTS TICKET_PURCHASES (
    attendee_id INT NOT NULL,
    order_id INT NOT NULL,
    ticket_id INT NOT NULL,
    qr_code_value VARCHAR(50) NOT NULL,
    ticket_status VARCHAR(50) NOT NULL,
    PRIMARY KEY (attendee_id, order_id, ticket_id),
    FOREIGN KEY (attendee_id) REFERENCES ATTENDEES(attendee_id),
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
    FOREIGN KEY (ticket_id) REFERENCES TICKETS(ticket_id),
    CHECK (ticket_status IN ('not scanned', 'scanned'))
);
