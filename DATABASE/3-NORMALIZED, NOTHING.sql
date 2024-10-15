-- Create User table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'User' AND xtype = 'U')
CREATE TABLE [User] (
    UserID INT,
    FullName NVARCHAR(255),
    Email NVARCHAR(255),
    PhoneNumber NVARCHAR(20),
    DriverMeanRating FLOAT -- user has never driven before if null
);

-- Create VehicleMakes table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'VehicleMakes' AND xtype = 'U')
CREATE TABLE VehicleMakes (
    MakeID INT,
    MakeName VARCHAR(255)
);

-- Create Vehicles table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'Vehicles' AND xtype = 'U')
CREATE TABLE Vehicles (
    VehicleID INT,
    DriverID INT,
    MakeID INT,
    Model VARCHAR(255),
    Year INT,
    Color VARCHAR(50),
    LicensePlate VARCHAR(50)
);

-- Create Location table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'Location' AND xtype = 'U')
CREATE TABLE Location (
    LocationID INT,              -- Unique identifier for each location
    Longitude DECIMAL(12, 8),    -- Longitude coordinate
    Latitude DECIMAL(12, 8)      -- Latitude coordinate
);

-- Create Request table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'Request' AND xtype = 'U')
CREATE TABLE Request (
    RequestID INT,
    PassengerID INT,
    PickupLocationID INT,
    DropoffLocationID INT,
    RequestTime DATETIME,
    AcceptTime DATETIME
);

-- Create PaymentMethod table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'PaymentMethod' AND xtype = 'U')
CREATE TABLE PaymentMethod (
    PaymentMethodID INT,
    MethodName NVARCHAR(50)
);

-- Create PaymentStatus table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'PaymentStatus' AND xtype = 'U')
CREATE TABLE PaymentStatus (
    PaymentStatusID INT,
    StatusName NVARCHAR(50)
);

-- Create Payment table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'Payment' AND xtype = 'U')
CREATE TABLE Payment (
    PaymentID INT,
    PaymentMethodID INT,
    PaymentStatusID INT
);

-- Create Trip table
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name = 'Trip' AND xtype = 'U')
CREATE TABLE Trip (
    TripID INT,
    RequestID INT,
    DriverID INT,
    VehicleID INT,
    PaymentID INT,
    TripStartTime DATETIME,
    TripEndTime DATETIME,
    TripDistance DECIMAL(10, 2),
    driver_rating FLOAT,
    BaseFare DECIMAL(10, 2),
    ExtraFare DECIMAL(10, 2),
    MtaTax DECIMAL(10, 2),
    TipAmount DECIMAL(10, 2),
    TollsAmount DECIMAL(10, 2),
    ImprovementSurcharge DECIMAL(10, 2)
);
