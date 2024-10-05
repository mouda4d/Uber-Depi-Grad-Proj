/*
-- Indexes for User table
CREATE UNIQUE INDEX idx_user_fullname_email_phonenumber 
ON [User] (FullName, Email, PhoneNumber);

-- Indexes for VehicleMakes table
CREATE UNIQUE INDEX idx_vehiclemakes_make 
ON VehicleMakes (MakeName);

-- Indexes for Vehicles table
CREATE UNIQUE INDEX idx_vehicles_licenseplate 
ON Vehicles (LicensePlate);

-- Indexes for Location table
CREATE UNIQUE INDEX idx_location_coordinates 
ON Location (Longitude, Latitude);

-- Indexes for PaymentMethod table
CREATE UNIQUE INDEX idx_paymentmethod_method 
ON PaymentMethod (MethodName);

-- Indexes for PaymentStatus table
CREATE UNIQUE INDEX idx_paymentstatus_status 
ON PaymentStatus (StatusName);

-- Indexes for Payment table
CREATE UNIQUE INDEX idx_payment_method_status 
ON Payment (PaymentMethodID, PaymentStatusID);

-- Indexes for Request table
CREATE UNIQUE INDEX idx_request_passenger_pickup_dropoff 
ON Request (PassengerID, PickupLocationID, DropoffLocationID);

-- Indexes for Trip table
CREATE UNIQUE INDEX idx_trip_request_driver 
ON Trip (RequestID, DriverID);
*/