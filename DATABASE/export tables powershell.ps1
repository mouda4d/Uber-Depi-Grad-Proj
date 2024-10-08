# Set the execution policy to allow running scripts
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Import the SqlServer module
Import-Module SqlServer

# Define the server instance and database
$serverInstance = "."  # Change to your SQL Server instance
$database = "UBER"
$outputDir = "E:\"  # Change to your desired output directory

# Define the list of table names
$tables = @("User", "VehicleMakes", "Vehicles", "Location", "Request", "PaymentMethod", "PaymentStatus", "Payment", "Trip", "uber_data_final")

# Loop over each table and export the results to CSV
foreach ($table in $tables) {
    # Define the output file path
    $outputFile = Join-Path -Path $outputDir -ChildPath "$table.csv"
    
    # Run the query and export to CSV using sqlcmd
    sqlcmd -S $serverInstance -d $database -Q "SET NOCOUNT ON; SELECT * FROM [$table];" -o $outputFile -s "," -W -C

    Write-Host "Exported $table to $outputFile"
}
