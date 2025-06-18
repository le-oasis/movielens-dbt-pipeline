#!/bin/bash

echo "🚀 Starting MovieLens dbt + Airflow Pipeline"
echo "============================================="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop first."
    exit 1
fi

# Set proper permissions
chmod +x start_airflow.sh

# Initialize Airflow (first time only)
if [ ! -f ".airflow_initialized" ]; then
    echo "🔧 Initializing Airflow (first time setup)..."
    docker-compose up airflow-init
    touch .airflow_initialized
    echo "✅ Airflow initialized successfully"
fi

# Start all services
echo "🔄 Starting Airflow services..."
docker-compose up -d

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 30

# Check if services are running
if docker-compose ps | grep -q "Up"; then
    echo "✅ Airflow is running!"
    echo ""
    echo "🌐 Access URLs:"
    echo "   Airflow UI: http://localhost:8080"
    echo "   Username: airflow"
    echo "   Password: airflow"
    echo ""
    echo "📊 Available DAGs:"
    echo "   - movielens_dbt_pipeline (scheduled daily)"
    echo "   - dbt_manual_operations (manual trigger)"
    echo ""
    echo "🛠️ Useful commands:"
    echo "   View logs: docker-compose logs -f"
    echo "   Stop services: docker-compose down"
    echo "   Restart: docker-compose restart"
else
    echo "❌ Some services failed to start. Check logs with: docker-compose logs"
fi
