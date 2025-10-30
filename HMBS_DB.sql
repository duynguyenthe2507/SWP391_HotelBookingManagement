-- Tạo database
CREATE DATABASE HMBS_DB;
GO

USE HMBS_DB;
GO

-- Table: Rank
CREATE TABLE Rank (
    rankId INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL UNIQUE,
    description NVARCHAR(500) NULL,
    minBookings INT NOT NULL,
    discountPercentage DECIMAL(5,2) DEFAULT 0,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE()
);
GO

-- Trigger cho Rank
CREATE TRIGGER trg_update_rank
ON Rank
AFTER UPDATE
AS
BEGIN
    UPDATE Rank
    SET updatedAt = GETDATE()
    FROM Rank
    INNER JOIN inserted ON Rank.rankId = inserted.rankId;
END;
GO

-- Table: Users
CREATE TABLE Users (
    userId INT IDENTITY(1,1) PRIMARY KEY,
    mobilePhone VARCHAR(15) NOT NULL UNIQUE,
    firstName NVARCHAR(20) NOT NULL,
    middleName NVARCHAR(20) NOT NULL,
    lastName NVARCHAR(20) NOT NULL,
    birthday DATE,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(30) NOT NULL CHECK (role IN ('receptionist', 'admin', 'customer')),
    rankId INT NULL,
    isBlackList BIT DEFAULT 0,
    isActive BIT DEFAULT 1,
    avatar_url NVARCHAR(500) NULL DEFAULT '/img/room/avatar/default-avatar.png',
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Users_Rank FOREIGN KEY (rankId) REFERENCES Rank(rankId) ON DELETE SET NULL
);
GO

-- Trigger cho Users
CREATE TRIGGER trg_update_users
ON Users
AFTER UPDATE
AS
BEGIN
    UPDATE Users
    SET updatedAt = GETDATE()
    FROM Users
    INNER JOIN inserted ON Users.userId = inserted.userId;
END;
GO

-- Table: Services
CREATE TABLE Services (
    serviceId INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description NVARCHAR(500) NULL,
    iconClass VARCHAR(50) NULL,
    updatedAt DATETIME DEFAULT GETDATE()
);
GO

-- Trigger cho Services
CREATE TRIGGER trg_update_services
ON Services
AFTER UPDATE
AS
BEGIN
    UPDATE Services
    SET updatedAt = GETDATE()
    FROM Services
    INNER JOIN inserted ON Services.serviceId = inserted.serviceId;
END;
GO

-- Table: Category
CREATE TABLE Category (
    categoryId INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50) NOT NULL UNIQUE,
    description NVARCHAR(500) NULL,
    imgUrl NVARCHAR(255) NULL,
    updatedAt DATETIME DEFAULT GETDATE()
);
GO

-- Trigger cho Category
CREATE TRIGGER trg_update_category
ON Category
AFTER UPDATE
AS
BEGIN
    UPDATE Category
    SET updatedAt = GETDATE()
    FROM Category
    INNER JOIN inserted ON Category.categoryId = inserted.categoryId;
END;
GO

-- Table: Room
CREATE TABLE Room (
    roomId INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    categoryId INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    capacity INT NOT NULL,
    status VARCHAR(15) DEFAULT 'available' CHECK (status IN ('available', 'booked', 'maintenance')),
    description NVARCHAR(500),
    imgUrl NVARCHAR(255) NULL,
    updatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Room_Category FOREIGN KEY (categoryId) REFERENCES Category(categoryId) ON DELETE NO ACTION
);
GO

-- Trigger cho Room
CREATE TRIGGER trg_update_room
ON Room
AFTER UPDATE
AS
BEGIN
    UPDATE Room
    SET updatedAt = GETDATE()
    FROM Room
    INNER JOIN inserted ON Room.roomId = inserted.roomId;
END;
GO

