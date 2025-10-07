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
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Users_Rank FOREIGN KEY (rankId) REFERENCES Rank(rankId) ON DELETE SET NULL
);

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
    updatedAt DATETIME DEFAULT GETDATE()
);

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
    updatedAt DATETIME DEFAULT GETDATE()
);

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
    updatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Room_Category FOREIGN KEY (categoryId) REFERENCES Category(categoryId) ON DELETE NO ACTION
);

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
    userId INT NOT NULL,
    checkinTime DATETIME NOT NULL,
    checkoutTime DATETIME NOT NULL,
    durationHours DECIMAL(10,2) NOT NULL,
    status VARCHAR(15) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled')),
    totalPrice DECIMAL(10,2) NOT NULL,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Booking_User FOREIGN KEY (userId) REFERENCES Users(userId) ON DELETE CASCADE,
    CONSTRAINT CHK_Booking_Dates CHECK (checkinTime < checkoutTime)
);

-- Trigger để tự động tính durationHours và totalPrice trong Booking
CREATE TRIGGER trg_update_booking
ON Booking
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE Booking
    SET durationHours = DATEDIFF(HOUR, inserted.checkinTime, inserted.checkoutTime),
        totalPrice = (
            SELECT SUM(bd.priceAtBooking) * (DATEDIFF(HOUR, inserted.checkinTime, inserted.checkoutTime) / 24.0)
            FROM BookingDetail bd
            WHERE bd.bookingId = inserted.bookingId
        ) * 
        COALESCE((
            SELECT (1 - r.discountPercentage / 100)
            FROM Rank r
            INNER JOIN Users u ON u.rankId = r.rankId
            WHERE u.userId = inserted.userId
        ), 1),
        updatedAt = GETDATE()
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

CREATE TRIGGER trg_update_booking
ON Booking
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE Booking
    SET durationHours = DATEDIFF(HOUR, inserted.checkinTime, inserted.checkoutTime),
        totalPrice = COALESCE((
            SELECT SUM(bd.priceAtBooking) * (DATEDIFF(HOUR, inserted.checkinTime, inserted.checkoutTime) / 24.0)
            FROM BookingDetail bd
            WHERE bd.bookingId = inserted.bookingId
        ), 0) * 
        COALESCE((
            SELECT (1 - r.discountPercentage / 100)
            FROM Rank r
            INNER JOIN Users u ON u.rankId = r.rankId
            WHERE u.userId = inserted.userId
        ), 1),
        updatedAt = GETDATE()
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

-- Insert Sample Data
-- Insert Rank
INSERT INTO Rank (name, description, minBookings, discountPercentage, createdAt, updatedAt)
VALUES 
    (N'Đồng', N'Cấp cơ bản cho khách hàng mới', 0, 0.00, GETDATE(), GETDATE()),
    (N'Bạc', N'Cấp bạc cho khách hàng trung thành', 5, 5.00, GETDATE(), GETDATE()),
    (N'Vàng', N'Cấp vàng cho khách hàng VIP', 10, 10.00, GETDATE(), GETDATE()),
    (N'Kim cương', N'Cấp cao nhất với ưu đãi đặc biệt', 20, 15.00, GETDATE(), GETDATE());

-- Insert Category
INSERT INTO Category (name, description, updatedAt)
VALUES 
    (N'Standard', N'Phòng tiêu chuẩn với tiện nghi cơ bản', GETDATE()),
    (N'VIP', N'Phòng sang trọng với tiện nghi cao cấp', GETDATE());

-- Insert Users
INSERT INTO Users (mobilePhone, firstName, middleName, lastName, birthday, email, password, role, rankId, isBlackList, isActive, createdAt, updatedAt)
VALUES 
    ('+84901234567', N'Hùng', N'Văn', N'Nguyễn', '1992-07-20', 'hung.nguyen@email.com', 'hashed_password5', 'customer', 1, 0, 1, GETDATE(), GETDATE()),
    ('+84901234568', N'Linh', N'Thị', N'Trần', '1990-05-15', 'linh.tran@email.com', 'hashed_password6', 'customer', 2, 0, 1, GETDATE(), GETDATE());

-- Insert Services
INSERT INTO Services (name, price, description, updatedAt)
VALUES 
    (N'Bữa trưa', 100000.00, N'Bữa trưa với thực đơn đa dạng', GETDATE()),
    (N'Bữa tối', 150000.00, N'Bữa tối sang trọng với các món đặc sản', GETDATE());


