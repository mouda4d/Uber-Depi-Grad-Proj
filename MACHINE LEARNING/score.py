import json
import pandas as pd
from azureml.core.model import Model
import pickle

# Called once during startup to load the model
def init():
    global model
    model_path = Model.get_model_path("fare_prediction_model")
    model = pickle.load(open(model_path, "rb"))  # Open the file in binary mode

# Called each time new data comes in for inference
def run(raw_data):
    try:
        # Parse input data (assuming data is passed as JSON)
        input_data = json.loads(raw_data)

        # Validate input data format
        if not isinstance(input_data, dict):
            return json.dumps({"error": "Invalid input format. Expected a JSON object."})

        # Check if 'trip_distance' is present
        if 'trip_distance' not in input_data:
            return json.dumps({"error": "'trip_distance' key is missing from the input."})

        # Extract trip distance
        trip_distance = input_data['trip_distance']

        # Ensure trip_distance is either a list or a single float
        if isinstance(trip_distance, list):
            trip_series = pd.Series(trip_distance)  # Multiple distances as a Series
        elif isinstance(trip_distance, (int, float)):
            trip_series = pd.Series([trip_distance])  # Single distance as a Series
        else:
            return json.dumps({"error": "Invalid data type for 'trip_distance'. It must be a number or a list of numbers."})

        # Make prediction using the Series
        predictions = model.predict(trip_series.values.reshape(-1, 1))  # Reshape for prediction

        # Return predictions
        return json.dumps({"predictions": predictions.tolist()})

    except Exception as e:
        return json.dumps({"error": str(e)})

# !pip install azureml-sdk