-- Table: Booking
CREATE TABLE Booking (
    bookingId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NULL,
    roomId INT NOT NULL,
    receptionistId INT NULL,
    guestName NVARCHAR(255) NULL,
    guestCount INT NOT NULL DEFAULT 1,
    specialRequest NVARCHAR(1000) NULL,
    checkinTime DATETIME NOT NULL,
    checkoutTime DATETIME NOT NULL,
    status VARCHAR(15) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled', 'checked-in', 'checked-out')),
    totalPrice DECIMAL(10,2) NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Booking_User FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE CASCADE,
    CONSTRAINT FK_Booking_Room FOREIGN KEY (roomId) REFERENCES Room(roomId),
    CONSTRAINT FK_Booking_Receptionist FOREIGN KEY (receptionistId) REFERENCES Users(userId),
    CONSTRAINT CHK_Booking_Dates CHECK (checkinTime < checkoutTime)
);
GO

-- Trigger để tự động tính updatedAt trong Booking (đã loại bỏ durationHours)
CREATE TRIGGER trg_update_booking
ON Booking
AFTER INSERT, UPDATE
AS
BEGIN
    -- Chỉ cập nhật updatedAt; durationHours không còn sử dụng nữa
    UPDATE Booking
    SET updatedAt = GETDATE()
    FROM Booking
    INNER JOIN inserted ON Booking.bookingId = inserted.bookingId;

    IF EXISTS (SELECT 1 FROM inserted WHERE status = 'confirmed')
    BEGIN
        INSERT INTO BookingHistory (userId, bookingId, completedAt)
        SELECT i.userId, i.bookingId, GETDATE()
        FROM inserted i
        WHERE i.status = 'confirmed'
        AND NOT EXISTS (
            SELECT 1 FROM BookingHistory bh WHERE bh.bookingId = i.bookingId
        );
    END;
END;
GO

-- Table: BookingHistory
CREATE TABLE BookingHistory (
    historyId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    bookingId INT NOT NULL,
    completedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_BookingHistory_User FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE NO ACTION,
    CONSTRAINT FK_BookingHistory_Booking FOREIGN KEY (bookingId) REFERENCES Booking(bookingId) ON DELETE CASCADE,
    CONSTRAINT UQ_BookingHistory_Booking UNIQUE (bookingId)
);
GO

-- Trigger để cập nhật rankId trong Users dựa trên BookingHistory
CREATE TRIGGER trg_update_bookingHistory
ON BookingHistory
AFTER INSERT
AS
BEGIN
    UPDATE Users
    SET rankId = (
        SELECT TOP 1 r.rankId
        FROM Rank r
        WHERE r.minBookings <= (
            SELECT COUNT(*) 
            FROM BookingHistory bh 
            WHERE bh.userId = Users.userId
        )
        ORDER BY r.minBookings DESC
    ),
    updatedAt = GETDATE()
    FROM Users
    INNER JOIN inserted i ON Users.userId = i.userId;
END;
GO

-- Table: BookingDetail
CREATE TABLE BookingDetail (
    bookingDetailId INT IDENTITY(1,1) PRIMARY KEY,
    bookingId INT NOT NULL,
    roomId INT NOT NULL,
    priceAtBooking DECIMAL(10,2) NOT NULL,
    guestCount INT NOT NULL,
    specialRequest NVARCHAR(500) NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_BookingDetail_Booking FOREIGN KEY (bookingId) REFERENCES Booking(bookingId) ON DELETE CASCADE,
    CONSTRAINT FK_BookingDetail_Room FOREIGN KEY (roomId) REFERENCES Room(roomId) ON DELETE NO ACTION,
    CONSTRAINT UQ_BookingDetail_BookingRoom UNIQUE (bookingId, roomId)
);
GO

-- Trigger cho BookingDetail
CREATE TRIGGER trg_update_bookingDetail
ON BookingDetail
AFTER UPDATE
AS
BEGIN
    UPDATE BookingDetail
    SET updatedAt = GETDATE()
    FROM BookingDetail
    INNER JOIN inserted ON BookingDetail.bookingDetailId = inserted.bookingDetailId;
END;
GO

-- Table: Payment
CREATE TABLE Payment (
    paymentId INT IDENTITY(1,1) PRIMARY KEY,
    bookingId INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    method VARCHAR(30) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed')),
    transactionTime DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Payment_Booking FOREIGN KEY (bookingId) REFERENCES Booking(bookingId) ON DELETE CASCADE
);
GO

