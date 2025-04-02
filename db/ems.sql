CREATE TABLE USER (
    user_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    middle_name VARCHAR(50),
    last_name  VARCHAR(50),
    email VARCHAR(50),
    password VARCHAR(50),
    phone_number VARCHAR(50)
);

CREATE TABLE ATTENDEES (
    user_id INT PRIMARY KEY,
    date_of_birth DATE,
    address VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES USER(user_id)
);

CREATE TABLE PICKS (
    user INT PRIMARY KEY,
    itinerary INT,
    FOREIGN KEY (user) REFERENCES USER(user_id),
    FOREIGN KEY (itinerary) REFERENCES ITINERARIES(itineraries_id)
);

CREATE TABLE ORGANIZERS (
    user_id INT PRIMARY KEY,
    FOREIGN KEY (user_id) REFERENCES USER(user_id)
);

CREATE TABLE MANAGER (
    manager_id INT PRIMARY KEY,
    user_id INT,
    FOREIGN KEY (user_id) REFERENCES USER(user_id)
);

CREATE TABLE VENDOR (
    vendor_id INT PRIMARY KEY,
    user_id INT,
    manager INT,
    FOREIGN KEY (user_id) REFERENCES USER(user_id),
    FOREIGN KEY (manager) REFERENCES MANAGER(manager_id)
);

CREATE TABLE ANALYST (
    analyst_id INT PRIMARY KEY,
    user_id INT,
    manager INT,
    FOREIGN KEY (user_id) REFERENCES USER(user_id),
    FOREIGN KEY (manager) REFERENCES MANAGER(manager_id)
);

CREATE TABLE CHECK_IN_STAFF (
    staff_id INT PRIMARY KEY,
    user_id INT,
    manager INT,
    FOREIGN KEY (user_id) REFERENCES USER(user_id),
    FOREIGN KEY (manager) REFERENCES MANAGER(manager_id)
);

CREATE TABLE EVENTS (
    event_id INT PRIMARY KEY,
    manager INT,
    event_name VARCHAR(50),
    event_type VARCHAR(50),
    description VARCHAR(50),
    location VARCHAR(50),
    status VARCHAR(50),
    budget REAL,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (manager) REFERENCES MANAGER(manager_id)
);

CREATE TABLE EVENT_IMAGES (
    image_id INT PRIMARY KEY,
    event INT,
    image VARCHAR(50),
    FOREIGN KEY (event) REFERENCES EVENTS(event_id)
);

CREATE TABLE TICKETS (
    ticket_id INT PRIMARY KEY,
    price REAL,
    discount REAL,
    status VARCHAR(50)
);

CREATE TABLE BASKET (
    basket_id INT PRIMARY KEY,
    attendee INT,
    total_price REAL,
    FOREIGN KEY (attendee) REFERENCES ATTENDEES(user_id)
);

CREATE TABLE TICKET_BASKET (
    ticket INT PRIMARY KEY,
    seat_row VARCHAR(2),
    seat_number INT,
    basket INT,
    quantity INT,
    time_added TIME,
    status VARCHAR(50),
    FOREIGN KEY (basket) REFERENCES BASKET(basket_id),
    FOREIGN KEY (ticket) REFERENCES TICKETS(ticket_id),
    FOREIGN KEY (seat_row, seat_number) REFERENCES SEATS(row, seat_number)
);

CREATE TABLE ITINERARIES (
    itineraries_id INT PRIMARY KEY,
    event INT,
    session_name VARCHAR(50),
    session_description VARCHAR(50),
    guests INT,
    date DATE,
    start_time TIME,
    end_time TIME,
    total_seats INT,
    FOREIGN KEY (event) REFERENCES EVENTS(event_id)
);

CREATE TABLE VENUE (
    venue_id INT PRIMARY KEY,
    itinerary INT,
    venue_location VARCHAR(25),
    capacity INT,
    FOREIGN KEY (itinerary) REFERENCES ITINERARIES(itineraries_id)
);

CREATE TABLE SEATS (
    row INT,
    seat_number INT,
    venue INT,
    availability BOOLEAN,
    PRIMARY KEY (row, seat_number),
    FOREIGN KEY (venue) REFERENCES VENUE(venue_id)
);

CREATE TABLE FEEDBACK (
    feedback_id INT PRIMARY KEY,
    itinerary INT,
    attendee INT,
    rating INT,
    comment VARCHAR(150),
    FOREIGN KEY (itinerary) REFERENCES ITINERARIES(itineraries_id),
    FOREIGN KEY (attendee) REFERENCES ATTENDEES(user_id)
);

CREATE TABLE CREATE_TICKETS (
    vendor INT,
    event INT,
    ticket INT,
    FOREIGN KEY (vendor) REFERENCES VENDOR(vendor_id),
    FOREIGN KEY (event) REFERENCES EVENTS(event_id),
    FOREIGN KEY (ticket) REFERENCES TICKETS(ticket_id)
);

CREATE TABLE ORDERS (
    order_id INT PRIMARY KEY,
    payment INT,
    order_date DATE,
    order_time TIME,
    FOREIGN KEY (payment) REFERENCES PAYMENTS(payment_id)
);

CREATE TABLE PAYMENTS (
    payment_id INT PRIMARY KEY,
    attendee INT,
    payment_method VARCHAR(50),
    status VARCHAR(50),
    amount REAL,
    FOREIGN KEY (attendee) REFERENCES ATTENDEES(user_id)
);

CREATE TABLE GENERATES ( 
    order_id INT,
    seat_row VARCHAR(2),
    seat_number INT,
    PRIMARY KEY (order_id, seat_row, seat_number),
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
    FOREIGN KEY (seat_row, seat_number) REFERENCES SEATS(row, seat_number)
);

CREATE TABLE TICKET_PURCHASES (
    attendee INT,
    order_id INT,
    qr_code_value VARCHAR(50),
    ticket_status VARCHAR(50),
    FOREIGN KEY (attendee) REFERENCES ATTENDEES(user_id),
    FOREIGN KEY (order_id) REFERENCES ORDERS(order_id)
);