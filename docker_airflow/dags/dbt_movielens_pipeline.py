"""
MovieLens dbt Pipeline DAG
Orchestrates the complete data transformation pipeline
"""

from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.dummy import DummyOperator

# Default arguments
default_args = {
    'owner': 'data-team',
    'depends_on_past': False,
    'start_date': datetime(2024, 6, 18),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# Create DAG
dag = DAG(
    'movielens_dbt_pipeline',
    default_args=default_args,
    description='Complete MovieLens data transformation pipeline using dbt',
    schedule_interval=timedelta(days=1),  # Run daily
    catchup=False,
    max_active_runs=1,
    tags=['dbt', 'movielens', 'data-pipeline', 'analytics'],
)

# Start task
start_pipeline = DummyOperator(
    task_id='start_pipeline',
    dag=dag,
)

# dbt debug - verify connection
dbt_debug = BashOperator(
    task_id='dbt_debug_connection',
    bash_command='cd /opt/airflow/dbt && dbt debug',
    dag=dag,
)

# dbt run staging models
dbt_run_staging = BashOperator(
    task_id='dbt_run_staging_models',
    bash_command='cd /opt/airflow/dbt && dbt run --select staging',
    dag=dag,
)

# dbt run dimension models
dbt_run_dimensions = BashOperator(
    task_id='dbt_run_dimension_models',
    bash_command='cd /opt/airflow/dbt && dbt run --select dim_movies dim_genome_tags dim_users',
    dag=dag,
)

# dbt run fact models
dbt_run_facts = BashOperator(
    task_id='dbt_run_fact_models',
    bash_command='cd /opt/airflow/dbt && dbt run --select fct_genome_scores',
    dag=dag,
)

# dbt test all models
dbt_test_all = BashOperator(
    task_id='dbt_test_data_quality',
    bash_command='cd /opt/airflow/dbt && dbt test',
    dag=dag,
)

# dbt generate documentation
dbt_generate_docs = BashOperator(
    task_id='dbt_generate_documentation',
    bash_command='cd /opt/airflow/dbt && dbt docs generate',
    dag=dag,
)

# Data validation queries
dbt_validate_pipeline = BashOperator(
    task_id='validate_pipeline_results',
    bash_command='cd /opt/airflow/dbt && dbt show --select top_movies_by_tag --limit 5',
    dag=dag,
)

# End task
end_pipeline = DummyOperator(
    task_id='pipeline_completed',
    dag=dag,
)

# Define task dependencies
start_pipeline >> dbt_debug >> dbt_run_staging
dbt_run_staging >> dbt_run_dimensions
dbt_run_dimensions >> dbt_run_facts
dbt_run_facts >> dbt_test_all
dbt_test_all >> [dbt_generate_docs, dbt_validate_pipeline]
[dbt_generate_docs, dbt_validate_pipeline] >> end_pipeline
