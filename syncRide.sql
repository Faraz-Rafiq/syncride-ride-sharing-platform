-- =========================================================================
-- SYNCRIDE DATABASE SCHEMA (MySQL)
-- =========================================================================

-- Create the database
CREATE DATABASE IF NOT EXISTS syncride_db;
USE syncride_db;

-- =========================================================================
-- 1. TABLES CREATION (with constraints up to 3NF)
-- =========================================================================

-- 1. Users Table
CREATE TABLE IF NOT EXISTS Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20) UNIQUE NOT NULL,
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    Role ENUM('Rider', 'Driver', 'Admin') DEFAULT 'Rider',
    VerificationStatus ENUM('Pending', 'Verified', 'Rejected') DEFAULT 'Pending',
    WalletBalance DECIMAL(10, 2) DEFAULT 5000.00,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Locations Table
CREATE TABLE IF NOT EXISTS Locations (
    LocationID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(150) NOT NULL,
    Latitude DECIMAL(10, 8) NOT NULL,
    Longitude DECIMAL(11, 8) NOT NULL,
    UNIQUE(Latitude, Longitude)
);

-- 3. Ride_Platforms Table
CREATE TABLE IF NOT EXISTS Ride_Platforms (
    PlatformID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(50) UNIQUE NOT NULL,
    BaseFareRate DECIMAL(5, 2) NOT NULL CHECK (BaseFareRate > 0)
);

-- 4. Vehicles Table
CREATE TABLE IF NOT EXISTS Vehicles (
    VehicleID INT AUTO_INCREMENT PRIMARY KEY,
    LicensePlate VARCHAR(20) UNIQUE NOT NULL,
    Make VARCHAR(50) NOT NULL,
    Model VARCHAR(50) NOT NULL,
    Capacity INT NOT NULL CHECK (Capacity BETWEEN 1 AND 7),
    Color VARCHAR(30) NOT NULL
);

-- 5. Drivers Table
CREATE TABLE IF NOT EXISTS Drivers (
    DriverID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    VehicleID INT NOT NULL,
    PlatformID INT NOT NULL,
    Rating DECIMAL(3, 2) DEFAULT 5.00 CHECK (Rating BETWEEN 0 AND 5),
    IsActive BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID) ON DELETE CASCADE,
    FOREIGN KEY (PlatformID) REFERENCES Ride_Platforms(PlatformID) ON DELETE RESTRICT
);

-- 6. Ride_Groups Table
CREATE TABLE IF NOT EXISTS Ride_Groups (
    GroupID INT AUTO_INCREMENT PRIMARY KEY,
    DepartureTime DATETIME NOT NULL,
    SourceLocationID INT NOT NULL,
    DestLocationID INT NOT NULL,
    Status ENUM('Forming', 'Confirmed', 'EnRoute', 'Completed', 'Cancelled') DEFAULT 'Forming',
    DriverID INT NULL,
    GenderPreference ENUM('None', 'MaleOnly', 'FemaleOnly') DEFAULT 'None',
    TotalFare DECIMAL(8, 2) DEFAULT 0.00,
    FOREIGN KEY (SourceLocationID) REFERENCES Locations(LocationID) ON DELETE RESTRICT,
    FOREIGN KEY (DestLocationID) REFERENCES Locations(LocationID) ON DELETE RESTRICT,
    FOREIGN KEY (DriverID) REFERENCES Drivers(DriverID) ON DELETE SET NULL,
    CHECK (SourceLocationID != DestLocationID)
);

-- 7. Ride_Requests Table
CREATE TABLE IF NOT EXISTS Ride_Requests (
    RequestID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    SourceLocationID INT NOT NULL,
    DestLocationID INT NOT NULL,
    ExpectedTime DATETIME NOT NULL,
    GroupID INT NULL,
    Status ENUM('Pending', 'Matched', 'Cancelled') DEFAULT 'Pending',
    RequestTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (SourceLocationID) REFERENCES Locations(LocationID) ON DELETE RESTRICT,
    FOREIGN KEY (DestLocationID) REFERENCES Locations(LocationID) ON DELETE RESTRICT,
    FOREIGN KEY (GroupID) REFERENCES Ride_Groups(GroupID) ON DELETE SET NULL,
    CHECK (SourceLocationID != DestLocationID)
);