-- Trigger cho Payment
CREATE TRIGGER trg_update_payment
ON Payment
AFTER UPDATE
AS
BEGIN
    UPDATE Payment
    SET updatedAt = GETDATE()
    FROM Payment
    INNER JOIN inserted ON Payment.paymentId = inserted.paymentId;
END;
GO

-- Table: Invoice
CREATE TABLE Invoice (
    invoiceId INT IDENTITY(1,1) PRIMARY KEY,
    bookingId INT NOT NULL,
    totalRoomCost DECIMAL(10,2) NOT NULL,
    totalServiceCost DECIMAL(10,2) NOT NULL,
    taxAmount DECIMAL(10,2) NOT NULL,
    totalAmount DECIMAL(10,2) NOT NULL,
    issuedDate DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Invoice_Booking FOREIGN KEY (bookingId) REFERENCES Booking(bookingId) ON DELETE CASCADE
);
GO

-- Trigger cho Invoice
CREATE TRIGGER trg_update_invoice
ON Invoice
AFTER UPDATE
AS
BEGIN
    UPDATE Invoice
    SET updatedAt = GETDATE()
    FROM Invoice
    INNER JOIN inserted ON Invoice.invoiceId = inserted.invoiceId;
END;
GO

-- Table: Wishlist
CREATE TABLE Wishlist (
    wishlistId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    roomId INT NOT NULL,
    updatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Wishlist_User FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE CASCADE,
    CONSTRAINT FK_Wishlist_Room FOREIGN KEY (roomId) REFERENCES Room(roomId) ON DELETE CASCADE,
    CONSTRAINT UQ_Wishlist_UserRoom UNIQUE (userId, roomId)
);
GO

-- Trigger cho Wishlist
CREATE TRIGGER trg_update_wishlist
ON Wishlist
AFTER UPDATE
AS
BEGIN
    UPDATE Wishlist
    SET updatedAt = GETDATE()
    FROM Wishlist
    INNER JOIN inserted ON Wishlist.wishlistId = inserted.wishlistId;
END;
GO

-- Table: Cart
CREATE TABLE Cart (
    cartId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    roomId INT NOT NULL,
    quantity INT DEFAULT 1,
    updatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Cart_User FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE CASCADE,
    CONSTRAINT FK_Cart_Room FOREIGN KEY (roomId) REFERENCES Room(roomId) ON DELETE CASCADE,
    CONSTRAINT UQ_Cart_UserRoom UNIQUE (userId, roomId)
);
GO

-- Trigger cho Cart
CREATE TRIGGER trg_update_cart
ON Cart
AFTER UPDATE
AS
BEGIN
    UPDATE Cart
    SET updatedAt = GETDATE()
    FROM Cart
    INNER JOIN inserted ON Cart.cartId = inserted.cartId;
END;
GO

-- Table: Feedback
CREATE TABLE Feedback (
    feedbackId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    bookingId INT NOT NULL,
    content NVARCHAR(1000),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    created_at DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Feedback_User FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE NO ACTION,
    CONSTRAINT FK_Feedback_Booking FOREIGN KEY (bookingId) REFERENCES Booking(bookingId) ON DELETE CASCADE
);
GO

-- Trigger cho Feedback
CREATE TRIGGER trg_update_feedback
ON Feedback
AFTER UPDATE
AS
BEGIN
    UPDATE Feedback
    SET updatedAt = GETDATE()
    FROM Feedback
    INNER JOIN inserted ON Feedback.feedbackId = inserted.feedbackId;
END;
GO

-- Table: ServiceRequest
CREATE TABLE ServiceRequest (
    requestId INT IDENTITY(1,1) PRIMARY KEY,
    bookingId INT NOT NULL,
    serviceTypeId INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    status VARCHAR(15) DEFAULT 'requested' CHECK (status IN ('requested', 'completed', 'cancelled')),
    updatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_ServiceRequest_Booking FOREIGN KEY (bookingId) REFERENCES Booking(bookingId) ON DELETE CASCADE,
    CONSTRAINT FK_ServiceRequest_Service FOREIGN KEY (serviceTypeId) REFERENCES Services(serviceId) ON DELETE NO ACTION
);
GO

