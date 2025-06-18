"""
Manual dbt operations DAG
For ad-hoc runs and testing
"""

from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator

default_args = {
    'owner': 'data-team',
    'depends_on_past': False,
    'start_date': datetime(2024, 6, 18),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 0,
}

dag = DAG(
    'dbt_manual_operations',
    default_args=default_args,
    description='Manual dbt operations for testing and debugging',
    schedule_interval=None,  # Manual trigger only
    catchup=False,
    tags=['dbt', 'manual', 'testing'],
)

# Individual model runs
run_staging_only = BashOperator(
    task_id='run_staging_only',
    bash_command='cd /opt/airflow/dbt && dbt run --select staging',
    dag=dag,
)

run_marts_only = BashOperator(
    task_id='run_marts_only',
    bash_command='cd /opt/airflow/dbt && dbt run --select marts',
    dag=dag,
)

test_models = BashOperator(
    task_id='test_models',
    bash_command='cd /opt/airflow/dbt && dbt test',
    dag=dag,
)

generate_docs = BashOperator(
    task_id='generate_docs',
    bash_command='cd /opt/airflow/dbt && dbt docs generate',
    dag=dag,
)

full_refresh = BashOperator(
    task_id='full_refresh_all',
    bash_command='cd /opt/airflow/dbt && dbt run --full-refresh',
    dag=dag,
)