-- 8. Group_Members Table
CREATE TABLE IF NOT EXISTS Group_Members (
    GroupID INT NOT NULL,
    UserID INT NOT NULL,
    FareContribution DECIMAL(6, 2) DEFAULT 0.00,
    JoinTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (GroupID, UserID),
    FOREIGN KEY (GroupID) REFERENCES Ride_Groups(GroupID) ON DELETE CASCADE,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- 9. Payments Table
CREATE TABLE IF NOT EXISTS Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    GroupID INT NOT NULL,
    Amount DECIMAL(6, 2) NOT NULL CHECK (Amount >= 0),
    Method ENUM('Card', 'Cash', 'Wallet') NOT NULL,
    Status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Completed',
    PaymentTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (GroupID) REFERENCES Ride_Groups(GroupID) ON DELETE CASCADE
);

-- 10. Reviews Table
CREATE TABLE IF NOT EXISTS Reviews (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,
    ReviewerID INT NOT NULL,
    DriverID INT NOT NULL,
    GroupID INT NOT NULL,
    Rating INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    Comments TEXT,
    ReviewTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ReviewerID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (DriverID) REFERENCES Drivers(DriverID) ON DELETE CASCADE,
    FOREIGN KEY (GroupID) REFERENCES Ride_Groups(GroupID) ON DELETE CASCADE,
    UNIQUE(ReviewerID, GroupID)
);

-- 11. Notifications Table
CREATE TABLE IF NOT EXISTS Notifications (
    NotificationID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    Message TEXT NOT NULL,
    IsRead BOOLEAN DEFAULT FALSE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE
);

-- 12. Saved_Locations Table
CREATE TABLE IF NOT EXISTS Saved_Locations (
    SavedID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    LocationID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (LocationID) REFERENCES Locations(LocationID) ON DELETE CASCADE
);

-- =========================================================================
-- 2. SAMPLE DATA INSERTION (Minimum 10 rows per table)
-- =========================================================================

-- Sample Users
INSERT INTO Users (FullName, Email, Phone, Gender, PasswordHash, Role, VerificationStatus) VALUES
('John Doe', 'john@example.com', '1234567890', 'Male', '$2b$10$xyz', 'Rider', 'Verified'),
('Alice Smith', 'alice@example.com', '1234567891', 'Female', '$2b$10$xyz', 'Rider', 'Verified'),
('Bob Johnson', 'bob@example.com', '1234567892', 'Male', '$2b$10$xyz', 'Rider', 'Pending'),
('Emma Davis', 'emma@example.com', '1234567893', 'Female', '$2b$10$xyz', 'Rider', 'Verified'),
('Michael Wilson', 'michael@example.com', '1234567894', 'Male', '$2b$10$xyz', 'Driver', 'Verified'),
('Sarah Brown', 'sarah@example.com', '1234567895', 'Female', '$2b$10$xyz', 'Driver', 'Verified'),
('James Miller', 'james@example.com', '1234567896', 'Male', '$2b$10$xyz', 'Driver', 'Verified'),
('Lisa Taylor', 'lisa@example.com', '1234567897', 'Female', '$2b$10$xyz', 'Rider', 'Verified'),
('David Anderson', 'david@example.com', '1234567898', 'Male', '$2b$10$xyz', 'Rider', 'Verified'),
('Admin User', 'admin@syncride.com', '0000000000', 'Male', '$2b$10$xyz', 'Admin', 'Verified');

-- Sample Locations (Lahore)
INSERT INTO Locations (Name, Latitude, Longitude) VALUES
('DHA Lahore', 31.4805, 74.4093),
('Gulberg', 31.5102, 74.3441),
('Bahria Town Lahore', 31.3659, 74.1874),
('Johar Town', 31.4697, 74.2728),
('Model Town', 31.4855, 74.3262),
('Cantt Lahore', 31.5204, 74.3987),
('Liberty Market', 31.5126, 74.3456),
('MM Alam Road', 31.5143, 74.3496),
('Packages Mall', 31.4633, 74.3644),
('Emporium Mall', 31.4682, 74.2642),
('FAST NUCES Lahore', 31.4815, 74.3032),
('Lake City', 31.3533, 74.2382),
('Wapda Town', 31.4283, 74.2687),
('Valencia Town', 31.4116, 74.2541),
('Allama Iqbal Town', 31.5124, 74.2845);

-- Sample Platforms
INSERT INTO Ride_Platforms (Name, BaseFareRate) VALUES
('Yango', 50.00),
('Careem', 60.00),
('InDrive', 40.00),
('Bykea', 30.00),
('Uber', 65.00),
('Airlift', 35.00),
('Swvl', 45.00),
('Local Taxi', 55.00),
('Private Carpool', 20.00),
('SyncRide Express', 45.00);

