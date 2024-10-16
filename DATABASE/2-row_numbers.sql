-- Using variables to store the maximum existing IDs
DECLARE @maxDriverID INT;
DECLARE @maxLatitudeID INT;

SELECT @maxDriverID = ISNULL(MAX(driver_id), 0) FROM uber_data_final;
SELECT @maxLatitudeID = ISNULL(MAX(latitude_ID), 0) FROM uber_data_final;

WITH allCTE AS (
    SELECT 
        trip_id,
        DENSE_RANK() OVER (ORDER BY passenger_name, passenger_email, passenger_phone) AS passenger_id,
        DENSE_RANK() OVER (ORDER BY driver_name, driver_email, driver_phone) + @maxDriverID AS driver_id,
        DENSE_RANK() OVER (ORDER BY vehicle_make) AS vehicleMake_id,
        DENSE_RANK() OVER (ORDER BY vehicle_make, vehicle_model, vehicle_color, vehicle_year, plate_num) AS vehicle_id,
        DENSE_RANK() OVER (ORDER BY payment_type) AS paymentMethod_id,
        DENSE_RANK() OVER (ORDER BY payment_status) AS paymentStatus_id,
        DENSE_RANK() OVER (ORDER BY payment_type, payment_type) AS payment_id,
        DENSE_RANK() OVER (ORDER BY pickup_longitude, dropoff_longitude) AS longitude_id,
        DENSE_RANK() OVER (ORDER BY pickup_latitude, dropoff_latitude) + @maxLatitudeID AS latitude_id,
        DENSE_RANK() OVER (ORDER BY pickup_longitude, pickup_latitude) AS pickup_id,
        DENSE_RANK() OVER (ORDER BY dropoff_longitude, dropoff_latitude) AS dropoff_id,
        DENSE_RANK() OVER (ORDER BY passenger_name, passenger_email, passenger_phone, 
                                    tpep_pickup_datetime, tpep_dropoff_datetime, requested_timestamp, accepted_timestamp) AS request_id
    FROM
        uber_data_final
)

UPDATE uber_data_final
SET 
    passenger_id = allCTE.passenger_id,
    driver_id = allCTE.driver_id,
    vehiclemake_id = allCTE.vehiclemake_id,
    vehicle_id = allCTE.vehicle_id,
    paymentmethod_id = allCTE.paymentmethod_id,
    paymentstatus_id = allCTE.paymentstatus_id,
    payment_id = allCTE.payment_id,
    longitude_ID = allCTE.longitude_id,
    latitude_ID = allCTE.latitude_id,
    pickup_id = allCTE.pickup_id,
    dropoff_id = allCTE.dropoff_id,
    request_id = allCTE.request_id
FROM allCTE
WHERE uber_data_final.trip_id = allCTE.trip_id;
