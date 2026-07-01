@echo off
REM Create necessary directories if they don't exist
mkdir airflow\dags 2>nul
mkdir airflow\logs 2>nul
mkdir airflow\config 2>nul
mkdir data\incoming 2>nul
mkdir data\archive 2>nul
mkdir data\rejected 2>nul

REM Pull latest images
echo Pulling Docker images...
docker-compose pull

REM Start services
echo Starting services...
docker-compose up -d

REM Wait for services to be healthy
echo Waiting for services to start...
timeout /t 30 /nobreak

REM Display service status
echo.
echo ===== Service Status =====
docker-compose ps
echo.
echo Airflow UI: http://localhost:8080 (admin/admin)
echo RabbitMQ UI: http://localhost:15672 (guest/guest)
echo PostgreSQL: localhost:5432
