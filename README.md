# MovieLens Data Pipeline

A complete data pipeline for MovieLens dataset using dbt, BigQuery, and Apache Airflow.

## 🏗️ Architecture

```
Raw CSV Files (GCS) → BigQuery Staging → dbt Transformations → Analytics Tables
                                     ↓
                               Apache Airflow (Orchestration)
```

## 📊 Data Flow

1. **Raw Data**: MovieLens dataset (movies, ratings, tags, genome scores)
2. **Staging**: Clean data loaded into BigQuery
3. **Transformations**: dbt models create dimension and fact tables
4. **Orchestration**: Airflow manages the entire pipeline
5. **Analytics**: Ready-to-use tables for analysis and reporting

## 🚀 Quick Start

### Prerequisites
- Python 3.11.9
- Docker Desktop
- Google Cloud SDK
- dbt-core 1.8.7 + dbt-bigquery 1.8.3

### Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/movielens-dbt-pipeline.git
   cd movielens-dbt-pipeline
   ```

2. **Set up Python environment**
   ```bash
   conda create -n dbt_env python=3.11.9
   conda activate dbt_env
   pip install dbt-core==1.8.7 dbt-bigquery==1.8.3
   ```

3. **Configure Google Cloud authentication**
   ```bash
   gcloud auth application-default login
   gcloud config set project YOUR_PROJECT_ID
   ```

4. **Configure dbt**
   ```bash
   cd netflix
   dbt debug
   ```

5. **Start Airflow**
   ```bash
   cd docker_airflow
   ./start_airflow.sh
   ```

6. **Access Airflow UI**
   - URL: http://localhost:8080
   - Username: airflow
   - Password: airflow

## 📁 Project Structure

```
movielens-dbt-pipeline/
├── netflix/                    # dbt project
│   ├── models/
│   │   ├── staging/           # Staging models
│   │   ├── dim/               # Dimension tables
│   │   ├── fct/               # Fact tables
│   │   └── marts/             # Business logic
│   ├── analyses/              # Analysis queries
│   ├── dbt_project.yml
│   └── README.md
├── docker_airflow/            # Airflow orchestration
│   ├── dags/                  # Airflow DAGs
│   ├── docker-compose.yml     # Docker services
│   ├── start_airflow.sh       # Start script
│   └── stop_airflow.sh        # Stop script
├── .gitignore
└── README.md
```

## 🗂️ Data Models

### Staging Models
- `stg_movies` - Clean movie data
- `stg_ratings` - User ratings
- `stg_tags` - User-generated tags
- `stg_genome_scores` - Movie-tag relevance scores
- `stg_genome_tags` - Tag definitions

### Dimension Tables
- `dim_movies` - Movie master data with enhanced attributes
- `dim_users` - User dimension
- `dim_genome_tags` - Tag definitions with formatting

### Fact Tables
- `fct_genome_scores` - Movie-tag relevance with analytics

## 🔄 Airflow DAGs

### movielens_dbt_pipeline (Scheduled Daily)
Complete data transformation pipeline:
1. dbt debug (connection test)
2. Run staging models
3. Run dimension models
4. Run fact models
5. Data quality tests
6. Generate documentation
7. Validate results

### dbt_manual_operations (Manual Trigger)
Individual operations for testing and debugging.

## 📈 Sample Queries

```sql
-- Top action movies by relevance
SELECT 
    m.movie_title, 
    f.relevance, 
    f.relevance_category
FROM fct_genome_scores f
JOIN dim_movies m ON f.movie_id = m.movieId
JOIN dim_genome_tags t ON f.tag_id = t.tag_id
WHERE t.tag_name LIKE '%Action%'
ORDER BY f.relevance DESC
LIMIT 10;
```

## 🧪 Testing

```bash
# Run all dbt tests
dbt test

# Run specific model tests
dbt test --select dim_movies

# Generate and serve documentation
dbt docs generate && dbt docs serve
```

## 🐳 Docker Commands

```bash
# Start Airflow
./start_airflow.sh

# Stop Airflow
./stop_airflow.sh

# View logs
docker-compose logs -f

# Restart services
docker-compose restart
```

## 📊 Key Metrics

- **Movies**: 27K+ movies with genres and metadata
- **Ratings**: 20M+ user ratings
- **Tags**: 465K+ user-generated tags  
- **Genome Scores**: 11.7M+ movie-tag relevance scores
- **Users**: Unique users across ratings and tags

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- MovieLens dataset by GroupLens Research
- dbt Labs for the transformation framework
- Apache Airflow for orchestration