-- Sample Vehicles (Premium)
INSERT INTO Vehicles (LicensePlate, Make, Model, Capacity, Color) VALUES
('LHR-111', 'Honda', 'Civic', 4, 'Black'),
('LHR-222', 'Toyota', 'Corolla', 4, 'White'),
('LHR-333', 'Kia', 'Sportage', 4, 'Silver'),
('LHR-444', 'Hyundai', 'Elantra', 4, 'Grey'),
('LHR-555', 'MG', 'HS', 4, 'Red'),
('LHR-666', 'Changan', 'Alsvin', 4, 'Blue'),
('LHR-777', 'Honda', 'City', 4, 'White'),
('LHR-888', 'Proton', 'Saga', 4, 'Black'),
('LHR-999', 'Haval', 'H6', 4, 'Silver'),
('LHR-000', 'Toyota', 'Yaris', 4, 'White');

-- Sample Drivers
INSERT INTO Drivers (UserID, VehicleID, PlatformID, Rating) VALUES
(5, 1, 1, 4.8),
(6, 2, 2, 4.9),
(7, 3, 3, 4.5),
(1, 4, 4, 4.7), -- John is also a driver
(2, 5, 1, 4.6),
(3, 6, 2, 4.2),
(4, 7, 3, 4.9),
(8, 8, 4, 4.8),
(9, 9, 1, 4.4),
(10, 10, 2, 5.0);

-- Sample Ride Groups
INSERT INTO Ride_Groups (DepartureTime, SourceLocationID, DestLocationID, Status, DriverID, TotalFare) VALUES
('2026-05-10 08:00:00', 1, 2, 'Completed', 1, 500.00),
('2026-05-10 09:30:00', 3, 4, 'Completed', 2, 600.00),
('2026-05-11 17:00:00', 5, 1, 'Completed', 3, 450.00),
('2026-05-12 18:00:00', 6, 7, 'Completed', 4, 800.00),
('2026-05-12 18:30:00', 8, 9, 'Cancelled', 5, 0.00),
('2026-05-13 08:15:00', 2, 1, 'EnRoute', 6, 550.00),
('2026-05-13 14:00:00', 10, 3, 'Forming', NULL, 0.00),
('2026-05-13 15:00:00', 4, 5, 'Forming', NULL, 0.00),
('2026-05-14 09:00:00', 7, 8, 'Confirmed', 9, 700.00),
('2026-05-14 10:00:00', 1, 6, 'Completed', 10, 900.00);

-- Sample Ride Requests
INSERT INTO Ride_Requests (UserID, SourceLocationID, DestLocationID, ExpectedTime, GroupID, Status) VALUES
(1, 1, 2, '2026-05-10 08:05:00', 1, 'Matched'),
(2, 1, 2, '2026-05-10 08:10:00', 1, 'Matched'),
(3, 3, 4, '2026-05-10 09:25:00', 2, 'Matched'),
(4, 5, 1, '2026-05-11 16:55:00', 3, 'Matched'),
(8, 6, 7, '2026-05-12 17:50:00', 4, 'Matched'),
(9, 8, 9, '2026-05-12 18:25:00', 5, 'Cancelled'),
(1, 2, 1, '2026-05-13 08:10:00', 6, 'Matched'),
(2, 10, 3, '2026-05-13 13:55:00', 7, 'Pending'),
(3, 4, 5, '2026-05-13 14:50:00', 8, 'Pending'),
(4, 7, 8, '2026-05-14 08:50:00', 9, 'Matched');

-- Sample Group Members
INSERT INTO Group_Members (GroupID, UserID, FareContribution) VALUES
(1, 1, 250.00),
(1, 2, 250.00),
(2, 3, 600.00),
(3, 4, 450.00),
(4, 8, 800.00),
(5, 9, 0.00),
(6, 1, 550.00),
(9, 4, 700.00),
(10, 1, 450.00),
(10, 2, 450.00);

-- Sample Payments
INSERT INTO Payments (UserID, GroupID, Amount, Method, Status) VALUES
(1, 1, 250.00, 'Card', 'Completed'),
(2, 1, 250.00, 'Wallet', 'Completed'),
(3, 2, 600.00, 'Cash', 'Completed'),
(4, 3, 450.00, 'Card', 'Completed'),
(8, 4, 800.00, 'Wallet', 'Completed'),
(1, 6, 550.00, 'Card', 'Pending'),
(4, 9, 700.00, 'Cash', 'Pending'),
(1, 10, 450.00, 'Card', 'Completed'),
(2, 10, 450.00, 'Wallet', 'Completed'),
(3, 2, 50.00, 'Cash', 'Failed'); -- Failed extra charge

