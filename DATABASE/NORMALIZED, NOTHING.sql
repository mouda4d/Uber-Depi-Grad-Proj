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
    MakeID INT,
    Model VARCHAR(255),
    Year INT,
    Color VARCHAR(50),
    LicensePlate VARCHAR(50)
);

CREATE TABLE Location (
    LocationID INT,
    Longitude DECIMAL(12, 8),
    Latitude DECIMAL(12, 8)
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
