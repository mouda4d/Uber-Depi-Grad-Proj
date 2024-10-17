# Environment Setup for Data Processing Pipeline

This guide will walk you through setting up a data processing pipeline using Docker, SQL Server, Azure Data Lake, Azure Data Factory, Azure Databricks, Azure Synapse Analytics, Power BI, and Azure Machine Learning.

## Prerequisites

Before you begin, ensure you have the following installed and configured:

#### Docker: For running SQL Server locally in a container.
#### Azure Account: To access Azure services like Data Lake, Data Factory, Databricks, Synapse Analytics, Power BI, and Azure Machine Learning.

## Step 1: Set Up SQL Server in Docker

### Key Components
1. #### SQL Server Setup:
- Image: mcr.microsoft.com/mssql/server:2019-latest.
- SQL scripts are mounted into the container and executed in a specific order to:
  1. Create necessary database objects (tables, relationships).
  2. Perform bulk inserts of merged CSV data into a flat table.
  3. Conduct data transformations.
2. #### Jupyter Notebook:
- Image: jupyter/minimal-notebook:latest.
- Used to develop Python scripts for data manipulation and transformations.
- Provides a user-friendly interface for inspecting data and performing advanced computations using Apache Spark.
3. #### Shell and PowerShell Export Containers:
- Shell and PowerShell scripts are used to automate the export of data from SQL Server back to CSV files.
- These scripts ensure that the tables are exported into a defined /export directory mounted on the host machine.
4. #### Apache Airflow:
- Image: apache/airflow:2.5.0.
- DAG (Directed Acyclic Graph) orchestrates the following tasks:
  1. SQL Execution: Runs the 0-flatetable.sql file in SQL Server.
  2. Jupyter Execution: Triggers the Jupyter Notebook container to process and transform the data.
  3. Export Execution: Runs the Shell/PowerShell export containers to extract the final CSVs.
Folder Structure
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

## Step 2: Create Azure Data Lake and Data Factory

1. Create an Azure Data Lake Storage Gen2 account:
   - Navigate to the Azure Portal and create a Data Lake Storage Gen2 account. This will be used for storing your raw datasets.

2. Set up Azure Data Factory:
   - In the Azure Portal, create an Azure Data Factory.
   - Build a data pipeline that extracts data from the SQL Server instance and loads it into the Azure Data Lake Storage Gen2 account.

## Step 3: Set Up Databricks for Data Processing

1. Create an Azure Databricks workspace:
   - In the Azure Portal, create a Databricks workspace.
   - Launch a Databricks cluster for executing data transformations.

2. Install Delta Lake in your Databricks environment:
   - In the Databricks workspace, install the Delta Lake library by adding the appropriate Maven coordinates (io.delta:delta-core_2.12:1.2.1 for example) to your cluster’s configuration.

3. Process the data:
   - Use Spark and Delta Lake to process, transform, and clean the data from Azure Data Lake.

## Step 4: Azure Synapse Analytics Setup

1. Create an Azure Synapse Analytics workspace:
   - In the Azure Portal, create a Synapse Analytics workspace for querying and analyzing your transformed data.

2. Connect Databricks to Synapse:
   - Configure Databricks to output processed data into Synapse Analytics for advanced analytics and querying.

## Step 5: Power BI and Azure Machine Learning

1. Power BI for data visualization:
   - Connect Power BI to Azure Synapse Analytics for real-time data visualization and reporting.

2. Azure Machine Learning for model training:
   - Use Azure Machine Learning to build and train machine learning models on the processed data.
   - Deploy the models for production use, as needed.

## Notes

- Ensure your SQL Server container has sufficient resources to handle the data.
- Keep your Azure account credentials safe, and follow best practices for securing data in the cloud.
- Use Power BI dashboards to monitor and visualize data trends.
- Experiment with various machine learning models in Azure Machine Learning for better insights from your data.
