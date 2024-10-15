#!/bin/bash

# Define the database and server(from Docker environment variables)
SERVER_INSTANCE="$SQL_SERVER_INSTANCE"  # set in Docker Compose
DATABASE="$DATABASE_NAME"   # Set in Docker Compose
OUTPUT_DIR="/export"  # Directory in the container that is mounted from the host

# Define the list of table names
tables=("User" "VehicleMakes" "Vehicles" "Location" "Request" "PaymentMethod" "PaymentStatus" "Payment" "Trip")

# Loop over each table and export the results to CSV
for table in "${tables[@]}"; do
    # Define the output file path
    output_file="$OUTPUT_DIR/$table.csv"
    
    # Run the query and export to CSV
    sqlcmd -S "$SERVER_INSTANCE" -d "$DATABASE" -Q "SET NOCOUNT ON; SELECT * FROM [$table]" -o "$output_file" -s "," -W
    
    echo "Exported $table to $output_file"
done
