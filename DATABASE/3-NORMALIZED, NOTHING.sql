CREATE TABLE [User] (
    UserID INT,
    FullName NVARCHAR(255),
    Email NVARCHAR(255),
    PhoneNumber NVARCHAR(20),
    DriverMeanRating FLOAT -- user has never driven before if null
);

CREATE TABLE VehicleMakes (
    MakeID INT,
    MakeName VARCHAR(255)
);

CREATE TABLE Vehicles (
    VehicleID INT,
    DriverID INT,
    MakeID INT,
    Model VARCHAR(255),
    Year INT,
    Color VARCHAR(50),
    LicensePlate VARCHAR(50)
);

CREATE TABLE Location (
    LocationID INT,              -- Unique identifier for each location
    Longitude DECIMAL(12, 8),                -- Longitude coordinate
    Latitude DECIMAL(12, 8),                 -- Latitude coordinate
    --location_detail VARCHAR(255),          -- Detail about the location
    --country VARCHAR(100),                  -- Country name
    --city VARCHAR(100),                     -- City name
    --road VARCHAR(100),                     -- Road name
    --state VARCHAR(100),                    -- State or region
    --postcode VARCHAR(20)                   -- Postal code
);


CREATE TABLE Request (
    RequestID INT,
    PassengerID INT,
    PickupLocationID INT,
    DropoffLocationID INT,
    RequestTime DATETIME,
    AcceptTime DATETIME
);

CREATE TABLE PaymentMethod (
    PaymentMethodID INT,
    MethodName NVARCHAR(50)
);

CREATE TABLE PaymentStatus (
    PaymentStatusID INT,
    StatusName NVARCHAR(50)
);

CREATE TABLE Payment (
    PaymentID INT,
    PaymentMethodID INT,
    PaymentStatusID INT
);

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
