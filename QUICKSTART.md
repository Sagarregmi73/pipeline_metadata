# Quick Start from GitHub

## For GitHub Users

### 1️⃣ **Clone Repository**
```bash
git clone https://github.com/Sagarregmi73/pipeline_metadata.git
cd enterprise-data-platform
```

### 2️⃣ **Start Services**

The startup script automatically creates `.env` from `.env.example`:

**Windows:**
```bash
start.bat      # Auto-creates .env, then starts Docker
```

**Linux/Mac:**
```bash
chmod +x start.sh
./start.sh     # Auto-creates .env, then starts Docker
```

Your directory will look like:
```
✅ .env.example    (always here - on GitHub)
✅ .env            (created by startup script - git ignored)
```

**Windows:**
```bash
start.bat
```

**Linux/Mac:**
```bash
chmod +x start.sh
./start.sh
```

**Manual (All platforms):**
```bash
docker-compose up -d
```

### 4️⃣ **Verify Services (1-2 minutes)**
```bash
docker-compose ps
```

Expected output:
```
NAME              STATUS
postgres          Up (healthy)
rabbitmq          Up (healthy)
airflow-webserver Up (running)
airflow-scheduler Up (running)
airflow-worker    Up (running)
watchdog          Up (running)
```

### 5️⃣ **Access Services**

| Service | URL | Credentials |
|---------|-----|-------------|
| **Airflow** | http://localhost:8080 | admin/admin |
| **RabbitMQ** | http://localhost:15672 | guest/guest |
| **PostgreSQL** | localhost:5432 | airflow/airflow |

---

## GitHub Codespaces (Easiest)

1. Go to: https://github.com/Sagarregmi73/pipeline_metadata
2. Click **Code** → **Codespaces** → **Create codespace on main**
3. Wait for initialization (~2 minutes)
4. In terminal:
```bash
chmod +x start.sh
./start.sh
```
5. Click on port 8080 when prompted → Airflow opens automatically

---

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Docker not running | Start Docker Desktop or `systemctl start docker` |
| Port already in use | `docker-compose down` then restart |
| PostgreSQL error | `docker-compose down -v && docker-compose up -d` |
| RabbitMQ not responding | `docker-compose restart rabbitmq` |
| DAGs not showing | `mkdir -p airflow/dags` and restart |

---

## Common Commands

```bash
# View logs
docker-compose logs -f airflow-webserver
docker-compose logs -f watchdog

# Stop services
docker-compose stop

# Restart all
docker-compose restart

# Full reset
docker-compose down -v
docker-compose up -d
```

---

## Documentation

- **[README.md](README.md)** - Main documentation
- **[GITHUB_SETUP.md](GITHUB_SETUP.md)** - Detailed GitHub setup
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - How to contribute
- **[.env.example](.env.example)** - Environment variables

---

## What's Next?

✅ Infrastructure ready (Phase 2)
✅ Watchdog service ready (Phase 3)  
✅ File validation ready (Phase 4)
✅ Metadata framework ready (Phase 5)
✅ Airflow DAGs ready (Phase 6)

⬜ **Next: Connect to Databricks** (Phase 7)
⬜ Bronze ingestion (Phase 8)
⬜ Silver transformations (Phase 9)
⬜ Gold data marts (Phase 10)
