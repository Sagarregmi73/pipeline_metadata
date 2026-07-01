#!/bin/bash
set -e

echo "=========================================="
echo "Enterprise Data Platform Startup"
echo "=========================================="
echo ""

# Create .env from template if it doesn't exist
if [ ! -f .env ]; then
    echo "[1/5] Creating .env from .env.example..."
    if [ ! -f .env.example ]; then
        echo "ERROR: .env.example not found!"
        echo "Try: git pull origin main"
        exit 1
    fi
    cp .env.example .env
    echo "✅ .env created"
else
    echo "[1/5] .env already exists"
fi

echo ""
echo "[2/5] Creating directories..."
mkdir -p airflow/dags
mkdir -p airflow/logs
mkdir -p airflow/config
mkdir -p data/incoming
mkdir -p data/archive
mkdir -p data/rejected
echo "✅ Directories created"

echo ""
echo "[3/5] Checking docker-compose..."
if ! command -v docker-compose &> /dev/null; then
    echo "ERROR: docker-compose not found!"
    echo "Make sure Docker is installed and running"
    exit 1
fi
echo "✅ docker-compose found"

echo ""
echo "[4/5] Pulling Docker images..."
docker-compose pull
echo "✅ Images pulled"

echo ""
echo "[5/5] Starting services..."
docker-compose up -d
echo "✅ Services started"

echo ""
echo "=========================================="
echo "Waiting for services to be ready..."
echo "=========================================="
sleep 15

echo ""
echo "Service Status:"
docker-compose ps

echo ""
echo "=========================================="
echo "✅ ALL SERVICES RUNNING"
echo "=========================================="
echo ""
echo "Access your services:"
echo "  🌐 Airflow UI:  http://localhost:8080"
echo "     Login: admin / admin"
echo ""
echo "  📦 RabbitMQ UI: http://localhost:15672"
echo "     Login: guest / guest"
echo ""
echo "  🐘 PostgreSQL:  localhost:5432"
echo "     User: airflow / airflow"
echo ""
echo "View logs:"
echo "  docker-compose logs -f airflow-webserver"
echo "  docker-compose logs -f watchdog"
echo ""
echo "Stop services:"
echo "  docker-compose down"
echo ""
