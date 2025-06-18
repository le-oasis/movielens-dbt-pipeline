# MovieLens dbt Project

This directory contains the dbt transformation models for the MovieLens dataset.

## Models Overview

### Staging (`models/staging/`)
- Clean and standardize raw data
- Basic data quality filters
- Column renaming and type casting

### Dimensions (`models/dim/`)
- `dim_movies`: Movie master data
- `dim_users`: User dimension  
- `dim_genome_tags`: Tag definitions

### Facts (`models/fct/`)
- `fct_genome_scores`: Movie-tag relevance scores

### Analyses (`analyses/`)
- Sample queries for testing and exploration

## Running Models

```bash
# Run all models
dbt run

# Run specific selection
dbt run --select staging
dbt run --select marts

# Test data quality
dbt test

# Generate docs
dbt docs generate && dbt docs serve
```
