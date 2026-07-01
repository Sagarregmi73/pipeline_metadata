# 🚀 GitHub Codespaces & Local Setup Guide

## Option 1: GitHub Codespaces (Easiest)

### Step 1: Open in Codespaces
1. Go to your GitHub repo
2. Click **Code** → **Codespaces** → **Create codespace on main**
3. Wait for environment to initialize (~2 minutes)

### Step 2: Start Services
In the terminal:
```bash
# Make startup script executable
chmod +x start.sh

# Start all services
./start.sh
```

### Step 3: Access Services
Codespaces will auto-forward ports. Click on:
- **Airflow (Port 8080)** → http://localhost:8080
- **RabbitMQ (Port 15672)** → http://localhost:15672

---

## Option 2: Local Machine Setup

### Prerequisites
- **Docker Desktop** installed (Windows/Mac) or Docker Engine (Linux)
- **Git** installed
- **At least 8GB RAM** allocated to Docker

### Step 1: Clone Repository
```bash
git clone https://github.com/YOUR_USERNAME/metdata-driven-pipeline.git
cd enterprise-data-platform
```

### Step 2: Create Environment File
```bash
# Copy .env template if you need different settings
cp .env.example .env  # if it exists

# Or create from scratch
cat > .env << EOF
POSTGRES_USER=airflow
POSTGRES_PASSWORD=airflow
POSTGRES_DB=airflow
RABBITMQ_DEFAULT_USER=guest
RABBITMQ_DEFAULT_PASS=guest
EOF
```

### Step 3: Start Services

**Windows:**
```bash
start.bat
```

**Linux/Mac:**
```bash
chmod +x start.sh
./start.sh
```

**Manual (All Platforms):**
```bash
# Create directories
mkdir -p airflow/{dags,logs,config}
mkdir -p data/{incoming,archive,rejected}

# Start services
docker-compose up -d
```

### Step 4: Verify Services
```bash
# Check all containers are running
docker-compose ps

# Expected output:
# NAME              STATUS
# postgres          Up (healthy)
# rabbitmq          Up (healthy)
# airflow-webserver Up (running)
# airflow-scheduler Up (running)
# airflow-worker    Up (running)
# watchdog          Up (running)
```

### Step 5: Access Services
- **Airflow UI**: http://localhost:8080 → **admin/admin**
- **RabbitMQ UI**: http://localhost:15672 → **guest/guest**
- **PostgreSQL**: localhost:5432 (airflow/airflow)

---

## Option 3: GitHub Actions CI/CD (Optional)

### Setup Automated Testing

Create `.github/workflows/test.yml`:

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    
    services:
      postgres:
        image: postgres:15-alpine
        env:
          POSTGRES_USER: airflow
          POSTGRES_PASSWORD: airflow
          POSTGRES_DB: airflow
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
      
      rabbitmq:
        image: rabbitmq:3.12-management-alpine
        options: >-
          --health-cmd "rabbitmq-diagnostics -q ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt
      
      - name: Run Airflow validation
        run: |
          airflow dags list
      
      - name: Run tests
        run: |
          python -m pytest tests/ -v
```

---

## Troubleshooting

### Services Not Starting

**Check Docker daemon:**
```bash
docker ps
```

**If error, restart Docker:**
- Windows: Settings → Docker Desktop → Restart
- Mac: App menu → Restart
- Linux: `sudo systemctl restart docker`

### PostgreSQL Connection Error

```bash
# Reset everything
docker-compose down -v
docker volume prune -f
docker-compose up -d
```

### Airflow Can't Find DAGs

```bash
# Ensure DAG folder exists
mkdir -p airflow/dags
chmod 777 airflow/dags

# Restart Airflow
docker-compose restart airflow-webserver airflow-scheduler
```

### RabbitMQ Not Responding

```bash
docker-compose logs rabbitmq
docker-compose restart rabbitmq
```

---

## Quick Commands

```bash
# View logs
docker-compose logs -f airflow-webserver
docker-compose logs -f airflow-scheduler
docker-compose logs -f watchdog

# Stop services
docker-compose stop

# Start services
docker-compose start

# Full restart
docker-compose restart

# Remove everything (reset)
docker-compose down -v

# Check services status
docker-compose ps

# Execute command in container
docker-compose exec airflow-webserver airflow dags list
```

---

## GitHub Push Instructions

### Initial Setup

```bash
git add .
git commit -m "Initial commit: Enterprise Data Platform"
git push origin main
```

### Update After Changes

```bash
git add -A
git commit -m "Description of changes"
git push origin main
```

---

## File Structure for GitHub

```
enterprise-data-platform/
├── .github/
│   └── workflows/
│       └── test.yml              # CI/CD pipeline
├── airflow/
│   ├── dags/
│   │   └── data_ingestion_pipeline.py
│   ├── logs/                     # Git ignored
│   └── config/
├── docker/
│   └── Dockerfile.watchdog
├── data/
│   ├── incoming/
│   ├── archive/
│   └── rejected/
├── metadata/
│   ├── schema_mapping/
│   │   ├── apple.json
│   │   └── samsung.json
│   ├── target_schema/
│   │   └── standard_product.json
│   └── business_rules/
│       └── product_rules.json
├── notebooks/
│   ├── bronze/
│   ├── silver/
│   └── gold/
├── watchdog/
│   ├── __init__.py
│   ├── main.py
│   └── validator.py
├── tests/
├── docker-compose.yml
├── .env                          # Git ignored (use .env.example)
├── .env.example                  # Template for .env
├── .dockerignore
├── .gitignore
├── requirements.txt
├── README.md                     # Main guide
├── GITHUB_SETUP.md              # This file
├── start.sh                      # Linux/Mac startup
├── start.bat                     # Windows startup
└── CONTRIBUTING.md
```

---

## Next Steps

1. ✅ Start services locally or in Codespaces
2. ✅ Verify Airflow UI loads
3. ✅ Create test Airflow DAG
4. ✅ Test file detection in Watchdog
5. ✅ Connect to Databricks
6. ✅ Build Bronze notebook
7. ✅ Implement ETL pipeline

---

## Support

**Issues?** Check the main [README.md](README.md)

**Want to contribute?** See [CONTRIBUTING.md](CONTRIBUTING.md)
