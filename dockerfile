FROM python:3.9-slim

WORKDIR /app

# STEP 1: Copy only requirements to leverage Docker cache
COPY requirements.txt .

# STEP 2: Install dependencies (this layer is cached unless requirements.txt changes)
RUN pip install --no-cache-dir -r requirements.txt

# STEP 3: Copy the rest of the application source code
COPY . .

# Set the default command to run the app
CMD ["python", "main.py"]
