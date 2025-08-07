import os
from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.providers.docker.operators.docker import DockerOperator
from airflow.operators.bash import BashOperator
from docker.types import Mount
import csv
import random
from datetime import datetime, timedelta
import os

CSV_PATH_NEW_SALES = os.path.join(
    os.path.dirname(os.path.dirname(__file__)),
    "dbt_project",
    "seeds",
    "erp_new_system",
    "new_sales.csv"
)

CSV_PATH_NEW_SALES_DETAILS = os.path.join(
    os.path.dirname(os.path.dirname(__file__)),
    "dbt_project",
    "seeds",
    "erp_new_system",
    "new_sales_details.csv"
)


def generate_new_sale_details(sale_id, n_products=2):
    """Gera n_products linhas de detalhes para uma venda e salva no arquivo de detalhes."""
    product_ids = [f"P{str(random.randint(1, 20)).zfill(3)}" for _ in range(n_products)]
    details_rows = []
    for product_id in product_ids:
        price_per_unit = round(random.uniform(1, 100), 2)
        qty = random.randint(1, 5)
        discount_percentage = round(random.choices([0, 0.05, 0.10], weights=[0.8, 0.1, 0.1])[0], 2)
        deleted = random.choices(["FALSE", "TRUE"], weights=[0.9, 0.1])[0]
        details_rows.append([
            sale_id, product_id, price_per_unit, qty, discount_percentage, deleted
        ])
    # Write new lines on csv
    with open(CSV_PATH_NEW_SALES_DETAILS, "a", newline="") as f:
        writer = csv.writer(f)
        writer.writerow('')
        writer.writerows(details_rows)
    return details_rows

def generate_new_sale(last_id):
    random_date = datetime(1999, 1, 1) + timedelta(random.randint(0, 90))
    sale_id = last_id + 1
    customer_id = random.randint(5000, 5010)
    salesperson_id = random.randint(101, 104)
    sale_date = random_date.strftime("%Y-%m-%d")
    required_delivery_date = (random_date + timedelta(days=7)).strftime("%Y-%m-%d")
    shipped_date = (random_date + timedelta(days=3)).strftime("%Y-%m-%d")
    ship_via = random.choice(["Correios", "Transportadora", "FedEx", "DHL"])
    freight_value = round(random.uniform(15, 80), 2)
    ship_address_id = random.randint(2000, 2010)
    # Generate sales details when creatin a new sale
    num_products = random.randint(1, 5)
    generate_new_sale_details(sale_id, num_products)
    return [
        sale_id, customer_id, salesperson_id, sale_date,
        required_delivery_date, shipped_date, ship_via,
        freight_value, ship_address_id
    ]



def append_new_sales(n=2):
    with open(CSV_PATH_NEW_SALES, "r", newline="") as f:
        reader = list(csv.reader(f))
        last_row = reader[-1]
        last_id = int(last_row[0])
        
    new_rows = [generate_new_sale(last_id + i) for i in range(0, n)]

    with open(CSV_PATH_NEW_SALES, "a", newline="") as f:
        writer = csv.writer(f)
        writer.writerow('')
        writer.writerows(new_rows)


def _remove_empty_lines(file_path):
    with open(file_path, "r") as f:
        lines = f.readlines()

    with open(file_path, "w") as f:
        for line in lines:
            if line.strip():
                f.write(line)


default_args = {
    'owner': 'airflow',
}


with DAG(
    dag_id='append_new_sales_csv',
    default_args=default_args,
    start_date=datetime(2023, 1, 1),
    schedule_interval=None,
    catchup=False,
    tags=['csv', 'sales', 'dbt', 'seeds'],
) as dag:

    append_new_sales_task = PythonOperator(
        task_id='append_new_sales',
        python_callable=append_new_sales
    )

    remove_empty_lines_new_sales_task = PythonOperator(
        task_id='Remove_empty_lines_new_sales',
        python_callable=_remove_empty_lines,
        op_args=[CSV_PATH_NEW_SALES]
    )

    remove_empty_lines_new_sales_details_task = PythonOperator(
        task_id='Remove_empty_lines_new_sales_details',
        python_callable=_remove_empty_lines,
        op_args=[CSV_PATH_NEW_SALES_DETAILS]
    )

    dag_folder = os.path.dirname(os.path.abspath(__file__))
    dbt_project_path = os.path.join(dag_folder, '..', '..','dbt_project')


    dbt_seeds = DockerOperator(
        task_id="dbt_seeds",
        image="dbt_image", 
        container_name="update_dbt_seeds",
        api_version="auto",
        auto_remove=True,
        command="dbt seed --profiles-dir .", 
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


    append_new_sales_task \
        >> remove_empty_lines_new_sales_task \
        >> remove_empty_lines_new_sales_details_task \
        >> dbt_seeds