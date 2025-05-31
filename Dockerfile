FROM python:3.11-slim

# Install Docker CLI so we can exec into other containers
RUN apt-get update && apt-get install -y docker.io && apt-get clean

# Set working directory
WORKDIR /app

# Copy Python script
COPY jellyfin_gpu_exporter.py .

# Install Prometheus client
RUN pip install prometheus_client

# Expose metrics port
EXPOSE 9109

# Run exporter
CMD ["python", "jellyfin_gpu_exporter.py"]
