FROM python:3.11-slim

# Set environment variables to optimize runtime behavior
ENV PYTHONDONTWRITEBYTECODE=1

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a non-root user and group for the application
RUN groupadd -r appuser && useradd --no-log-init -r -g appuser appuser

# Set the working directory
WORKDIR /app

# Copy application dependencies first (for better caching)
COPY /microservice/requirements.txt /app/

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code into the container
COPY /microservice/app.py /app/

# Set file permissions for the non-root user
RUN chown -R appuser:appuser /app

# Switch to the non-root user
USER appuser

# Expose the port the app runs on
EXPOSE 8080

# Default command to run the application
CMD ["python3", "app.py"]
