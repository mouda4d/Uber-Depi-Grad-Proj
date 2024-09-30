CREATE TABLE RideInfo (
    user_id INT,
    user_name VARCHAR(255),
    user_email VARCHAR(255),
    user_phone VARCHAR(50),
    user_rating FLOAT,
    
    vehicle_id INT,
    vehicle_model VARCHAR(255),
    vehicle_make VARCHAR(255),
    vehicle_year INT,
    vehicle_color VARCHAR(50),
    plate_num VARCHAR(20),
    
    payment_id INT,
    payment_type VARCHAR(50),
    payment_status VARCHAR(255),
    
    request_id INT,
    pickup_longitude FLOAT,
    pickup_latitude FLOAT,
    dropoff_longitude FLOAT,
    dropoff_latitude FLOAT,
    request_status VARCHAR(50),
    request_timestamp DATETIME,
    
    trip_id INT,
    trip_distance DECIMAL(10, 2),
    pickup_time DATETIME,
    dropoff_time DATETIME,
    --duration DECIMAL(10, 2),
    rating INT,
    fare DECIMAL(10, 2),
    extra DECIMAL(10, 2),
    mta_tax DECIMAL(10, 2),
    tip_amount DECIMAL(10, 2),
    tolls_amount DECIMAL(10, 2),
    improvement_surcharge DECIMAL(10, 2),
    --total_amount DECIMAL(10, 2)
    
);
