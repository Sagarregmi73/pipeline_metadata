#!/bin/bash
set -e

# Create .env from template if it doesn't exist
if [ ! -f .env ]; then
    echo "Creating .env from .env.example..."
    cp .env.example .env
fi

# Create necessary directories if they don't exist
mkdir -p airflow/dags
mkdir -p airflow/logs
mkdir -p airflow/config
mkdir -p data/incoming
mkdir -p data/archive
mkdir -p data/rejected

# Pull latest images
echo "Pulling Docker images..."
docker-compose pull

# Start services
echo "Starting services..."
docker-compose up -d

# Wait for services to be healthy
echo "Waiting for services to start..."
sleep 30

# Display service status
echo ""
echo "===== Service Status ====="
docker-compose ps
echo ""
echo "Airflow UI: http://localhost:8080 (admin/admin)"
echo "RabbitMQ UI: http://localhost:15672 (guest/guest)"
echo "PostgreSQL: localhost:5432"
