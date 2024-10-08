
with allCTE AS (
    SELECT 
        trip_id,
        DENSE_RANK() OVER (ORDER BY passenger_name, passenger_email, passenger_phone) AS passenger_id,
        DENSE_RANK() OVER (ORDER BY driver_name, driver_email, driver_phone) AS driver_id,
        DENSE_RANK() OVER (ORDER BY vehicle_make) AS vehicleMake_id,
        DENSE_RANK() OVER (ORDER BY vehicle_make, vehicle_model, vehicle_color, vehicle_year, plate_num) AS vehicle_id,
        DENSE_RANK() OVER (ORDER BY payment_type) AS paymentMethod_id,
        DENSE_RANK() OVER (ORDER BY payment_status) AS paymentStatus_id,
        DENSE_RANK() OVER (ORDER BY payment_type, payment_type) AS payment_id,
        DENSE_RANK() OVER (ORDER BY pickup_longitude, dropoff_longitude ) AS longitude_id,
        DENSE_RANK() OVER (ORDER BY pickup_latitude, dropoff_latitude) AS latitude_id,
        DENSE_RANK() OVER (ORDER BY pickup_longitude, pickup_latitude ) AS pickup_id,
        DENSE_RANK() OVER (ORDER BY dropoff_longitude, dropoff_latitude) AS dropoff_id,
        DENSE_RANK() OVER (ORDER BY passenger_name, passenger_email, passenger_phone, 
                                    tpep_pickup_datetime, tpep_dropoff_datetime, requested_timestamp, accepted_timestamp ) AS request_id
    FROM
        uber_data_final
)

UPDATE uber_data_final
SET 
    uber_data_final.passenger_id = allCTE.passenger_id,
    uber_data_final.driver_id = allCTE.driver_id + allCTE.passenger_id + 700000,
    uber_data_final.vehiclemake_id = allCTE.vehiclemake_id,
    uber_data_final.vehicle_id = allCTE.vehicle_id,
    uber_data_final.paymentmethod_id = allCTE.paymentmethod_id,
    uber_data_final.paymentstatus_id = allCTE.paymentstatus_id,
    uber_data_final.payment_id = allCTE.payment_id,
    uber_data_final.longitude_ID = allCTE.longitude_id,
    uber_data_final.latitude_ID = allCTE.latitude_id + allCTE.longitude_id + 700000,
    uber_data_final.pickup_id = allCTE.pickup_id,
    uber_data_final.dropoff_id = allCTE.dropoff_id,
    uber_data_final.request_id = allCTE.request_id
FROM allCTE
WHERE uber_data_final.trip_id = allCTE.trip_id;

