SELECT CONCAT('SELECT * FROM ', TABLE_NAME) FROM INFORMATION_SCHEMA.TABLES
SELECT * FROM [User]
SELECT * FROM VehicleMakes
SELECT * FROM Vehicles
SELECT * FROM Location
SELECT * FROM Request
SELECT * FROM PaymentMethod
SELECT * FROM PaymentStatus
SELECT * FROM Payment
SELECT * FROM Trip
SELECT * FROM uber_data_final;


SELECT CONCAT('DROP TABLE ', TABLE_NAME) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE LIKE 'base_table';
DROP TABLE [User]
DROP TABLE VehicleMakes
DROP TABLE Vehicles
DROP TABLE Location
DROP TABLE PaymentMethod
DROP TABLE PaymentStatus
DROP TABLE Payment
DROP TABLE Trip
DROP TABLE Request