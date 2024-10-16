IF NOT EXISTS (
    SELECT * FROM sys.tables WHERE name = 'uber_data_final'
)
BEGIN
    CREATE TABLE uber_data_final (
        passenger_name NVARCHAR(255),
        passenger_email NVARCHAR(255),
        passenger_phone NVARCHAR(20),
        driver_name NVARCHAR(255),
        driver_email NVARCHAR(255),
        driver_phone NVARCHAR(20),
        vehicle_model NVARCHAR(255),
        vehicle_make NVARCHAR(255),
        vehicle_year INT,
        vehicle_color NVARCHAR(50),
        plate_num NVARCHAR(50),
        payment_type NVARCHAR(50),
        payment_status NVARCHAR(50),
        tpep_pickup_datetime DATETIME,
        tpep_dropoff_datetime DATETIME,
        trip_distance FLOAT,
        pickup_longitude FLOAT,
        pickup_latitude FLOAT,
        RateCodeID INT,
        dropoff_longitude FLOAT,
        dropoff_latitude FLOAT,
        fare_amount FLOAT,
        extra FLOAT,
        mta_tax FLOAT,
        tip_amount FLOAT,
        tolls_amount FLOAT,
        improvement_surcharge FLOAT,
        total_amount FLOAT,
        requested_timestamp DATETIME,
        accepted_timestamp DATETIME,
        driver_mean_rating FLOAT
    );
END;

BULK INSERT uber_data_final
FROM "E:\DEPIfINALpROJECT\uber_data.csv"
WITH
(
    FIELDTERMINATOR = ',',  -- CSV delimiter
    ROWTERMINATOR = '\n',   -- Row delimiter
    FIRSTROW = 2            -- Skip the header row
);
