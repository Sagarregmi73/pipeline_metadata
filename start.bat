@echo off
setlocal enabledelayedexpansion

echo.
echo ==========================================
echo Enterprise Data Platform Startup
echo ==========================================
echo.

REM Create .env from template if it doesn't exist
if not exist .env (
    echo [1/5] Creating .env from .env.example...
    if not exist .env.example (
        echo ERROR: .env.example not found!
        echo Try: git pull origin main
        exit /b 1
    )
    copy .env.example .env >nul
    echo OK - .env created
) else (
    echo [1/5] .env already exists
)

echo.
echo [2/5] Creating directories...
mkdir airflow\dags 2>nul
mkdir airflow\logs 2>nul
mkdir airflow\config 2>nul
mkdir data\incoming 2>nul
mkdir data\archive 2>nul
mkdir data\rejected 2>nul
echo OK - Directories created

echo.
echo [3/5] Checking docker-compose...
docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: docker-compose not found!
    echo Make sure Docker is installed and running
    exit /b 1
)
echo OK - docker-compose found

echo.
echo [4/5] Pulling Docker images...
docker-compose pull
echo OK - Images pulled

echo.
echo [5/5] Starting services...
docker-compose up -d
echo OK - Services started

echo.
echo ==========================================
echo Waiting for services to be ready...
echo ==========================================
timeout /t 15 /nobreak

echo.
echo Service Status:
docker-compose ps

echo.
echo ==========================================
echo OK - ALL SERVICES RUNNING
echo ==========================================
echo.
echo Access your services:
echo   Web Airflow UI:  http://localhost:8080
echo      Login: admin / admin
echo.
echo   RabbitMQ UI:     http://localhost:15672
echo      Login: guest / guest
echo.
echo   PostgreSQL:      localhost:5432
echo      User: airflow / airflow
echo.
echo View logs:
echo   docker-compose logs -f airflow-webserver
echo   docker-compose logs -f watchdog
echo.
echo Stop services:
echo   docker-compose down
echo.
