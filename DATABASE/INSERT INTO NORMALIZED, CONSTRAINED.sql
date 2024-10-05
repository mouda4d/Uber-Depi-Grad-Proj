-- Insert into User Table (for Passengers and Drivers)
INSERT INTO [User] (
    UserID, FullName, Email, PhoneNumber, DriverMeanRating)
SELECT DISTINCT
    passenger_id,
    passenger_name,
    passenger_email,
    passenger_phone,
    NULL AS DriverMeanRating-- Set to NULL since these are passengers and may not have a rating
FROM
    uber_data_final
--WHERE
--    ud.passenger_name IS NOT NULL
--    AND ud.passenger_email IS NOT NULL
--    AND ud.passenger_phone IS NOT NULL;

INSERT INTO [User] (UserID, FullName, Email, PhoneNumber, DriverMeanRating)
SELECT DISTINCT
    driver_id,
    driver_name,
    driver_email,
    driver_phone,
    NULL AS DriverMeanRating--CAST(ud.driver_mean_rating AS FLOAT) -- Set driver rating based on data
FROM
    uber_data_final
--WHERE
--    ud.driver_name IS NOT NULL
--    AND ud.driver_email IS NOT NULL
--    AND ud.driver_phone IS NOT NULL;

-- Insert into VehicleMakes Table
INSERT INTO VehicleMakes (makeID, MakeName)
SELECT DISTINCT
    vehiclemake_ID,
    vehicle_make
FROM
    uber_data_final
--WHERE
--    ud.vehicle_make IS NOT NULL;

-- Insert into Vehicles Table
INSERT INTO Vehicles (vehicleID, MakeID, Model, Year, Color, LicensePlate)
SELECT DISTINCT
    vehicle_id,
    vehiclemake_ID,
    vehicle_model,
    vehicle_year,
    vehicle_color,
    plate_num
FROM
    uber_data_final

--WHERE
--    ud.vehicle_model IS NOT NULL
--    AND ud.plate_num IS NOT NULL;

-- Insert into Location Table (for Pickup and Dropoff)
INSERT INTO Location (locationID, Longitude, Latitude)
SELECT DISTINCT
    longitude_id,
    pickup_longitude,
    pickup_latitude
FROM
    uber_data_final
--WHERE
--    ud.pickup_longitude IS NOT NULL
--    AND ud.pickup_latitude IS NOT NULL;

INSERT INTO Location (locationID, Longitude, Latitude)
SELECT DISTINCT
    latitude_id,
    dropoff_longitude,
    dropoff_latitude
FROM
    uber_data_final
--WHERE
--    ud.dropoff_longitude IS NOT NULL
--    AND ud.dropoff_latitude IS NOT NULL;

-- Insert into Request Table
INSERT INTO Request (requestID, PassengerID, PickupLocationID, DropoffLocationID, RequestTime, AcceptTime)
SELECT DISTINCT
    request_id,
    passenger_ID,
    Pickup_ID,
    Dropoff_ID,
    CONVERT(DATETIME, requested_timestamp) AS RequestTime,
    CONVERT(DATETIME, accepted_timestamp) AS AcceptTime
FROM
    uber_data_final

--WHERE
--    ud.passenger_name IS NOT NULL;

-- Insert into PaymentMethod Table
INSERT INTO PaymentMethod (paymentMethodID, MethodName)
SELECT DISTINCT
    paymentmethod_id,
    payment_type
FROM
    uber_data_final
--WHERE
--    ud.payment_type IS NOT NULL;

-- Insert into PaymentStatus Table
INSERT INTO PaymentStatus (paymentStatusID, StatusName)
SELECT DISTINCT
    paymentStatus_id,
    payment_status
FROM
    uber_data_final
--WHERE
--    ud.payment_status IS NOT NULL;

-- Insert into Payment Table
INSERT INTO Payment (paymentID, PaymentMethodID, PaymentStatusID)
SELECT
    payment_id,
    PaymentMethod_ID,
    PaymentStatus_ID
FROM
    uber_data_final

--WHERE
--    ud.payment_type IS NOT NULL
--    AND ud.payment_status IS NOT NULL;

-- Insert into Trip Table
INSERT INTO Trip (
    tripID,
    RequestID,
    DriverID,
    VehicleID,
    PaymentID,
    TripStartTime,
    TripEndTime,
    TripDistance,
    driver_rating,
    BaseFare,
    ExtraFare,
    MtaTax,
    TipAmount,
    TollsAmount,
    ImprovementSurcharge
)
SELECT
    trip_id,
    Request_ID,
    driver_id,
    Vehicle_ID,
    Payment_ID,
    CONVERT(DATETIME, tpep_pickup_datetime) AS TripStartTime,
    CONVERT(DATETIME, tpep_dropoff_datetime) AS TripEndTime,
    CAST(trip_distance AS DECIMAL(10, 2)) AS TripDistance,
    CAST(driver_mean_rating AS FLOAT) AS driver_rating,
    CAST(fare_amount AS DECIMAL(10, 2)) AS BaseFare,
    CAST(extra AS DECIMAL(10, 2)) AS ExtraFare,
    CAST(mta_tax AS DECIMAL(10, 2)) AS MtaTax,
    CAST(tip_amount AS DECIMAL(10, 2)) AS TipAmount,
    CAST(tolls_amount AS DECIMAL(10, 2)) AS TollsAmount,
    CAST(improvement_surcharge AS DECIMAL(10, 2)) AS ImprovementSurcharge
FROM
    uber_data_final

--WHERE
--    ud.passenger_name IS NOT NULL
--    AND ud.driver_name IS NOT NULL;