-- Sample Reviews
INSERT INTO Reviews (ReviewerID, DriverID, GroupID, Rating, Comments) VALUES
(1, 1, 1, 5, 'Great ride, very on time!'),
(2, 1, 1, 4, 'Good music, safe driving.'),
(3, 2, 2, 5, 'Very professional.'),
(4, 3, 3, 4, 'A bit late but good overall.'),
(8, 4, 4, 5, 'Excellent service!'),
(1, 6, 6, 4, 'Smooth journey.'),
(4, 9, 9, 3, 'Average experience.'),
(1, 10, 10, 5, 'Best driver ever.'),
(2, 10, 10, 5, 'Highly recommended.'),
(3, 2, 2, 5, 'Smooth.'); -- Duplicate context handled by unique constraint logic (just for distinct users normally, handled here as different review insert if needed)

-- =========================================================================
-- 3. ADVANCED SQL QUERIES (Demonstration)
-- =========================================================================

-- A. SELECT with WHERE, GROUP BY, HAVING, ORDER BY
-- Find users who have contributed more than 500 in total fare, ordered by amount
SELECT 
    U.FullName, 
    SUM(GM.FareContribution) as TotalSpent
FROM Users U
JOIN Group_Members GM ON U.UserID = GM.UserID
WHERE U.Role = 'Rider'
GROUP BY U.UserID, U.FullName
HAVING TotalSpent > 500
ORDER BY TotalSpent DESC;

-- B. JOINS (INNER, LEFT, RIGHT, FULL OUTER SIMULATION)
-- 1. INNER JOIN: Get active ride groups with driver names and platform
SELECT 
    RG.GroupID, 
    L1.Name as Source, 
    L2.Name as Destination, 
    U.FullName as DriverName, 
    P.Name as PlatformName
FROM Ride_Groups RG
INNER JOIN Locations L1 ON RG.SourceLocationID = L1.LocationID
INNER JOIN Locations L2 ON RG.DestLocationID = L2.LocationID
INNER JOIN Drivers D ON RG.DriverID = D.DriverID
INNER JOIN Users U ON D.UserID = U.UserID
INNER JOIN Ride_Platforms P ON D.PlatformID = P.PlatformID;

-- 2. LEFT JOIN: Get all locations and count of ride requests originating from them (even if 0)
SELECT 
    L.Name as LocationName, 
    COUNT(RR.RequestID) as RequestCount
FROM Locations L
LEFT JOIN Ride_Requests RR ON L.LocationID = RR.SourceLocationID
GROUP BY L.LocationID, L.Name;

-- 3. RIGHT JOIN: List all vehicles and any assigned active drivers
SELECT 
    V.LicensePlate, 
    V.Model, 
    D.DriverID
FROM Drivers D
RIGHT JOIN Vehicles V ON D.VehicleID = V.VehicleID;

-- 4. FULL OUTER JOIN Simulation (MySQL doesn't support FULL OUTER directly, so we use UNION)
-- Get all users and all drivers, matching where possible
SELECT U.FullName, D.Rating 
FROM Users U LEFT JOIN Drivers D ON U.UserID = D.UserID
UNION
SELECT U.FullName, D.Rating 
FROM Users U RIGHT JOIN Drivers D ON U.UserID = D.UserID;

-- C. SUBQUERIES
-- 1. Correlated Subquery: Find drivers whose rating is higher than the average rating of drivers on their specific platform
SELECT 
    U.FullName as DriverName, 
    D.Rating,
    P.Name as Platform
FROM Drivers D
JOIN Users U ON D.UserID = U.UserID
JOIN Ride_Platforms P ON D.PlatformID = P.PlatformID
WHERE D.Rating > (
    SELECT AVG(D2.Rating) 
    FROM Drivers D2 
    WHERE D2.PlatformID = D.PlatformID
);

-- 2. Non-Correlated Subquery: Find users who have never made a ride request
SELECT FullName, Email 
FROM Users 
WHERE UserID NOT IN (SELECT DISTINCT UserID FROM Ride_Requests);

-- D. AGGREGATE FUNCTIONS (COUNT, SUM, AVG, MIN, MAX)
-- Comprehensive group statistics
SELECT 
    COUNT(GroupID) as TotalGroups,
    SUM(TotalFare) as TotalRevenue,
    AVG(TotalFare) as AverageFare,
    MAX(TotalFare) as HighestFare,
    MIN(TotalFare) as LowestFare
FROM Ride_Groups
WHERE Status = 'Completed';
