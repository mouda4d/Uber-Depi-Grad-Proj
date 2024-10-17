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

## Docker & Airflow Pipeline
1. **SQL Server Container**:
   - Hosts the SQL Server database (UBER) where the CSV data is ingested and stored.
   - Runs SQL scripts to create tables, bulk-insert CSV data, and perform transformations.

2. **Jupyter Notebook Container**:
   - Provides a development environment for data exploration, transformation, and analysis.
   - Integrated with Apache Spark to perform transformations on the flat tables.

3. **Shell Script Export Container**:
   - Exports the transformed data from SQL Server into CSV format.
   - Automates exporting tables such as User, Vehicles, Trips, etc.

4. **PowerShell Export Container**:
   - Similar to the Shell container, but tailored for environments that require PowerShell for table exports.

5. **Apache Airflow**:
   - Orchestrates the entire ETL process, controlling the execution flow between the SQL Server, Jupyter, and export steps.

## Key Components
1. **SQL Server Setup**:
   - **Image**: `mcr.microsoft.com/mssql/server:2019-latest`.
   - SQL scripts are mounted into the container and executed in a specific order to:
     1. Create necessary database objects (tables, relationships).
     2. Perform bulk inserts of merged CSV data into a flat table.
     3. Conduct data transformations.

2. **Jupyter Notebook**:
   - **Image**: `jupyter/minimal-notebook:latest`.
   - Used to develop Python scripts for data manipulation and transformations.
   - Provides a user-friendly interface for inspecting data and performing advanced computations using Apache Spark.

3. **Shell and PowerShell Export Containers**:
   - Shell and PowerShell scripts are used to automate the export of data from SQL Server back to CSV files.
   - These scripts ensure that the tables are exported into a defined `/export` directory mounted on the host machine.

4. **Apache Airflow**:
   - **Image**: `apache/airflow:2.5.0`.
   - DAG (Directed Acyclic Graph) orchestrates the following tasks:
     1. SQL Execution: Runs the `0-flatetable.sql` file in SQL Server.
     2. Jupyter Execution: Triggers the Jupyter Notebook container to process and transform the data.
     3. Export Execution: Runs the Shell/PowerShell export containers to extract the final CSVs.

## Folder Structure
The folder structure of the project is organized as follows:
```
project-root/
│
├── SQL-image/
│   ├── Dockerfile.sql               # Dockerfile for SQL Server container
│   ├── sql/
│   │   ├── 0-flatetable.sql         # SQL script to create the flat table
│   │   ├── 1-transformations.sql    # SQL script for data transformations
│   │   └── additional-scripts.sql   # Any additional SQL scripts
│   ├── data/
│   │   └── uber_data.csv            # Merged CSV data
│
├── Notebook-image/
│   ├── Dockerfile.jupyter            # Dockerfile for Jupyter container
│   └── notebooks/
│       └── uber_analysis.ipynb       # Jupyter notebook for data processing
│
├── Shell-image/
│   ├── Dockerfile.linux              # Dockerfile for Shell export container
│   ├── export_tables.sh              # Shell script for exporting tables to CSV
│
├── Powershell-image/
│   ├── Dockerfile.powershell         # Dockerfile for PowerShell export container
│   ├── export_tables_powershell.ps1  # PowerShell script for exporting tables to CSV
│
├── airflow/
│   └── dags/
│       └── uber_etl_dag.py           # Airflow DAG file orchestrating the pipeline
│
└── docker-compose.yml                # Docker Compose file for all services
```

## Key Features & Workflow
1. **CSV Data Processing**:
   - The project uses data sourced from Kaggle and generated with Python scripts. The CSV files are merged into a single flat table (`uber_data.csv`).

2. **SQL Server Processing**:
   - SQL Server runs SQL scripts in order:
     1. `0-flatetable.sql`: Creates the flat table and bulk inserts data from the CSV.
     2. `1-transformations.sql`: Performs transformations on the data (e.g., date formatting, column adjustments).
     3. Additional scripts: Optional further processing.

3. **Data Transformation**:
   - Jupyter notebooks and Apache Spark are used to manipulate the flat table data before exporting it back into SQL Server.