-- Trigger cho ServiceRequest
CREATE TRIGGER trg_update_serviceRequest
ON ServiceRequest
AFTER UPDATE
AS
BEGIN
    UPDATE ServiceRequest
    SET updatedAt = GETDATE()
    FROM ServiceRequest
    INNER JOIN inserted ON ServiceRequest.requestId = inserted.requestId;
END;
GO

-- Thêm chỉ mục để tối ưu hiệu suất
CREATE INDEX idx_users_email ON Users(email);
CREATE INDEX idx_users_mobilePhone ON Users(mobilePhone);
CREATE INDEX idx_users_rankId ON Users(rankId);
CREATE INDEX idx_booking_userId ON Booking(userId);
CREATE INDEX idx_bookingDetail_bookingId ON BookingDetail(bookingId);
CREATE INDEX idx_bookingDetail_roomId ON BookingDetail(roomId);
CREATE INDEX idx_bookingHistory_userId ON BookingHistory(userId);
CREATE INDEX idx_bookingHistory_bookingId ON BookingHistory(bookingId);
CREATE INDEX idx_payment_bookingId ON Payment(bookingId);
CREATE INDEX idx_invoice_bookingId ON Invoice(bookingId);
CREATE INDEX idx_feedback_userId ON Feedback(userId);
CREATE INDEX idx_feedback_bookingId ON Feedback(bookingId);
CREATE INDEX idx_wishlist_userId_roomId ON Wishlist(userId, roomId);
CREATE INDEX idx_cart_userId_roomId ON Cart(userId, roomId);
CREATE INDEX idx_serviceRequest_bookingId ON ServiceRequest(bookingId);
CREATE INDEX idx_serviceRequest_serviceTypeId ON ServiceRequest(serviceTypeId);
CREATE INDEX idx_room_categoryId ON Room(categoryId);
GO

-- Ensure schema extensions exist before data inserts
-- (No ALTER TABLE needed; fields are defined in CREATE TABLE above)

CREATE TABLE Rules (
                       ruleId INT IDENTITY(1,1) PRIMARY KEY,
                       title NVARCHAR(255) NOT NULL,
                       description NVARCHAR(MAX) NOT NULL,
                       status BIT DEFAULT 1,
                       createdAt DATETIME DEFAULT GETDATE(),
                       updatedAt DATETIME DEFAULT GETDATE()
);
GO

CREATE TRIGGER trg_update_rules
    ON Rules
    AFTER UPDATE
              AS
BEGIN
UPDATE Rules
SET updatedAt = GETDATE()
    FROM Rules
    INNER JOIN inserted ON Rules.ruleId = inserted.ruleId;
END;
GO

-- MASTER DATA from root HMBS_DB.sql
-- Insert Rank
INSERT INTO Rank (name, description, minBookings, discountPercentage, createdAt, updatedAt)
VALUES 
    ('Bronze', 'Basic tier for new customers', 0, 0.00, GETDATE(), GETDATE()),
    ('Silver', 'Silver tier for loyal customers', 5, 5.00, GETDATE(), GETDATE()),
    ('Gold', 'Gold tier for VIP customers', 10, 10.00, GETDATE(), GETDATE()),
    ('Diamond', 'Highest tier with special privileges', 20, 15.00, GETDATE(), GETDATE());
GO

-- Insert Category
INSERT INTO Category (name, description, imgUrl, updatedAt)
VALUES 
    ('Family', 'Premium family room', NULL, GETDATE()),
    ('Deluxe', 'Luxurious room', NULL, GETDATE()),
    ('Double', 'Room with two beds', NULL, GETDATE());
GO

-- Insert Services
INSERT INTO Services (name, price, description, iconClass, updatedAt)
VALUES 
    ('Lunch', 100000.00, 'Lunch with a diverse menu', 'flaticon-033-dinner', GETDATE()),
    ('Dinner', 150000.00, 'Luxury dinner with specialties', 'flaticon-033-dinner', GETDATE()),
    ('Breakfast', 80000.00, 'Continental breakfast with coffee and pastries', NULL, GETDATE()),
    ('Spa Service', 350000.00, 'Full body massage and spa treatment', NULL, GETDATE()),
    ('Airport Pickup', 250000.00, 'Private car pickup from airport to hotel', NULL, GETDATE()),
    ('Laundry Service', 120000.00, 'Same-day laundry and ironing service', 'flaticon-024-towel', GETDATE());
