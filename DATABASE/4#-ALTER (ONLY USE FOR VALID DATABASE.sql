
-- Set UserID NOT NULL and add Primary Key
ALTER TABLE [User]
ALTER COLUMN UserID INT NOT NULL;

ALTER TABLE [User]
ADD CONSTRAINT PK_User PRIMARY KEY (UserID);
GO

-- Set VehicleID NOT NULL and add Primary Key
ALTER TABLE Vehicles
ALTER COLUMN VehicleID INT NOT NULL;

ALTER TABLE Vehicles
ADD CONSTRAINT PK_Vehicles PRIMARY KEY (VehicleID);
GO

-- Set vehicleMakeID NOT NULL and add Primary Key
ALTER TABLE VehicleMakes
ALTER COLUMN MakeID INT NOT NULL;

ALTER TABLE VehicleMakes
ADD CONSTRAINT PK_VehicleMakes PRIMARY KEY (MakeID);
GO

-- Set LocationID NOT NULL and add Primary Key
ALTER TABLE Location
ALTER COLUMN LocationID INT NOT NULL;

ALTER TABLE Location
ADD CONSTRAINT PK_Location PRIMARY KEY (LocationID);
GO

-- Set RequestID NOT NULL and add Primary Key
ALTER TABLE Request
ALTER COLUMN RequestID INT NOT NULL;

ALTER TABLE Request
ADD CONSTRAINT PK_Request PRIMARY KEY (RequestID);
GO

-- Set PaymentMethodID NOT NULL and add Primary Key
ALTER TABLE PaymentMethod
ALTER COLUMN PaymentMethodID INT NOT NULL;

ALTER TABLE PaymentMethod
ADD CONSTRAINT PK_PaymentMethod PRIMARY KEY (PaymentMethodID);
GO

-- Set PaymentStatusID NOT NULL and add Primary Key
ALTER TABLE PaymentStatus
ALTER COLUMN PaymentStatusID INT NOT NULL;

ALTER TABLE PaymentStatus
ADD CONSTRAINT PK_PaymentStatus PRIMARY KEY (PaymentStatusID);
GO

-- Set PaymentID NOT NULL and add Primary Key
ALTER TABLE Payment
ALTER COLUMN PaymentID INT NOT NULL;

ALTER TABLE Payment
ADD CONSTRAINT PK_Payment PRIMARY KEY (PaymentID);
GO

-- Set TripID NOT NULL and add Primary Key
ALTER TABLE Trip
ALTER COLUMN TripID INT NOT NULL;

ALTER TABLE Trip
ADD CONSTRAINT PK_Trip PRIMARY KEY (TripID);
GO

-- Add foreign key constraints
ALTER TABLE Vehicles
ADD CONSTRAINT FK_Vehicles_User FOREIGN KEY (DriverID) REFERENCES [User](UserID);
GO

ALTER TABLE Trip
ADD CONSTRAINT FK_Trip_Request FOREIGN KEY (RequestID) REFERENCES Request(RequestID);
GO

ALTER TABLE Trip
ADD CONSTRAINT FK_Trip_Vehicles FOREIGN KEY (VehicleID) REFERENCES Vehicles(VehicleID);
GO

ALTER TABLE Trip
ADD CONSTRAINT FK_Trip_Payment FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID);
GO

ALTER TABLE Payment
ADD CONSTRAINT FK_Payment_PaymentMethod FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethod(PaymentMethodID);
GO

ALTER TABLE Payment
ADD CONSTRAINT FK_Payment_PaymentStatus FOREIGN KEY (PaymentStatusID) REFERENCES PaymentStatus(PaymentStatusID);
GO

-- Add check constraints
ALTER TABLE [User] ADD CONSTRAINT CK_User_Email CHECK (Email LIKE '%_@__%.__%');
GO

ALTER TABLE [User] ADD CONSTRAINT CK_User_Phone CHECK (LEN(PhoneNumber) = 10);
GO

ALTER TABLE Vehicles ADD CONSTRAINT CK_Vehicles_Year CHECK (Year >= 1886 AND Year <= YEAR(GETDATE()));
GO

ALTER TABLE Vehicles ADD CONSTRAINT CK_Vehicles_LicensePlate CHECK (LEN(LicensePlate) BETWEEN 1 AND 10);
GO

ALTER TABLE Location ADD CONSTRAINT CK_Location_Coordinates CHECK (Longitude BETWEEN -180 AND 180 AND Latitude BETWEEN -90 AND 90);
GO

ALTER TABLE Trip ADD CONSTRAINT CK_Trip_Distance CHECK (TripDistance >= 0);
GO

ALTER TABLE Trip ADD CONSTRAINT CK_Trip_Fares CHECK (BaseFare >= 0 AND ExtraFare >= 0 AND MtaTax >= 0 AND TipAmount >= 0 AND TollsAmount >= 0 AND ImprovementSurcharge >= 0);
GO

-- Create indexes for faster query performance
CREATE INDEX IX_User_Email ON [User](Email);
GO

CREATE INDEX IX_Vehicles_DriverID ON Vehicles(DriverID);
GO

CREATE INDEX IX_Trip_RequestID ON Trip(RequestID);
GO

CREATE INDEX IX_Payment_PaymentMethodID ON Payment(PaymentMethodID);
GO
