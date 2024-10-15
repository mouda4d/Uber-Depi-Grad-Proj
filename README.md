# Uber Data Pipeline & Analytics Project

## Table of Contents
1. [Project Objective](#project-objective)
2. [Architecture](#architecture)
3. [Tech Stack](#tech-stack)
4. [Data Ingestion Process (ELT)](#data-ingestion-process-elt)
5. [Medallion Architecture](#medallion-architecture)
6. [Star Schema Design](#star-schema-design)
7. [Azure Synapse Analytics](#azure-synapse-analytics)
8. [Power BI Visualization](#power-bi-visualization)
9. [Security with Azure Key Vault](#security-with-azure-key-vault)
10. [Challenges Encountered](#challenges-encountered)
11. [Planned Enhancements](#planned-enhancements)
12. [Conclusion (Insights Gained)](#conclusion-insights-gained)

---

## Project Objective

This project aims to build a data pipeline and warehouse for an Uber-like ride-hailing service that stores and processes ride, user, vehicle, and fare data. It also performs data analysis on rides, users, vehicle performance, and most importantly, fare costs and sales over time. We aim to analyze the NYC Taxi dataset from Kaggle, focusing on fare data, trip patterns, and sales performance across various dimensions.

The goal is to build a robust pipeline using Azure services to ingest and transform data, ensure its consistency, and prepare it for analytics and reporting via Power BI.

## Architecture

The architecture of this project follows the ELT (Extract, Load, Transform) model using Azure Data Factory (ADF), Databricks, and Synapse. The pipeline starts with data ingestion from an Uber-like database hosted in a Docker container, then transforms the data at multiple stages using a Medallion architecture (Bronze, Silver, and Gold layers). Finally, the data is loaded into a star schema for business intelligence and analytics in Power BI.

![Architecture Placeholder](./images/architecture-diagram.png)

## Tech Stack

- **Data Ingestion & Orchestration**: Azure Data Factory (ADF)
- **Data Processing**: Azure Databricks (Apache Spark)
- **Data Storage**: Azure Data Lake Gen2 (Delta/Parquet), Azure Synapse Analytics
- **Data Visualization**: Power BI
- **Security**: Azure Key Vault
- **Version Control**: Git
- **Deployment**: Docker for local database emulation

## Data Ingestion Process (ELT)

### Data Source
The primary data source for this project is the **NYC Taxi Dataset** from Kaggle, which contains detailed information about taxi trips, fare costs, and other ride-related attributes.

### Ingestion via ADF
Data is ingested using Azure Data Factory from the Docker-hosted Uber database. ADF pipelines perform the following tasks:
- **Lookup Activity**: Retrieves table and schema names.
- **ForEach Activity**: Iterates through tables to ingest data.
- **Copy Activity**: Loads data into Azure Data Lake Storage Gen2 as Parquet files.

![ADF Pipeline Placeholder](./images/adf-pipeline.png)

## Medallion Architecture

The data is processed using the **Medallion architecture**, which consists of the following layers:

### 1. Landing to Bronze
- **Objective**: Ingest raw data from the data source and store it as Delta Lake format in the Bronze layer.
- **Transformations**: 
  - Adds metadata columns such as `processing_date`, `modification_date`, and `input_file`.
  - Keeps raw, uncleaned data for historical reference.
  
### 2. Bronze to Silver
- **Objective**: Perform data cleaning and validation on Bronze data.
- **Transformations**: 
  - Cleans and standardizes column names.
  - Adds and absorbs updates based on the current date.
  - Implements Slowly Changing Dimensions (SCD) Type 1 for tracking changes.
  
### 3. Silver to Gold
- **Objective**: Model the data in a star schema for reporting and analytics.
- **Transformations**: 
  - Aggregates data where necessary.
  - Creates atomic facts and dimensions in the Gold layer.

## Star Schema Design

The Gold layer contains a **star schema** that includes the following tables:

### Dimensions:
1. **dim_user**: Information about users, including drivers and passengers.
2. **dim_payment**: Details about payment methods (e.g., credit cards, cash).
3. **dim_location**: Contains geographic data (pickup and dropoff locations).
4. **dim_calendar**: Contains time and date information for easier analysis by time periods.

### Fact Table:
- **fct_request**: Holds detailed data about ride requests, trip details, and associated costs. This fact table stores metrics like `BaseFare`, `TipAmount`, `TotalCost`, and `distance_traveled`.

![Star Schema Placeholder](./images/star-schema.png)

## Azure Synapse Analytics

After the data is loaded into the Gold layer, we use **Azure Synapse Analytics** for SQL-based querying and view creation. Synapse allows for serverless SQL querying on the final star schema, enabling seamless integration with Power BI for reporting.

- Views are created on top of the Gold tables for easier access.
- These views allow Power BI to connect and visualize ride metrics, fare trends, and other business KPIs in real-time.

## Power BI Visualization

Power BI is used to create rich, interactive reports based on the data from the star schema. Key metrics and visuals include:

- **Fare Cost Over Time**: Tracks sales and fare trends daily, weekly, and monthly.
- **User Metrics**: Tracks active users, drivers, and user ratings.
- **Trip Analysis**: Visualizes trip distances, popular locations, and trip counts.
- **Promotions and Discounts**: Highlights the impact of promotions on sales and ride frequency.

![Power BI Dashboard Placeholder](./images/powerbi-dashboard.png)

## Security with Azure Key Vault

To ensure the security of sensitive credentials, **Azure Key Vault** is used to store:

- Databricks tokens.
- Database connection passwords (for Docker and Synapse).

These secrets are referenced in Databricks notebooks and ADF pipelines for secure access, following best practices for security and compliance.

## Challenges Encountered

1. **Local Development Issues**: Initially, developing locally with Apache Spark presented many dependency issues, particularly when configuring **Delta Lake** and **Hive** for external tables. Moving to **Azure Databricks** simplified the environment setup.
   
2. **Dynamic ELT Pipeline**: Implementing a dynamic pipeline with ADF required complex **Lookup** and **ForEach** activities to handle multiple tables and schemas efficiently.

3. **Slowly Changing Dimensions**: Handling SCD Type 1 transformations in the Silver layer required careful design to ensure that updates were absorbed based on the most recent records.

## Planned Enhancements

1. **Carpooling Feature**: Introduce a new **CarpoolGroup** entity in the schema to allow multiple users to share a ride, along with attributes for pickup and dropoff locations.

2. **Achievements System**: Add an **Achievement** entity for users and drivers to track milestones, such as completing 100 rides or achieving a 5-star rating.

3. **Dynamic Pricing**: Implement a `surge_multiplier` column in the **Trip** table to capture fare changes during high-demand periods.

4. **Penalties and Promotions**: Add attributes for **cancellation penalties** and **promotion tracking** to understand their impact on overall sales and user satisfaction.

## Conclusion (Insights Gained)

**TBD**: This section will include a detailed discussion of the insights gained from analyzing the Uber ride data, including trends in fare costs, trip patterns, user behavior, and vehicle performance. The conclusion will also highlight how the insights can be used to optimize ride pricing, promotions, and improve overall service quality.

---

This README serves as a detailed guide for anyone reviewing or working on the Uber Data Pipeline & Analysis project. It outlines each step of the data engineering process, from ingestion to visualization, providing a comprehensive view of the architecture and insights that can be extracted from the data.