GO

-- iconClass đã được set ngay trong INSERT ở trên

-- SAMPLE DATA - Users
INSERT INTO Users (mobilePhone, firstName, middleName, lastName, birthday, email, password, role, rankId, isBlackList, isActive, createdAt, updatedAt)
VALUES 
    ('+84901234567', N'Hùng', N'Văn', N'Nguyễn', '1992-07-20', 'hung.nguyen@email.com', 'hashed_password5', 'customer', 1, 0, 1, GETDATE(), GETDATE()),
    ('+84901234568', N'Linh', N'Thị', N'Trần', '1990-05-15', 'linh.tran@email.com', 'hashed_password6', 'customer', 2, 0, 1, GETDATE(), GETDATE()),
    ('0901234569', N'Mai', N'Thị', N'Nguyễn', '1988-03-10', 'mai.nguyen@hotel.com', 'receptionist123', 'receptionist', NULL, 0, 1, GETDATE(), GETDATE()),
    ('0987654321', 'John', '', 'Doe', '1985-06-15', 'john.doe@example.com', 'password123', 'customer', 1, 0, 1, GETDATE(), GETDATE()),
    ('0987654322', 'Jane', '', 'Smith', '1990-08-22', 'jane.smith@example.com', 'password123', 'customer', 2, 0, 1, GETDATE(), GETDATE()),
    ('0987654323', 'Robert', '', 'Johnson', '1978-03-10', 'robert.johnson@example.com', 'password123', 'customer', 3, 0, 1, GETDATE(), GETDATE());
GO

-- SAMPLE DATA - Rooms
INSERT INTO Room (name, categoryId, price, capacity, status, description, imgUrl, updatedAt)
VALUES 
    (N'Family 101', 1, 800000.00, 2, 'available', N'Family room 101 with city view', NULL, GETDATE()),
    (N'Family 102', 1, 800000.00, 2, 'available', N'Family room 102 with basic amenities', NULL, GETDATE()),
    (N'Deluxe 201', 2, 2000000.00, 4, 'booked', N'Deluxe room 201 with balcony and premium amenities (Booked)', NULL, GETDATE()),
    (N'Deluxe 202', 2, 2000000.00, 4, 'available', N'Deluxe room 202 with sea view', NULL, GETDATE()),
    (N'Double 301', 3, 950000.00, 2, 'available', N'Spacious double room with basic amenities', NULL, GETDATE()),
    (N'Double 302', 3, 950000.00, 2, 'available', N'Double room with a nice view', NULL, GETDATE());
GO

-- SAMPLE DATA - Bookings with Invoices
-- Booking 1: John Doe (userId=4) - WITH Invoice
INSERT INTO Booking (userId, roomId, checkinTime, checkoutTime, status, totalPrice)
VALUES (4, 1, DATEADD(DAY, -5, GETDATE()), DATEADD(DAY, -3, GETDATE()), 'confirmed', 1600000.00);

DECLARE @booking1 INT = SCOPE_IDENTITY();

INSERT INTO BookingDetail (bookingId, roomId, priceAtBooking, guestCount, specialRequest)
VALUES (@booking1, 1, 800000.00, 2, 'Extra pillows please');

INSERT INTO ServiceRequest (bookingId, serviceTypeId, price, status)
VALUES 
    (@booking1, 1, 100000.00, 'completed'),
    (@booking1, 3, 80000.00, 'completed'),
    (@booking1, 6, 120000.00, 'completed');

-- Compute totalPrice after details are inserted
UPDATE Booking
SET totalPrice = COALESCE((
    SELECT SUM(bd.priceAtBooking) * (DATEDIFF(HOUR, Booking.checkinTime, Booking.checkoutTime) / 24.0)
    FROM BookingDetail bd
    WHERE bd.bookingId = Booking.bookingId
), 0) * COALESCE((
    SELECT (1 - r.discountPercentage / 100)
    FROM Rank r
    INNER JOIN Users u ON u.rankId = r.rankId
    WHERE u.userId = Booking.userId
), 1)
WHERE bookingId = @booking1;

