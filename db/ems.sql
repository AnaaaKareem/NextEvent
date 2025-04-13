CREATE TABLE USER (
    user_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50) NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    phone_number VARCHAR(50) NULL
);

CREATE TABLE ATTENDEES (
    user_id INT NOT NULL PRIMARY KEY,
    date_of_birth DATE NOT NULL,
    address VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES USER(user_id)
);

CREATE TABLE MANAGER (
    manager_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES USER(user_id)
);

CREATE TABLE EVENTS (
    event_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    manager INT NOT NULL,
    event_name VARCHAR(50) NOT NULL,
    event_type VARCHAR(50) NOT NULL,
    description VARCHAR(50) NOT NULL,
    location VARCHAR(50) NOT NULL,		
    status VARCHAR(50) NOT NULL,
    budget REAL NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    FOREIGN KEY (manager) REFERENCES MANAGER(manager_id)
);

CREATE TABLE ITINERARIES (
    itineraries_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    event INT NOT NULL,
    session_name VARCHAR(50) NOT NULL,
    session_description VARCHAR(50) NOT NULL,
    guests VARCHAR(50) NOT NULL,
    date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    total_seats INT NOT NULL,
    FOREIGN KEY (event) REFERENCES EVENTS(event_id)
);

CREATE TABLE PICKS (
    user_id INT NOT NULL,
    itinerary INT NOT NULL,
    PRIMARY KEY (user_id, itinerary),
    FOREIGN KEY (user_id) REFERENCES ATTENDEES(user_id),
    FOREIGN KEY (itinerary) REFERENCES ITINERARIES(itineraries_id)
);

CREATE TABLE ORGANIZERS (
    user_id INT NOT NULL PRIMARY KEY,
    FOREIGN KEY (user_id) REFERENCES USER(user_id)
);

CREATE TABLE VENDOR (
    vendor_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    manager INT NULL,
    FOREIGN KEY (user_id) REFERENCES USER(user_id),
    FOREIGN KEY (manager) REFERENCES MANAGER(manager_id)
);

CREATE TABLE ANALYST (
    analyst_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    manager INT NULL,
    FOREIGN KEY (user_id) REFERENCES USER(user_id),
    FOREIGN KEY (manager) REFERENCES MANAGER(manager_id)
);

CREATE TABLE CHECK_IN_STAFF (
    staff_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    manager INT NULL,
    FOREIGN KEY (user_id) REFERENCES USER(user_id),
    FOREIGN KEY (manager) REFERENCES MANAGER(manager_id)
);

CREATE TABLE EVENT_IMAGES (
    image_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    event INT NOT NULL,
    image VARCHAR(50) NOT NULL,
    FOREIGN KEY (event) REFERENCES EVENTS(event_id)
);

CREATE TABLE VENUE (
    venue_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    itinerary INT NOT NULL,
    venue_location VARCHAR(25) NOT NULL,
    capacity INT NOT NULL,
    FOREIGN KEY (itinerary) REFERENCES ITINERARIES(itineraries_id)
);

CREATE TABLE SEATS (
    seat_column VARCHAR(1) NOT NULL,
    seat_row INT NOT NULL,
    venue INT NOT NULL,
    availability BOOLEAN NOT NULL,
    PRIMARY KEY (seat_column, seat_row, venue),
    FOREIGN KEY (venue) REFERENCES VENUE(venue_id)
);

CREATE TABLE TICKETS (
    ticket_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    venue INT NOT NULL,
    seat_column VARCHAR(1) NOT NULL,
    seat_row INT NOT NULL,
    price REAL NOT NULL,
    discount REAL NULL,
    status VARCHAR(50) NOT NULL,
    FOREIGN KEY (seat_column, seat_row, venue) REFERENCES SEATS(seat_column, seat_row, venue)
);

CREATE TABLE BASKET (
    basket_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    attendee INT NOT NULL,
    FOREIGN KEY (attendee) REFERENCES ATTENDEES(user_id)
);

CREATE TABLE TICKET_BASKET (
    ticket INT NOT NULL,
    basket INT NOT NULL,
    quantity INT NOT NULL,
    time_added TIME NOT NULL,
    status VARCHAR(50) NOT NULL,
    PRIMARY KEY (ticket, basket),
    FOREIGN KEY (ticket) REFERENCES TICKETS(ticket_id),
    FOREIGN KEY (basket) REFERENCES BASKET(basket_id)
);

CREATE TABLE FEEDBACK (
    feedback_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    itinerary INT NOT NULL,
    attendee INT NOT NULL,
    rating INT NOT NULL,
    comment VARCHAR(150) NULL,
    FOREIGN KEY (itinerary) REFERENCES ITINERARIES(itineraries_id),
    FOREIGN KEY (attendee) REFERENCES ATTENDEES(user_id)
);

CREATE TABLE CREATE_TICKETS (
    vendor INT NOT NULL,
    event INT NOT NULL,
    ticket INT NOT NULL,
    PRIMARY KEY (vendor, event, ticket),
    FOREIGN KEY (vendor) REFERENCES VENDOR(vendor_id),
    FOREIGN KEY (event) REFERENCES EVENTS(event_id),
    FOREIGN KEY (ticket) REFERENCES TICKETS(ticket_id)
);

CREATE TABLE PAYMENTS (
    payment_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    attendee INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    status VARCHAR(50) NOT NULL,
    amount REAL NOT NULL,
    FOREIGN KEY (attendee) REFERENCES ATTENDEES(user_id)
);

CREATE TABLE ORDERS (
    order_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    payment INT NOT NULL,
    order_date DATE NOT NULL,
    order_time TIME NOT NULL,
    FOREIGN KEY (payment) REFERENCES PAYMENTS(payment_id)
);

CREATE TABLE TICKET_PURCHASES (
    attendee INT NOT NULL,
    order_id INT NOT NULL,
    ticket INT NOT NULL,
    qr_code_value VARCHAR(50) NOT NULL,
    ticket_status VARCHAR(50) NOT NULL,
    PRIMARY KEY (attendee, order_id, ticket),
    FOREIGN KEY (attendee) REFERENCES ATTENDEES(user_id),
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
    FOREIGN KEY (ticket) REFERENCES TICKETS(ticket_id)
);
