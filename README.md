# Enterprise Data Platform Setup Guide

## Prerequisites

- Docker Desktop (Windows/Mac) or Docker Engine (Linux)
- Docker Compose v2.0+
- At least 8GB RAM allocated to Docker
- 20GB free disk space

## Quick Start

### Option 1: Windows (Batch Script)
```bash
start.bat
```

### Option 2: Linux/Mac (Shell Script)
```bash
chmod +x start.sh
./start.sh
```

### Option 3: Manual Start
```bash
# Create directories
mkdir -p airflow/{dags,logs,config}
mkdir -p data/{incoming,archive,rejected}

# Start all services
docker-compose up -d
```

## Verify Services

After starting, wait 1-2 minutes for all services to initialize:

- **Airflow UI**: http://localhost:8080 (admin/admin)
- **RabbitMQ UI**: http://localhost:15672 (guest/guest)
- **PostgreSQL**: localhost:5432 (airflow/airflow)

Check service status:
```bash
docker-compose ps
```

View logs:
```bash
docker-compose logs -f airflow-webserver
docker-compose logs -f airflow-scheduler
docker-compose logs -f rabbitmq
docker-compose logs -f postgres
docker-compose logs -f watchdog
```

## Troubleshooting

### PostgreSQL not connecting
```bash
docker-compose down -v
rm -rf data/ airflow/logs/
docker-compose up -d
```

### Airflow can't find DAGs
Ensure DAG folder exists:
```bash
mkdir -p airflow/dags
chmod 777 airflow/dags
```

### RabbitMQ not responding
```bash
docker-compose restart rabbitmq
```

### Full Reset
```bash
docker-compose down -v
docker-compose pull
docker-compose up -d
```

## Environment Variables

Edit `.env` file to customize:

```
POSTGRES_USER=airflow
POSTGRES_PASSWORD=airflow
POSTGRES_DB=airflow
RABBITMQ_DEFAULT_USER=guest
RABBITMQ_DEFAULT_PASS=guest
```

## Architecture

```
┌─────────────────────────────────────────┐
│       Enterprise Data Platform          │
├─────────────────────────────────────────┤
│                                         │
│  ┌──────────────┐  ┌──────────────┐   │
│  │   RabbitMQ   │  │  PostgreSQL  │   │
│  │   :5672      │  │  :5432       │   │
│  └──────────────┘  └──────────────┘   │
│         ▲                  ▲            │
│         │                  │            │
│  ┌──────┴──────────────────┴──────┐   │
│  │                                │   │
│  │      Apache Airflow            │   │
│  │  Webserver│Scheduler│Worker    │   │
│  │  :8080                         │   │
│  │                                │   │
│  └────────────────────────────────┘   │
│         ▲                              │
│         │                              │
│  ┌──────┴─────────────────┐           │
│  │   Watchdog Container   │           │
│  │   Monitor /incoming    │           │
│  └────────────────────────┘           │
│                                       │
└─────────────────────────────────────────┘
```

## Data Flow

1. **File Arrives** → `/data/incoming`
2. **Watchdog Detects** → Validates file
3. **Valid File** → Stays in `/incoming`
4. **Invalid File** → Moves to `/rejected`
5. **Airflow DAG Triggers** → Processes file
6. **Bronze → Silver → Gold** → ETL pipeline
7. **Export** → Downstream systems

## Next Steps

After verifying all services are running:

1. Create your first Airflow DAG in `airflow/dags/`
2. Add metadata mappings in `metadata/schema_mapping/`
3. Create Databricks notebooks
4. Build Bronze ingestion pipeline
5. Add business rules transformations
6. Implement audit framework