INSERT INTO Invoice (bookingId, totalRoomCost, totalServiceCost, taxAmount, totalAmount, issuedDate)
VALUES (@booking1, 800000.00, 300000.00, 110000.00, 1210000.00, DATEADD(DAY, -4, GETDATE()));
GO

-- Booking 2: Jane Smith (userId=5) - WITH Invoice
INSERT INTO Booking (userId, roomId, checkinTime, checkoutTime, status, totalPrice)
VALUES (5, 2, DATEADD(DAY, -7, GETDATE()), DATEADD(DAY, -5, GETDATE()), 'confirmed', 1900000.00);

DECLARE @booking2 INT = SCOPE_IDENTITY();

INSERT INTO BookingDetail (bookingId, roomId, priceAtBooking, guestCount, specialRequest)
VALUES 
    (@booking2, 2, 800000.00, 2, 'Room with good view'),
    (@booking2, 5, 950000.00, 2, 'Late check-in');

INSERT INTO ServiceRequest (bookingId, serviceTypeId, price, status)
VALUES 
    (@booking2, 1, 100000.00, 'completed'),
    (@booking2, 2, 150000.00, 'completed'),
    (@booking2, 3, 80000.00, 'completed');

-- Compute totalPrice after details are inserted
UPDATE Booking
SET totalPrice = COALESCE((
    SELECT SUM(bd.priceAtBooking) * (DATEDIFF(HOUR, Booking.checkinTime, Booking.checkoutTime) / 24.0)
    FROM BookingDetail bd
    WHERE bd.bookingId = Booking.bookingId
), 0) * COALESCE((
    SELECT (1 - r.discountPercentage / 100)
    FROM Rank r
    INNER JOIN Users u ON u.rankId = r.rankId
    WHERE u.userId = Booking.userId
), 1)
WHERE bookingId = @booking2;

INSERT INTO Invoice (bookingId, totalRoomCost, totalServiceCost, taxAmount, totalAmount, issuedDate)
VALUES (@booking2, 1750000.00, 330000.00, 208000.00, 2288000.00, DATEADD(DAY, -6, GETDATE()));
GO

-- Booking 3: Robert Johnson (userId=6) - WITH Invoice
INSERT INTO Booking (userId, roomId, checkinTime, checkoutTime, status, totalPrice)
VALUES (6, 3, DATEADD(DAY, -10, GETDATE()), DATEADD(DAY, -8, GETDATE()), 'confirmed', 4000000.00);

DECLARE @booking3 INT = SCOPE_IDENTITY();

INSERT INTO BookingDetail (bookingId, roomId, priceAtBooking, guestCount, specialRequest)
VALUES 
    (@booking3, 3, 2000000.00, 3, 'Champagne on arrival'),
    (@booking3, 4, 2000000.00, 2, 'Quiet room away from elevator');

INSERT INTO ServiceRequest (bookingId, serviceTypeId, price, status)
VALUES 
    (@booking3, 1, 100000.00, 'completed'),
    (@booking3, 2, 150000.00, 'completed'),
    (@booking3, 3, 80000.00, 'completed'),
    (@booking3, 4, 350000.00, 'completed'),
    (@booking3, 5, 250000.00, 'completed');

-- Compute totalPrice after details are inserted
UPDATE Booking
SET totalPrice = COALESCE((
    SELECT SUM(bd.priceAtBooking) * (DATEDIFF(HOUR, Booking.checkinTime, Booking.checkoutTime) / 24.0)
    FROM BookingDetail bd
    WHERE bd.bookingId = Booking.bookingId
), 0) * COALESCE((
    SELECT (1 - r.discountPercentage / 100)
    FROM Rank r
    INNER JOIN Users u ON u.rankId = r.rankId
    WHERE u.userId = Booking.userId
), 1)
WHERE bookingId = @booking3;

INSERT INTO Invoice (bookingId, totalRoomCost, totalServiceCost, taxAmount, totalAmount, issuedDate)
VALUES (@booking3, 4000000.00, 930000.00, 493000.00, 5423000.00, DATEADD(DAY, -9, GETDATE()));
GO