4. **Data Export**:
   - The export scripts (Shell or PowerShell) retrieve the transformed data from SQL Server and export it as CSV files into the `/export` directory.

5. **Airflow Orchestration**:
   - Apache Airflow controls the sequence of steps to ensure data processing happens in the correct order:
     1. First, SQL scripts are executed.
     2. Then, Jupyter notebooks process and analyze the data.
     3. Finally, the export scripts run to save results as CSV files.

## Technologies Used
- **Docker**: Containerization of all services, including SQL Server, Jupyter, Shell/PowerShell export containers, and Airflow.
- **SQL Server**: Relational database management system for storing Uber data.
- **Jupyter**: Interactive environment for data analysis and transformation.
- **Apache Spark**: Distributed data processing engine used in conjunction with Jupyter for large-scale transformations.
- **Apache Airflow**: Workflow management system for orchestrating the pipeline.
- **Bash/PowerShell Scripts**: Automates exporting data from SQL Server into CSV format.




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
## Overview
This project focuses on predicting the price of a trip based on the trip distance using a machine learning model. The primary goal is to gather, examine, and preprocess the data to build a reliable linear regression model. After building the model, the evaluation process is carried out, and the model is saved for deployment.

## Business Understanding
The key business question is: **How can we predict the price of a trip based on the trip distance?**

We started by gathering the data and examining it to understand the relationship between the trip distance and trip price. Missing data was handled, and outliers were addressed to ensure model accuracy.

## Data Collection & Examination
The data was gathered from the **Silver to Gold** notebook on **Databricks** as part of a larger ETL (Extract, Transform, Load) pipeline. The target variable selected for prediction is **trip price**, and the feature used is **trip distance**. The following steps were taken during this phase:

1. **Data cleaning**: Handle missing values using imputation (mean imputation was chosen).
2. **Feature engineering**: Analyze the correlation between features using statistical plots and feature selection techniques.

### Heatmap of Correlation (Placeholder for Image)
In the feature engineering section, a heatmap was created to analyze the correlation between features.

[Insert Heatmap Here]

## Tools Used
- **Jupyter Notebook**: For local development and experimentation.
- **Databricks**: For handling the ETL process and managing data pipelines.
- **Python**: For scripting and building the machine learning model.

### Python Libraries
The following Python libraries were used in this project:

```python
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy import stats
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import StandardScaler, OneHotEncoder
from sklearn.linear_model import LinearRegression
from sklearn.pipeline import Pipeline
from sklearn.metrics import mean_squared_error, r2_score
```

## Data Preprocessing
1. **Handling Missing Values**: Missing data was imputed using the mean.
2. **Categorical Data**: One-hot encoding was applied to any categorical features that might influence the predictions.
3. **Outliers**: Outliers in the trip distance and price were handled using statistical techniques.

## Model Building
The **Linear Regression** model was chosen to predict the price based on the trip distance. A pipeline was created to streamline the process:

1. Data was split into training and testing sets.
2. Feature scaling was performed using **StandardScaler**.
3. Linear regression was applied, and the model was fitted to the training data.

## Model Evaluation
The model was evaluated using **Root Mean Squared Error (RMSE)** and **R-squared (R²)** metrics to assess its accuracy:

- **RMSE**: The error metric to measure the average error of the model predictions.

## Model Deployment
The model was saved as `model.pkl` to be deployed in production for further use.

## Challenges Faced
During the project, the following challenges were encountered:

1. **Installing dependencies**: There were issues with installing `pandas` and `scikit-learn` due to dependency conflicts.
2. **Data corruption**: Some data was corrupted during the gathering process, which caused delays in preprocessing.
3. **External factors**: Time constraints and external factors impacted the pace of development.

## Conclusion
This project highlights the end-to-end process of gathering, cleaning, and building a machine learning model to predict trip prices based on trip distance. The saved model is now ready for deployment on **Databricks**.

## Recommendation
- **Feature Expansion**: Consider using additional features such as time of day, weather, and vehicle type to improve model accuracy.
- **Model Tuning**: Hyperparameter tuning can be applied to further enhance the model performance.
