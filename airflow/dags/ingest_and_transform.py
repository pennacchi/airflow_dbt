from airflow import DAG
from airflow.providers.docker.operators.docker import DockerOperator
from docker.types import Mount
from datetime import datetime
import os

import os
import yaml
from io import BytesIO
from pathlib import Path
from airflow.models import DAG
from airflow.operators.python import PythonOperator
from datetime import datetime
from airflow.providers.amazon.aws.hooks.s3 import S3Hook
import pandas as pd
from airflow.providers.google.cloud.hooks.bigquery import BigQueryHook
from common.FileValidator import FileValidator

AWS_S3_CONNECTION = 'aws_s3'
BUCKET_NAME = 'penna.airflow.dbt'
DATASET_ID = 'raw'
BIGQUERY_CONNECTION = 'google_bigquery_dwh_dev'
METADATA_SOURCES_PATH = 'dags/data/sources/'

def extract_from_s3(file_path, file_type='csv', bucket_name=BUCKET_NAME, connection_id=AWS_S3_CONNECTION) -> pd.DataFrame:
    print(f"Extracting data from connection: '{connection_id}' of bucket '{bucket_name}:{file_path}'")
    s3_hook = S3Hook(aws_conn_id=connection_id)
    file_key = f'{file_path}'
    s3_object = s3_hook.get_key(file_key, bucket_name)

    if s3_object is None:
        raise ValueError(f"\n\nFile not found in s3://{bucket_name}/{file_key}\n\n")
    
    file_content = s3_object.get()['Body'] 

    data = BytesIO(file_content.read())
    if file_type == 'csv':
        df = pd.read_csv(data)
    elif file_type == 'xlsx':
        df = pd.read_excel(data)
    else:
        raise ValueError(f"Unsupported file type: {file_type} for file s3://{bucket_name}/{file_key}")
    print(f'\tExtracted {df.shape[0]} rows and {df.shape[1]} columns from {file_key}')
    return df

def load_dataframe_to_bigquery(df: pd.DataFrame, dataset_id: str, table_id: str):
    """
    Load a dataframe to a BigQuery table using Airflow's BigQueryHook for authentication.
    """
    if table_id[-4:].upper() == '.CSV':
        table_id = table_id[0:-4]
    print(f"Loadind data to connection: 'google_bigquery_dwh_dev' to dataset {dataset_id}.{table_id}")
    hook = BigQueryHook(gcp_conn_id=BIGQUERY_CONNECTION)

    credentials = hook.get_credentials()
    
    project_id = hook.project_id

    destination_table = f"{dataset_id}.{table_id}"

    df.to_gbq(
        destination_table=destination_table,
        project_id=project_id,
        credentials=credentials,
        if_exists='replace',
        chunksize=10000
    )

    print("Data was loaded with success!")

def ingest_file(file_properties, connection_id=AWS_S3_CONNECTION):
    file_path = file_properties['file_path']
    file_type = file_properties['file_type']
    df = extract_from_s3(file_path=file_path, file_type=file_type, bucket_name=BUCKET_NAME, connection_id=AWS_S3_CONNECTION)
    df = validate_file(df, file_properties)
    output_table_name = f'{connection_id}__{file_path}'
    output_table_name = output_table_name.replace('/', '__')
    load_dataframe_to_bigquery(df, dataset_id=DATASET_ID, table_id=output_table_name)

def validate_file(df, metadata):
    validator = FileValidator(df, metadata)
    validator.validate_all_mandatory_columns_exist()
    validator.validate_data_types(df)
    df = validator.remove_extra_columns(df)
    return df

def get_files_to_extract_metadata():
    files_metadata = []
    for system in ('erp_northwind', 'erp_new_system'):
        folder = f'{METADATA_SOURCES_PATH}{system}/' 
        for f in Path(folder).iterdir():
            with f.open('r', encoding='utf-8') as file_read:
                file_metadata = yaml.safe_load(file_read)
                files_metadata.append(file_metadata)
    print(files_metadata)
    return files_metadata

with DAG(
    dag_id='ingest_and_transform',
    start_date=datetime(2025, 1, 1),
    schedule_interval=None,  # manual trigger
    catchup=False,
    tags=['dbt', 'transformations', 'stage', 'testes', 'intermediate', 'datamart', 'dbt_project'],
) as dag:

    files_extract_metadata = get_files_to_extract_metadata()
    ingestion_tasks = []
    for file_metadata in files_extract_metadata:
        task_id = f"ingest_{file_metadata['file_path'].replace('/', '_')}"
        ingest_task = PythonOperator(
            task_id=task_id,
            python_callable=ingest_file,
            op_args=[file_metadata]
        )
        ingestion_tasks.append(ingest_task)

    run_stage = DockerOperator(
        task_id='run_stage',
        image='dbt_image',
        container_name="run_stage",
        auto_remove=True,
        command='dbt run -s stage',
        mounts=[
            Mount(
                source=os.path.join(os.environ.get('PROJECT_PATH'),"..","dbt_project"),
                target='/usr/src/dbt_project',
                type='bind'
            )
        ],
        docker_url="tcp://docker-proxy:2375",
        environment=os.environ,
        network_mode="airflow_default",
        mount_tmp_dir=False,
    )

    run_test = DockerOperator(
        task_id='run_test',
        image='dbt_image',
        container_name="run_test",
        auto_remove=True,
        command='dbt test -s stage',
        mounts=[
            Mount(
                source=os.path.join(os.environ.get('PROJECT_PATH'),"..","dbt_project"),
                target='/usr/src/dbt_project',
                type='bind'
            )
        ],
        docker_url="tcp://docker-proxy:2375",
        environment=os.environ,
        network_mode="airflow_default",
        mount_tmp_dir=False,
    )

    run_intermediate = DockerOperator(
        task_id='run_intermediate',
        image='dbt_image',
        container_name="run_intermediate",
        auto_remove=True,
        command='dbt run -s intermediate',
        mounts=[
            Mount(
                source=os.path.join(os.environ.get('PROJECT_PATH'),"..","dbt_project"),
                target='/usr/src/dbt_project',
                type='bind'
            )
        ],
        docker_url="tcp://docker-proxy:2375",
        environment=os.environ,
        network_mode="airflow_default",
        mount_tmp_dir=False,
    )

    run_datamart = DockerOperator(
        task_id='run_datamart',
        image='dbt_image',
        container_name="run_datamart",
        auto_remove=True,
        command='dbt run -s datamart',
        mounts=[
            Mount(
                source=os.path.join(os.environ.get('PROJECT_PATH'),"..","dbt_project"),
                target='/usr/src/dbt_project',
                type='bind'
            )
        ],
        docker_url="tcp://docker-proxy:2375",
        environment=os.environ,
        network_mode="airflow_default",
        mount_tmp_dir=False,
    )


    for ingest_task in ingestion_tasks:
        ingest_task >> run_stage
    
    run_stage >> run_test >> run_intermediate >> run_datamart