-- Booking 4: John Doe (userId=4) - WITH Invoice (additional)
INSERT INTO Booking (userId, roomId, checkinTime, checkoutTime, status, totalPrice)
VALUES (4, 4, DATEADD(DAY, -15, GETDATE()), DATEADD(DAY, -13, GETDATE()), 'confirmed', 1600000.00);

DECLARE @booking4 INT = SCOPE_IDENTITY();

INSERT INTO BookingDetail (bookingId, roomId, priceAtBooking, guestCount, specialRequest)
VALUES (@booking4, 1, 800000.00, 2, 'High floor room');

INSERT INTO ServiceRequest (bookingId, serviceTypeId, price, status)
VALUES 
    (@booking4, 1, 100000.00, 'completed'),
    (@booking4, 3, 80000.00, 'completed');

-- Compute totalPrice after details are inserted
UPDATE Booking
SET totalPrice = COALESCE((
    SELECT SUM(bd.priceAtBooking) * (DATEDIFF(HOUR, Booking.checkinTime, Booking.checkoutTime) / 24.0)
    FROM BookingDetail bd
    WHERE bd.bookingId = Booking.bookingId
), 0) * COALESCE((
    SELECT (1 - r.discountPercentage / 100)
    FROM Rank r
    INNER JOIN Users u ON u.rankId = r.rankId
    WHERE u.userId = Booking.userId
), 1)
WHERE bookingId = @booking4;

INSERT INTO Invoice (bookingId, totalRoomCost, totalServiceCost, taxAmount, totalAmount, issuedDate)
VALUES (@booking4, 800000.00, 180000.00, 98000.00, 1078000.00, DATEADD(DAY, -14, GETDATE()));
GO

-- Booking 5: Jane Smith (userId=5) - WITH Invoice (additional)
INSERT INTO Booking (userId, roomId, checkinTime, checkoutTime, status, totalPrice)
VALUES (5, 5, DATEADD(DAY, -20, GETDATE()), DATEADD(DAY, -18, GETDATE()), 'confirmed', 1900000.00);

DECLARE @booking5 INT = SCOPE_IDENTITY();

INSERT INTO BookingDetail (bookingId, roomId, priceAtBooking, guestCount, specialRequest)
VALUES 
    (@booking5, 2, 800000.00, 2, 'City view room'),
    (@booking5, 5, 950000.00, 2, 'Late checkout');

INSERT INTO ServiceRequest (bookingId, serviceTypeId, price, status)
VALUES 
    (@booking5, 1, 100000.00, 'completed'),
    (@booking5, 2, 150000.00, 'completed'),
    (@booking5, 3, 80000.00, 'completed');

-- Compute totalPrice after details are inserted
UPDATE Booking
SET totalPrice = COALESCE((
    SELECT SUM(bd.priceAtBooking) * (DATEDIFF(HOUR, Booking.checkinTime, Booking.checkoutTime) / 24.0)
    FROM BookingDetail bd
    WHERE bd.bookingId = Booking.bookingId
), 0) * COALESCE((
    SELECT (1 - r.discountPercentage / 100)
    FROM Rank r
    INNER JOIN Users u ON u.rankId = r.rankId
    WHERE u.userId = Booking.userId
), 1)
WHERE bookingId = @booking5;

INSERT INTO Invoice (bookingId, totalRoomCost, totalServiceCost, taxAmount, totalAmount, issuedDate)
VALUES (@booking5, 1750000.00, 330000.00, 208000.00, 2288000.00, DATEADD(DAY, -19, GETDATE()));
GO

-- SAMPLE DATA - Bookings WITHOUT Invoices
-- Booking 6: John Doe (userId=4) - NO Invoice
INSERT INTO Booking (userId, roomId, checkinTime, checkoutTime, status, totalPrice)
VALUES (4, 6, DATEADD(DAY, -2, GETDATE()), DATEADD(DAY, -1, GETDATE()), 'confirmed', 1200000.00);

DECLARE @booking6 INT = SCOPE_IDENTITY();