-- Insert Room
INSERT INTO Room (name, categoryId, price, capacity, status, description, updatedAt)
VALUES 
    (N'Phòng Standard 101', 1, 800000.00, 2, 'available', N'Phòng tiêu chuẩn với view thành phố', GETDATE()),
    (N'Phòng Standard 102', 1, 800000.00, 2, 'available', N'Phòng tiêu chuẩn với tiện nghi cơ bản', GETDATE()),
    (N'Phòng VIP 201', 2, 2000000.00, 4, 'booked', N'Phòng VIP với ban công và tiện nghi cao cấp', GETDATE()),
    (N'Phòng VIP 202', 2, 2000000.00, 4, 'available', N'Phòng VIP với view biển', GETDATE());


-- Insert Booking (tính durationHours và totalPrice thủ công)
INSERT INTO Booking (userId, checkinTime, checkoutTime, durationHours, status, totalPrice, createdAt, updatedAt)
VALUES 
    (1, '2025-10-10 14:00:00', '2025-10-11 12:00:00', 0, 'confirmed', 0, GETDATE(), GETDATE()),
    (2, '2025-10-15 15:00:00', '2025-10-17 11:00:00', 0, 'confirmed', 0, GETDATE(), GETDATE()),
    (1, '2025-10-05 12:00:00', '2025-10-06 12:00:00', 0, 'confirmed', 0, GETDATE(), GETDATE());

-- Insert BookingDetail
INSERT INTO BookingDetail (bookingId, roomId, priceAtBooking, guestCount, specialRequest, createdAt, updatedAt)
VALUES 
    (10, 1, 800000.00, 2, N'Giường phụ', GETDATE(), GETDATE()),
    (11, 3, 2000000.00, 3, N'View biển', GETDATE(), GETDATE()),
    (12, 4, 2000000.00, 4, NULL, GETDATE(), GETDATE());

-- Insert BookingHistory
INSERT INTO BookingHistory (userId, bookingId, completedAt)
VALUES 
    (1, 10, GETDATE()),
    (1, 12, GETDATE());


-- Insert Payment
INSERT INTO Payment (bookingId, amount, method, status, transactionTime, updatedAt)
VALUES 
    (10, 800000.00, 'Chuyển khoản', 'completed', GETDATE(), GETDATE()), -- 800000 * 1 ngày, không giảm giá (Đồng)
    (11, 3800000.00, 'Chuyển khoản', 'pending', GETDATE(), GETDATE()), -- (2000000 + 2000000) * 2 ngày * 95% (Bạc)
    (12, 2000000.00, 'Tiền mặt', 'completed', GETDATE(), GETDATE()); -- 2000000 * 1 ngày, không giảm giá (Đồng)

-- Insert Invoice
INSERT INTO Invoice (bookingId, totalRoomCost, totalServiceCost, taxAmount, totalAmount, issuedDate, updatedAt)
VALUES 
    (10, 800000.00, 100000.00, 90000.00, 990000.00, GETDATE(), GETDATE()), -- 800000 (phòng) + 100000 (bữa trưa) + 10% thuế
    (11, 3800000.00, 150000.00, 395000.00, 4345000.00, GETDATE(), GETDATE()), -- 3800000 (phòng) + 150000 (bữa tối) + 10% thuế
    (12, 2000000.00, 150000.00, 215000.00, 2365000.00, GETDATE(), GETDATE()); -- 2000000 (phòng) + 150000 (bữa tối) + 10% thuế

-- Insert Wishlist
INSERT INTO Wishlist (userId, roomId, updatedAt)
VALUES 
    (1, 1, GETDATE()),
    (1, 3, GETDATE()),
    (2, 4, GETDATE());

-- Insert Cart
INSERT INTO Cart (userId, roomId, quantity, updatedAt)
VALUES 
    (1, 1, 1, GETDATE()),
    (1, 3, 1, GETDATE()),
    (2, 4, 1, GETDATE());

-- Insert Feedback
INSERT INTO Feedback (userId, bookingId, content, rating, created_at, updatedAt)
VALUES 
    (1, 10, N'Phòng sạch sẽ, nhân viên thân thiện!', 5, GETDATE(), GETDATE()),
    (2, 11, N'Dịch vụ tốt, nhưng check-in hơi chậm.', 4, GETDATE(), GETDATE()),
    (1, 12, N'Phòng VIP đẹp nhưng giá cao.', 3, GETDATE(), GETDATE());

-- Insert ServiceRequest
INSERT INTO ServiceRequest (bookingId, serviceTypeId, price, status, updatedAt)
VALUES 
    (10, 1, 100000.00, 'completed', GETDATE()), -- Bữa trưa
    (11, 2, 150000.00, 'requested', GETDATE()), -- Bữa tối
    (12, 2, 150000.00, 'completed', GETDATE()); -- Bữa tối


