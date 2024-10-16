# Data Pipeline Process

## Step 1: Data Extraction
### Data Sources
- **NYC Taxi Data**: Public dataset containing taxi ride records (pickup, drop-off locations, fare, etc.).
- **Synthetic Data**: Generated using the `Faker` library, which mimics customer, driver, or payment information.

### Data Storage
Both datasets are stored in **Microsoft SQL Server** running on Docker. The SQL Server instance holds raw data that will be processed through the ETL pipeline.

## Step 2: Data Loading into Azure
Using **Azure Data Factory (ADF)**, the raw data from SQL Server is transferred to **Azure Data Lake Storage Gen2**. ADF orchestrates the data movement as follows:
- **Data Source**: SQL Server database in Docker.
- **Data Destination**: Azure Data Lake (Blob Storage).
  
Data is first loaded into **Bronze** (raw) storage within the Data Lake for further transformation.

## Step 3: Data Transformation in Databricks
Once data is in Azure Data Lake, it is processed in **Azure Databricks**. The ELT pipeline follows the **Bronze-Silver-Gold** architecture:
- **Bronze**: Raw data is loaded into Databricks from Azure Data Lake.
- **Silver**: Cleaned and filtered data with basic transformations (e.g., timestamp conversions, removing nulls).
- **Gold**: Finalized, highly aggregated data ready for analysis and machine learning.

Transformation logic includes:
- Timestamp conversion to ensure uniform formats.
- Deduplication and data cleaning steps.
- Joining and aggregating datasets to create meaningful metrics (e.g., total trips, fare analysis).

Databricks uses **Delta Lake** for efficient, scalable storage and querying during the transformation process.

## Step 4: Data Analysis in Synapse Analytics
Once transformed, the Gold-tier data is queried and analyzed using **Azure Synapse Analytics**. Synapse allows advanced querying and data analytics, making it easier to extract insights from the cleaned and processed data.

- Example: Analysis of peak taxi demand times, average trip durations, and fare distribution.

## Step 5: Visualization and Reporting in Power BI
Data from **Azure Synapse Analytics** is connected to **Power BI** for visualization:
- Dashboards showing key insights such as trip trends, fare distribution, and customer segmentation.
- Real-time data updates as the pipeline runs periodically.

## Step 6: Machine Learning with Azure ML
The processed data is fed into **Azure Machine Learning** for model training:
- Model objective: Predict taxi demand based on historical data (time, location, fare).
- Data used: Aggregated data from Gold-tier transformations in Databricks.
