#!/bin/bash

echo "🛑 Stopping MovieLens dbt + Airflow Pipeline"
echo "============================================="

# Stop all services
docker-compose down

# Optional: Remove volumes (uncomment if you want to reset everything)
# docker-compose down -v

echo "✅ All services stopped"
