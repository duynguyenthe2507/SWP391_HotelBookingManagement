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
    (N'Bronze', N'Cấp cơ bản cho khách hàng mới', 0, 0.00, GETDATE(), GETDATE()),
    (N'Silver', N'Cấp bạc cho khách hàng trung thành', 5, 5.00, GETDATE(), GETDATE()),
    (N'Gold', N'Cấp vàng cho khách hàng VIP', 10, 10.00, GETDATE(), GETDATE()),
    (N'Diamond', N'Cấp cao nhất với ưu đãi đặc biệt', 20, 15.00, GETDATE(), GETDATE());

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




UPDATE [dbo].[Category]
   SET name = 'Family'
      ,[description] = N'Phòng gia đình đẳng cấp'
      ,[updatedAt] = GETDATE()
 WHERE categoryId = 1
GO


UPDATE [dbo].[Category]
   SET name = 'Deluxe'
      ,[description] = N'Phòng sang trọng đấy'
      ,[updatedAt] = GETDATE()
 WHERE categoryId = 2
GO


Insert into Category (name, description, updatedAt) values 
('Double', N'Phòng 2 giường', GETDATE()),
('Premium King', N'Phòng này xịn đấy', GETDATE())


UPDATE Rank SET name = 'Bronze', description = 'Basic tier for new customers', updatedAt = GETDATE() WHERE rankId = 1;
UPDATE Rank SET name = 'Silver', description = 'Silver tier for loyal customers', updatedAt = GETDATE() WHERE rankId = 2;
UPDATE Rank SET name = 'Gold', description = 'Gold tier for VIP customers', updatedAt = GETDATE() WHERE rankId = 3;
UPDATE Rank SET name = 'Diamond', description = 'Highest tier with special privileges', updatedAt = GETDATE() WHERE rankId = 4;


-- Cập nhật bản ghi CategoryId = 1 (trước đó là Family)
UPDATE Category SET name = 'Family', description = 'Premium family room', updatedAt = GETDATE() WHERE categoryId = 1;

-- Cập nhật bản ghi CategoryId = 2 (trước đó là Deluxe)
UPDATE Category SET name = 'Deluxe', description = 'Luxurious room', updatedAt = GETDATE() WHERE categoryId = 2;

-- Cập nhật bản ghi mới chèn (Double, Premium King)
-- Giả sử CategoryId = 3 là 'Double'
UPDATE Category SET name = 'Double', description = 'Room with two beds', updatedAt = GETDATE() WHERE name = 'Double';

-- Bước 1: Xóa Category 4 ('Premium King')
DELETE FROM Category 
WHERE categoryId = 4;
GO

-- Bước 2: Cập nhật tên Room cho Category Family (ID 1)
UPDATE Room 
SET 
    name = N'Family 101', 
    description = N'Family room 101 with city view', -- Cập nhật mô tả để đồng bộ
    updatedAt = GETDATE() 
WHERE roomId = 1;

UPDATE Room 
SET 
    name = N'Family 102', 
    description = N'Family room 102 with basic amenities', -- Cập nhật mô tả để đồng bộ
    updatedAt = GETDATE() 
WHERE roomId = 2;

-- Cập nhật tên Room cho Category Deluxe (ID 2)
UPDATE Room 
SET 
    name = N'Deluxe 201', 
    description = N'Deluxe room 201 with balcony and premium amenities (Booked)', -- Cập nhật mô tả
    updatedAt = GETDATE() 
WHERE roomId = 3;

UPDATE Room 
SET 
    name = N'Deluxe 202', 
    description = N'Deluxe room 202 with sea view', -- Cập nhật mô tả
    updatedAt = GETDATE() 
WHERE roomId = 4;
GO

-- Bước 3: Thêm Room cho Category Double (ID 3)
-- Giả sử Category 'Double' có categoryId là 3 (theo thứ tự insert của bạn)
INSERT INTO Room (name, categoryId, price, capacity, status, description, updatedAt)
VALUES 
    (N'Double 301', 3, 950000.00, 2, 'available', N'Spacious double room with basic amenities', GETDATE()),
    (N'Double 302', 3, 950000.00, 2, 'available', N'Double room with a nice view', GETDATE());
GO


UPDATE Services SET name = 'Lunch', description = 'Lunch with a diverse menu', updatedAt = GETDATE() WHERE serviceId = 1;
UPDATE Services SET name = 'Dinner', description = 'Luxury dinner with specialties', updatedAt = GETDATE() WHERE serviceId = 2;

ALTER TABLE Category
ADD imgUrl NVARCHAR(255) NULL;
GO

ALTER TABLE Room
ADD imgUrl NVARCHAR(255) NULL;
GO

-- Update 21/10/2025
UPDATE Category SET imgUrl = 'img/category/family_category.jpg' WHERE categoryId = 1;
UPDATE Category SET imgUrl = 'img/category/deluxe_category.jpg' WHERE categoryId = 2;
UPDATE Category SET imgUrl = 'img/category/double_category.jpg' WHERE categoryId = 3;

INSERT INTO Services (name, price, description)
VALUES ('Laundry', 100000, 'Professional laundry service, keeping your clothes clean and fresh');

ALTER TABLE Services
    ADD iconClass VARCHAR(50);

UPDATE Services SET iconClass = 'flaticon-024-towel' WHERE name = 'Laundry';
UPDATE Services SET iconClass = 'flaticon-033-dinner' WHERE name = 'Dinner';
UPDATE Services SET iconClass = 'flaticon-033-dinner' WHERE name = 'Lunch';

<<<<<<< HEAD
--update 23/10/2025
ALTER TABLE Users
ADD avatar_url NVARCHAR(500) NULL DEFAULT '/img/room/avatar/default-avatar.png';
=======

-- Update: Rules :23/10/2025
CREATE TABLE Rules (
                       ruleId INT IDENTITY(1,1) PRIMARY KEY,
                       title NVARCHAR(255) NOT NULL,
                       description NVARCHAR(MAX) NOT NULL,
                       status BIT DEFAULT 1, -- 1 = Active, 0 = Inactive
                       createdAt DATETIME DEFAULT GETDATE(),
                       updatedAt DATETIME DEFAULT GETDATE()
);
GO

-- Trigger cập nhật thời gian khi sửa rule
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

-- Dữ liệu mẫu
INSERT INTO Rules (title, description, status)
VALUES
(N'Check-in / Check-out', N'Khách có thể nhận phòng từ 14h và trả phòng trước 12h trưa hôm sau.', 1),
(N'Không hút thuốc', N'Vui lòng không hút thuốc trong phòng hoặc khu vực công cộng.', 1),
(N'Thu cưng', N'Không mang thú cưng vào khách sạn.', 1);
>>>>>>> 09230bf4f10612421680170403ad770e37831bd3
GO
