# Use the official Python image as the base image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

EXPOSE 8081
# Copy the dependencies file to the working directory
COPY requirements.txt .

# Install dependencies
RUN pip3 install -r requirements.txt
RUN apt-get update
RUN pip3 install flask

# Copy the content of the local src directory to the working directory
COPY . .

# Command to run the Flask application
CMD ["python", "app.py"]
