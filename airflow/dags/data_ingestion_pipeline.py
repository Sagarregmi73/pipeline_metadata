from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
import logging

logger = logging.getLogger(__name__)

# Default arguments for DAG
default_args = {
    'owner': 'data-platform',
    'retries': 2,
    'retry_delay': timedelta(minutes=5),
    'start_date': datetime(2024, 1, 1),
}

# Define the DAG
dag = DAG(
    'data_ingestion_pipeline',
    default_args=default_args,
    description='End-to-end data ingestion pipeline',
    schedule_interval='@daily',  # Run daily
    catchup=False,
    tags=['data-platform', 'bronze'],
)

def hello_task():
    """Simple task to verify pipeline is running"""
    logger.info("✅ Data Ingestion Pipeline Started")
    return "Pipeline initialized"

def get_latest_file():
    """Get the latest file from incoming folder"""
    import os
    incoming_folder = "/app/data/incoming"
    files = os.listdir(incoming_folder)
    if files:
        latest_file = max([os.path.join(incoming_folder, f) for f in files], key=os.path.getctime)
        logger.info(f"📄 Latest file: {latest_file}")
        return latest_file
    return None

# Task 1: Start
start_task = PythonOperator(
    task_id='start',
    python_callable=hello_task,
    dag=dag,
)

# Task 2: Get latest file
get_file_task = PythonOperator(
    task_id='get_latest_file',
    python_callable=get_latest_file,
    dag=dag,
)

# Task 3: End
end_task = BashOperator(
    task_id='end',
    bash_command='echo "✅ Pipeline completed"',
    dag=dag,
)

# Set dependencies
start_task >> get_file_task >> end_task
