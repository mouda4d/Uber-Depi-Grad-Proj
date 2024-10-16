# Project Overview

## Introduction
This project demonstrates an end-to-end data pipeline using Azure services for Extract, Load, and Transform (ELT) processes. The project processes taxi ride data and synthetic data using Docker, Microsoft SQL Server, and Azure services such as Data Factory, Data Lake Storage Gen2, Databricks, Synapse Analytics, and Azure ML.

## Architecture Overview
The project follows a typical ELT process:
- **Extract**: Taxi ride data is sourced from the New York City Taxi dataset and synthetic data generated using the `Faker` library. These data sources are stored in a Microsoft SQL Server hosted in a Docker container.
- **Load**: Data is loaded into Azure Data Lake Storage Gen2 via Azure Data Factory.
- **Transform**: The loaded data is transformed in Databricks following the Bronze-Silver-Gold architecture.
- **Analysis**: Data is analyzed using Azure Synapse Analytics, and visual dashboards are created in Power BI.
- **Machine Learning**: The refined data is used for machine learning models in Azure ML.

## Objectives
- Automate the ETL pipeline using Azure services.
- Process real and synthetic taxi ride data for analysis.
- Develop machine learning models based on the processed data.

## Table of Contents
- [Technologies](#technologies)
- [Pipeline Steps](#pipeline-steps)
  - [0. Database Design](#0-database-design)
  - [1. Data Extraction](#1-data-extraction)
  - [2. Data Loading into Azure](#2-data-loading-into-azure)
  - [3. Data Transformation in Databricks](#3-data-transformation-in-databricks)
  - [4. Data Analysis in Synapse Analytics](#4-data-analysis-in-synapse-analytics)
  - [5. Visualization and Reporting in Power BI](#5-visualization-and-reporting-in-power-bi)
  - [6. Machine Learning with Azure ML](#6-machine-learning-with-azure-ml)


This project processes real-world NYC Taxi data and synthetic data generated using the `Faker` library. The data pipeline extracts, transforms, and loads data to Azure cloud services, providing advanced analytics and visualizations.

## Technologies

- **Docker**: For hosting SQL Server and managing data sources.
- **Microsoft SQL Server**: Database for storing raw taxi and synthetic data.
- **Faker**: Library for generating synthetic data.
- **Azure Data Lake Storage Gen2**: Scalable storage for large datasets.
- **Azure Data Factory**: For orchestrating data movement between the SQL Server and Azure Data Lake.
- **Azure Databricks**: Platform for data processing and transformation using the Delta Lake architecture.
- **Azure Synapse Analytics**: For advanced data analysis and querying.
- **Power BI**: For building data visualization dashboards.
- **Azure Machine Learning**: For building and training machine learning models.

# Pipeline Steps
## 0. Database Design
### I. Requirements Gathering
Objective: Understand the business needs and requirements for the database.  
**Stakeholders Involved:** 
- Business analysts
- Project managers
- End-users

The purpose of gathering requirements was to ensure that the database can effectively manage the necessary features and data.

### II. Conceptual Design
#### Entity-Relationship (ER) Model
An ER diagram was created to visualize the entities involved and their relationships. Key entities identified include:
- User
- Vehicle
- Trip
- Payment
- Request

#### ER Diagram
![ER DIAGRAM](DESIGNS/ER%20DIAGRAM.png)

This image illustrates the entities and their relationships as identified in the conceptual design phase.

### III. Logical Design
#### Mapping to Tables
The ER diagram was converted into a relational model, specifying attributes for each entity.

#### Normalization
Normalization rules were applied to eliminate redundancy and ensure data integrity.

#### Logical Mapping
![Logical Mapping](DESIGNS/ERD%20MAPPING.png)

This image depicts how entities are mapped to tables, showing primary keys, foreign keys, and attributes.

### IV. Physical Design
#### Table Creation
Defined SQL scripts for creating tables with appropriate data types, constraints, and indexes.

## V. Flat Table

### Flat Table Creation
#### this table is used as the integration between the NYC dataset and the fake data

```sql
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
FROM "YOURPATH\uber_data.csv"
WITH
(
    FIELDTERMINATOR = ',',  -- CSV delimiter
    ROWTERMINATOR = '\n',   -- Row delimiter
    FIRSTROW = 2            -- Skip the header row
);
```

### Table Structure
#### The uber_data_final table includes the following fields:

#### Passenger Information: [passenger_name, passenger_email, passenger_phone]
#### Driver Information: [driver_name, driver_email, driver_phone]
#### Vehicle Information: [vehicle_model, vehicle_make, vehicle_year, vehicle_color, plate_num]
#### Payment Information: [payment_type, payment_status]
#### Trip Details: [tpep_pickup_datetime, tpep_dropoff_datetime, trip_distance, pickup_longitude, pickup_latitude, dropoff_longitude, dropoff_latitude, fare_amount, extra, mta_tax, tip_amount, tolls_amount, improvement_surcharge, total_amount]
#### Timestamps: [requested_timestamp, accepted_timestamp, driver_mean_rating]

### Data Insertion
#### Sample data insertion queries to populate the original Database tables:

```sql 
INSERT INTO [User] (UserID, FullName, Email, PhoneNumber, DriverMeanRating)
SELECT DISTINCT passenger_id, passenger_name, passenger_email, passenger_phone, NULL
FROM uber_data_final;

INSERT INTO VehicleMakes (MakeID, MakeName)
SELECT DISTINCT vehiclemake_ID, vehicle_make FROM uber_data_final;

-- More insertion queries...
```
### Indexes
#### indexes are created on frequently queried columns for optimization:

```sql
CREATE INDEX idx_user_email ON [User](Email);
CREATE INDEX idx_vehicles_driverid ON Vehicles(DriverID);
CREATE INDEX idx_trip_requestid ON Trip(RequestID);
CREATE INDEX idx_payment_paymentmethodid ON Payment(PaymentMethodID);

```
### ID Generation
#### Unique IDs are generated using DENSE RANK to avoid duplicates:
```sql
WITH allCTE AS (
    SELECT 
        trip_id,
        DENSE_RANK() OVER (ORDER BY passenger_name, passenger_email, passenger_phone) AS passenger_id,
        -- Continue for other fields...
    FROM uber_data_final
)
```
##### Example Table Creation
```sql
CREATE TABLE User (
    UserID INT PRIMARY KEY,
    FullName NVARCHAR(255) NOT NULL,
    Email NVARCHAR(255) NOT NULL,
    PhoneNumber NVARCHAR(20) NOT NULL,
    DriverMeanRating FLOAT
);

```
### 1. Data Extraction

**Sources**:
- NYC Taxi dataset.
- Synthetic customer, driver, and payment data generated using `Faker`.

**Storage**:
- Data stored in **SQL Server** running on Docker.

### 2. Data Loading into Azure

Data is loaded from SQL Server to **Azure Data Lake Storage Gen2** using **Azure Data Factory**. The raw data is stored in the **Bronze (Raw)** layer of the Data Lake.

### 3. Data Transformation in Databricks

Data is processed using **Azure Databricks** following the **Bronze-Silver-Gold** architecture:
- **Bronze**: Raw data ingested.
- **Silver**: Data cleansing and basic transformations.
- **Gold**: Aggregated data for analytics and machine learning.

**Key Transformations**:
- Timestamp normalization.
- Deduplication.
- Metrics generation (e.g., trip counts, fare analysis).

### 4. Data Analysis in Synapse Analytics

The **Gold-tier** data is loaded into **Azure Synapse Analytics** for analysis:
- **SQL queries** for advanced data analytics (e.g., trip duration, fare distribution).

### 5. Visualization and Reporting in Power BI

Data is visualized in **Power BI**, providing insights such as:
- **Trip trends**.
- **Fare distribution**.
- **Customer segmentation**.

### 6. Machine Learning with Azure ML

Machine learning models are built using **Azure Machine Learning** to predict taxi demand based on historical data (time, location, fare).








