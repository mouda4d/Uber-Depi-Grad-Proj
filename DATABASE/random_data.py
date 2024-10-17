import csv
import random
from faker import Faker

# Initialize Faker instance
fake = Faker()

# Number of rows of data to generate
num_rows = 1000000  # You can increase this to generate more data

# Define the CSV file and column headers
csv_file = "random_data.csv"
columns = [
    'passenger_name', 'passenger_email', 'passenger_phone',
    'driver_name', 'driver_email', 'driver_phone',
    'vehicle_model', 'vehicle_make', 'vehicle_year', 'vehicle_color', 
    'plate_num', 'payment_type', 'payment_status'
]

# Define possible values for certain columns
vehicle_colors = ['Red', 'Blue', 'Black', 'White', 'Silver', 'Gray', 'Green', 'Yellow', 'Brown', 'Orange']
payment_types = ['Credit Card', 'Debit Card', 'Cash', 'PayPal', 'Apple Pay', 'Google Pay']
payment_statuses = ['Completed', 'Pending', 'Failed', 'Refunded']

# Predefined lists of vehicle makes and models
vehicle_makes = ['Toyota', 'Ford', 'Chevrolet', 'Honda', 'Nissan', 'BMW', 'Mercedes-Benz', 'Volkswagen', 'Hyundai', 'Kia']
vehicle_models = {
    'Toyota': ['Camry', 'Corolla', 'RAV4', 'Highlander', 'Tacoma'],
    'Ford': ['F-150', 'Mustang', 'Explorer', 'Fusion', 'Escape'],
    'Chevrolet': ['Silverado', 'Malibu', 'Equinox', 'Tahoe', 'Camaro'],
    'Honda': ['Civic', 'Accord', 'CR-V', 'Pilot', 'Fit'],
    'Nissan': ['Altima', 'Maxima', 'Rogue', 'Sentra', 'Murano'],
    'BMW': ['3 Series', '5 Series', 'X3', 'X5', 'Z4'],
    'Mercedes-Benz': ['C-Class', 'E-Class', 'GLA', 'GLC', 'S-Class'],
    'Volkswagen': ['Golf', 'Jetta', 'Passat', 'Tiguan', 'Beetle'],
    'Hyundai': ['Elantra', 'Sonata', 'Tucson', 'Santa Fe', 'Kona'],
    'Kia': ['Optima', 'Sorento', 'Sportage', 'Forte', 'Soul']
}

# Dictionaries to store unique driver/passenger data
drivers = {}
passengers = {}

# Open CSV file for writing
with open(csv_file, mode='w', newline='') as file:
    writer = csv.DictWriter(file, fieldnames=columns)
    writer.writeheader()
    
    for _ in range(num_rows):
        # Determine if we will reuse an existing driver
        if random.random() < 0.5 and drivers:  # 50% chance to reuse an existing driver
            driver_name = random.choice(list(drivers.keys()))
            driver_email, driver_phone, vehicles = drivers[driver_name]
        else:
            # Create a new driver
            driver_name = fake.name()
            driver_email = fake.email()
            driver_phone = f"({random.randint(100, 999)}) {random.randint(100, 999)}-{random.randint(1000, 9999)}"  # Consistent phone format

            # Generate 1 to 3 vehicles for the new driver
            vehicle_count = random.randint(1, 3)
            vehicles = []
            for _ in range(vehicle_count):
                make = random.choice(vehicle_makes)
                model = random.choice(vehicle_models[make])  # Choose a model based on the make
                vehicles.append({
                    'vehicle_model': model,
                    'vehicle_make': make,
                    'vehicle_year': random.randint(1990, 2023),  # Random year between 1990 and 2023
                    'vehicle_color': random.choice(vehicle_colors),
                    'plate_num': fake.license_plate(),
                })

            drivers[driver_name] = (driver_email, driver_phone, vehicles)

        # Determine if we will reuse an existing passenger
        if random.random() < 0.5 and passengers:  # 50% chance to reuse an existing passenger
            passenger_name = random.choice(list(passengers.keys()))
            passenger_email, passenger_phone = passengers[passenger_name]
        else:
            # Create a new passenger
            passenger_name = fake.name()
            passenger_email = fake.email()
            passenger_phone = f"({random.randint(100, 999)}) {random.randint(100, 999)}-{random.randint(1000, 9999)}"  # Consistent phone format
            passengers[passenger_name] = (passenger_email, passenger_phone)

        # Select one vehicle for the current trip from the driver's vehicles
        selected_vehicle = random.choice(vehicles)

        # Create a row of data
        row = {
            'passenger_name': passenger_name,
            'passenger_email': passenger_email,
            'passenger_phone': passenger_phone,
            'driver_name': driver_name,
            'driver_email': driver_email,
            'driver_phone': driver_phone,
            'vehicle_model': selected_vehicle['vehicle_model'],
            'vehicle_make': selected_vehicle['vehicle_make'],
            'vehicle_year': selected_vehicle['vehicle_year'],
            'vehicle_color': selected_vehicle['vehicle_color'],
            'plate_num': selected_vehicle['plate_num'],
            'payment_type': random.choice(payment_types),
            'payment_status': random.choice(payment_statuses),
        }

        writer.writerow(row)

print(f"Random data written to {csv_file}")


#docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=0123456789mM!" -p 1433:1433 --name sql-server -d mcr.microsoft.com/mssql/server:2022-latest
#sa 
#0123456789

#docker exec -it sql-server /opt/mssql-tools/bin/sqlcmd -S localhost -U SA -P 0123456789mM!
