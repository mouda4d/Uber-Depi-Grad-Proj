# Project Overview

## Introduction
This project demonstrates an end-to-end data pipeline using Azure services for Extract, Load, and Transform (ELT) processes. The project processes taxi ride data and synthetic data using Docker, Microsoft SQL Server, and Azure services such as Data Factory, Data Lake Storage Gen2, Databricks, Synapse Analytics, and Azure ML.

## Architecture Overview
The project follows a typical ELT process:
- **Extract**: Taxi ride data is sourced from New York City Taxi dataset and synthetic data generated using the `Faker` library. These data sources are stored in a Microsoft SQL Server hosted in a Docker container.
- **Load**: Data is loaded into Azure Data Lake Storage Gen2 via Azure Data Factory.
- **Transform**: The loaded data is transformed in Databricks following the Bronze-Silver-Gold architecture.
- **Analysis**: Data is analyzed using Azure Synapse Analytics, and visual dashboards are created in Power BI.
- **Machine Learning**: The refined data is used for machine learning models in Azure ML.

## Objectives
- Automate the ETL pipeline using Azure services.
- Process real and synthetic taxi ride data for analysis.
- Develop machine learning models based on the processed data.

## Tools and Technologies
- **Docker**: For hosting SQL Server and managing data sources.
- **Microsoft SQL Server**: Database for storing raw taxi and synthetic data.
- **Faker**: Library for generating synthetic data.
- **Azure Data Lake Storage Gen2**: Scalable storage for large datasets.
- **Azure Data Factory**: For orchestrating data movement between the SQL Server and Azure Data Lake.
- **Azure Databricks**: Platform for data processing and transformation using the Delta Lake architecture.
- **Azure Synapse Analytics**: For advanced data analysis and querying.
- **Power BI**: For building data visualization dashboards.
- **Azure Machine Learning**: For building and training machine learning models.
