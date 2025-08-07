from airflow import DAG
from airflow.providers.docker.operators.docker import DockerOperator
from datetime import datetime
import os



default_args = {
  'owner': 'airflow',
}


with DAG(
    dag_id='dbt_run_transformations',
    default_args=default_args,
    start_date=datetime(2025, 1, 1),
    schedule_interval=None,  # manual trigger
    catchup=False,
    tags=['dbt', 'transformations', 'stage', 'testes', 'intermediate', 'datamart', 'dbt_project'],
) as dag:

    run_stage = DockerOperator(
        task_id='run_stage',
        image='dbt_image',
        container_name="run_stage",
        auto_remove=True,
        command='dbt run -s stage',
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
        docker_url="tcp://docker-proxy:2375",
        environment=os.environ,
        network_mode="airflow_default",
        mount_tmp_dir=False,
    )

    run_stage >> run_test >> run_intermediate >> run_datamart