INSERT INTO BookingDetail (bookingId, roomId, priceAtBooking, guestCount, specialRequest)
VALUES 
    (@booking6, 1, 600000.00, 2, 'Late checkout requested'),
    (@booking6, 2, 600000.00, 1, 'Quiet room please');

INSERT INTO ServiceRequest (bookingId, serviceTypeId, price, status)
VALUES 
    (@booking6, 1, 100000.00, 'completed'),
    (@booking6, 3, 80000.00, 'completed');

-- Compute totalPrice after details are inserted
UPDATE Booking
SET totalPrice = COALESCE((
    SELECT SUM(bd.priceAtBooking) * (DATEDIFF(HOUR, Booking.checkinTime, Booking.checkoutTime) / 24.0)
    FROM BookingDetail bd
    WHERE bd.bookingId = Booking.bookingId
), 0) * COALESCE((
    SELECT (1 - r.discountPercentage / 100)
    FROM Rank r
    INNER JOIN Users u ON u.rankId = r.rankId
    WHERE u.userId = Booking.userId
), 1)
WHERE bookingId = @booking6;
GO

-- Booking 7: Jane Smith (userId=5) - NO Invoice
INSERT INTO Booking (userId, roomId, checkinTime, checkoutTime, status, totalPrice)
VALUES (5, 1, DATEADD(DAY, -1, GETDATE()), GETDATE(), 'confirmed', 1500000.00);

DECLARE @booking7 INT = SCOPE_IDENTITY();

INSERT INTO BookingDetail (bookingId, roomId, priceAtBooking, guestCount, specialRequest)
VALUES 
    (@booking7, 3, 750000.00, 2, 'Ocean view preferred'),
    (@booking7, 4, 750000.00, 2, 'Extra towels');

INSERT INTO ServiceRequest (bookingId, serviceTypeId, price, status)
VALUES 
    (@booking7, 2, 150000.00, 'completed'),
    (@booking7, 5, 250000.00, 'completed');

-- Compute totalPrice after details are inserted
UPDATE Booking
SET totalPrice = COALESCE((
    SELECT SUM(bd.priceAtBooking) * (DATEDIFF(HOUR, Booking.checkinTime, Booking.checkoutTime) / 24.0)
    FROM BookingDetail bd
    WHERE bd.bookingId = Booking.bookingId
), 0) * COALESCE((
    SELECT (1 - r.discountPercentage / 100)
    FROM Rank r
    INNER JOIN Users u ON u.rankId = r.rankId
    WHERE u.userId = Booking.userId
), 1)
WHERE bookingId = @booking7;
GO

-- Booking 8: Robert Johnson (userId=6) - NO Invoice
INSERT INTO Booking (userId, roomId, checkinTime, checkoutTime, status, totalPrice)
VALUES (6, 2, DATEADD(DAY, -3, GETDATE()), DATEADD(DAY, -2, GETDATE()), 'confirmed', 2200000.00);

DECLARE @booking8 INT = SCOPE_IDENTITY();

INSERT INTO BookingDetail (bookingId, roomId, priceAtBooking, guestCount, specialRequest)
VALUES
    (@booking8, 5, 1100000.00, 3, 'VIP treatment'),
    (@booking8, 6, 1100000.00, 2, 'Champagne on arrival');

INSERT INTO ServiceRequest (bookingId, serviceTypeId, price, status)
VALUES 
    (@booking8, 1, 100000.00, 'completed'),
    (@booking8, 2, 150000.00, 'completed'),
    (@booking8, 4, 350000.00, 'completed');

-- Compute totalPrice after details are inserted
UPDATE Booking
SET totalPrice = COALESCE((
    SELECT SUM(bd.priceAtBooking) * (DATEDIFF(HOUR, Booking.checkinTime, Booking.checkoutTime) / 24.0)
    FROM BookingDetail bd
    WHERE bd.bookingId = Booking.bookingId
), 0) * COALESCE((
    SELECT (1 - r.discountPercentage / 100)
    FROM Rank r
    INNER JOIN Users u ON u.rankId = r.rankId
    WHERE u.userId = Booking.userId
), 1)
WHERE bookingId = @booking8;
GO


