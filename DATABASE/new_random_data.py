import csv
import random
from faker import Faker
from itertools import islice

# Initialize Faker instance
fake = Faker()

# Number of rows of data to generate
num_rows = 1000000  # Adjust as needed

# Define the CSV file and column headers
csv_file = "optimized_random_data.csv"
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

# Pre-generate drivers and passengers
drivers = {}
passengers = {}

def generate_driver():
    """Generate driver info with 1 to 3 vehicles."""
    driver_name = fake.name()
    driver_email = fake.email()
    driver_phone = f"({random.randint(100, 999)}) {random.randint(100, 999)}-{random.randint(1000, 9999)}"

    # Generate 1 to 3 vehicles for the new driver
    vehicle_count = random.randint(1, 3)
    vehicles = []
    for _ in range(vehicle_count):
        make = random.choice(vehicle_makes)
        model = random.choice(vehicle_models[make])
        vehicles.append({
            'vehicle_model': model,
            'vehicle_make': make,
            'vehicle_year': random.randint(1990, 2023),
            'vehicle_color': random.choice(vehicle_colors),
            'plate_num': fake.license_plate(),
        })
    return driver_name, driver_email, driver_phone, vehicles

# Pre-generate passengers with a 50% chance of being reused
def generate_passenger():
    passenger_name = fake.name()
    passenger_email = fake.email()
    passenger_phone = f"({random.randint(100, 999)}) {random.randint(100, 999)}-{random.randint(1000, 9999)}"
    return passenger_name, passenger_email, passenger_phone

def bulk_data_generation(batch_size, progress_interval=50000):
    total_generated = 0
    for _ in range(0, num_rows, batch_size):
        batch_data = []
        for _ in range(batch_size):
            # Decide whether to reuse a driver
            if random.random() < 0.5 and drivers:
                driver_name = random.choice(list(drivers.keys()))
                driver_email, driver_phone, vehicles = drivers[driver_name]
            else:
                # Generate a new driver and store it
                driver_name, driver_email, driver_phone, vehicles = generate_driver()
                drivers[driver_name] = (driver_email, driver_phone, vehicles)

            # 20% chance for a driver to act as a passenger
            if random.random() < 0.2:
                passenger_name, passenger_email, passenger_phone = driver_name, driver_email, driver_phone
            else:
                # 50% chance to reuse an existing passenger
                if random.random() < 0.5 and passengers:
                    passenger_name = random.choice(list(passengers.keys()))
                    passenger_email, passenger_phone = passengers[passenger_name]
                else:
                    passenger_name, passenger_email, passenger_phone = generate_passenger()
                    passengers[passenger_name] = (passenger_email, passenger_phone)

            # Select a vehicle for this trip from the driver's vehicles
            selected_vehicle = random.choice(vehicles)

            # Append the generated row to the batch
            batch_data.append({
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
            })

        total_generated += batch_size

        # Print progress for every 50,000 records generated
        if total_generated % progress_interval == 0:
            print(f"Progress: {total_generated} records generated.")

        yield batch_data

# Write data to CSV in bulk to optimize file I/O
with open(csv_file, mode='w', newline='') as file:
    writer = csv.DictWriter(file, fieldnames=columns)
    writer.writeheader()

    # Process in batches of 10,000 rows
    batch_size = 10000
    for data_batch in bulk_data_generation(batch_size):
        writer.writerows(data_batch)

print(f"Optimized random data written to {csv_file}")
