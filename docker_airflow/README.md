# Airflow Orchestration

Docker Compose setup for Apache Airflow to orchestrate the dbt pipeline.

## Services
- **postgres**: Database for Airflow metadata
- **airflow-webserver**: Web UI (port 8080)
- **airflow-scheduler**: Task scheduler
- **airflow-init**: Initialization service

## DAGs
- `movielens_dbt_pipeline`: Main pipeline (daily schedule)
- `dbt_manual_operations`: Manual operations

## Usage

```bash
# Start services
./start_airflow.sh

# Stop services  
./stop_airflow.sh

# View logs
docker-compose logs -f
```

## Access
- UI: http://localhost:8080
- Username: airflow
- Password: airflow
