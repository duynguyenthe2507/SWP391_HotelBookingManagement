-- Tạo database
CREATE DATABASE HMBS_DB;
GO

USE HMBS_DB;
GO

-- Table: User
CREATE TABLE [User] (
    userId INT IDENTITY(1,1) PRIMARY KEY,
    mobilePhone VARCHAR(20) NOT NULL UNIQUE,
    fullName NVARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL CHECK (role IN ('receptionist', 'admin', 'customer')),
    isBlackList BIT DEFAULT 0,
    isActive BIT DEFAULT 1,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME DEFAULT GETDATE()
);

-- Table: Services
CREATE TABLE Services (
    serviceId INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description NVARCHAR(500) NULL
);

-- Table: Room
CREATE TABLE Room (
    roomId INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    capacity INT NOT NULL,
    status VARCHAR(50) DEFAULT 'available' CHECK (status IN ('available', 'booked', 'maintenance')),
    description NVARCHAR(500)
);

-- Table: Booking
CREATE TABLE Booking (
    bookingId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    roomId INT NOT NULL,
    checkinTime DATETIME NOT NULL,
    checkoutTime DATETIME NOT NULL,
    durationHours DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'cancelled')),
    totalPrice DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_Booking_User FOREIGN KEY (userId) REFERENCES [User](userId) ON DELETE CASCADE,
    CONSTRAINT FK_Booking_Room FOREIGN KEY (roomId) REFERENCES Room(roomId) ON DELETE CASCADE
);

-- Table: Payment
CREATE TABLE Payment (
    paymentId INT IDENTITY(1,1) PRIMARY KEY,
    bookingId INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    method VARCHAR(50) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed')),
    transactionTime DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Payment_Booking FOREIGN KEY (bookingId) REFERENCES Booking(bookingId) ON DELETE CASCADE
);

-- Table: Wishlist
CREATE TABLE Wishlist (
    wishlistId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    roomId INT NOT NULL,
    CONSTRAINT FK_Wishlist_User FOREIGN KEY (userId) REFERENCES [User](userId) ON DELETE CASCADE,
    CONSTRAINT FK_Wishlist_Room FOREIGN KEY (roomId) REFERENCES Room(roomId) ON DELETE CASCADE,
    CONSTRAINT UQ_Wishlist_UserRoom UNIQUE (userId, roomId)
);

-- Table: Cart
CREATE TABLE Cart (
    cartId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    roomId INT NOT NULL,
    quantity INT DEFAULT 1,
    CONSTRAINT FK_Cart_User FOREIGN KEY (userId) REFERENCES [User](userId) ON DELETE CASCADE,
    CONSTRAINT FK_Cart_Room FOREIGN KEY (roomId) REFERENCES Room(roomId) ON DELETE CASCADE,
    CONSTRAINT UQ_Cart_UserRoom UNIQUE (userId, roomId)
);

-- Table: Feedback
CREATE TABLE Feedback (
    feedbackId INT IDENTITY(1,1) PRIMARY KEY,
    userId INT NOT NULL,
    bookingId INT NOT NULL,
    content NVARCHAR(1000),
    rating INT CHECK (rating BETWEEN 1 AND 5),
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Feedback_User FOREIGN KEY (userId) REFERENCES [User](userId) ON DELETE NO ACTION,
    CONSTRAINT FK_Feedback_Room FOREIGN KEY (bookingId) REFERENCES Booking(bookingId) ON DELETE CASCADE
);


-- Table: ServiceRequest
CREATE TABLE ServiceRequest (
    serviceId INT IDENTITY(1,1) PRIMARY KEY,
    bookingId INT NOT NULL,
    serviceTypeId INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'requested' CHECK (status IN ('requested', 'completed', 'cancelled')),
    CONSTRAINT FK_ServiceRequest_Booking FOREIGN KEY (bookingId) REFERENCES Booking(bookingId) ON DELETE CASCADE,
    CONSTRAINT FK_ServiceRequest_Service FOREIGN KEY (serviceTypeId) REFERENCES Services(serviceId) ON DELETE NO ACTION
);

