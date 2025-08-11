# Requirements
  - Python 3.9
  - Docker and Docker Compose


# Setup bigquery
Go to BigQuery and create a project and dataset. My project is 'penna-airflow-dbt"' and dataset is 'dbt'.Still on BigQuery generate a service account and download your project keys. Go to airflow folder:

cd airflow

Replace variables values with the respective values of the json you download on the file 'Sample.env' and rename it to '.env'.`

cd ..


# Adjust airflow user on linux
Get your user id or create a user for airflow. This step is necessary because airflow will
update csv files on dbt_project/seeds, so run command:

id -u

With the result, update the variable AIRFLOW_UID on airflow/.env file


# Set up a dbt image
This create an image that will generate a temporary container everytime we run a task on airflow related to dbt. Run commands:

cd dbt_project
docker build -t dbt_image .

*Run command 'docker images' to check if the image was created.


# Set up airflow containers
This will create the containers that will run airflow. Run command:

cd airflow
docker compose up airflow-dbt
cd ..


## Starting the project
This will start running each container of airflow. Run commands:

cd airflow
docker compose up -d
cd ..


# Run project
There are 2 DAGs:
  - "append_new_sales": this dag will add new random data to:
    - dbt_project/seeds/erp_new_system/new_sales.csv
    - dbt_project/seeds/erp_new_system/new_sales_details.csv
  - "run_ransformations": this dag will create/update all project schemas (stage, intermediate, and datamart).


## Do you want to execute dbt models locally?


# Create virtual enviroment
python -m venv venv
source venv/bin/activate


# Install dependecies
We only need on our enviroment dbt libraries (not necessary airflow). Run command:

pip install -r requirements.txt


# Install dbt packages
Run command:

dbt deps


# Setting up envirorment variables
This will set your environment variables (linux) temporally. Run command:

cd airflow
set -a; source .env; set +a
cd ..


# Execute dbt commands
With these configurations above, you are all set to run dbt commands. Go dbt_project: 

cd dbt_project

Now run dbt commands you want:

dbt seed



## Roadmap

# To do
- Create CI/CD (I am having an error with the variable 'PROD_BIGQUERY_PROJECT' on github secrets. I don't know why, but it is not avaible)
- Create an EC2, install and run the entire project
- Publish the project on github, linkedin, and telegram

# Done
- Create a dag to run the workflow (verify if i am saving data on other database from bigquery instead of previous database) ✅
- Delete folder utils from this folder and docker ✅
- Create a example file of the .env files ✅
- I got an error of permission on airflow accessing new_sales_details.csv. Maybe it is because I removed the "AIRFLOW_UID" ✅
- At the end of dag\append_new_sales, execute dbt -seed (I need to fix error on virtual enviroments) ✅
- Create airflow enviroment ✅
- Create a dag on airflow that insert a new sale and execute dbt project ✅
- Create schema.yml of datamart ✅
- Create datamart final tables ✅
- Create standard on names of intermediate models. Example: on dim_Customers, instead of Company_Name should be Customer_Name ✅
- Validate schema.yml of northwind stage ✅
- Create schema.yml of erp_new_system stage ✅
- Create schema.yml of intermediate ✅
- Improve int_fact_orders with data from erp_new_sales_system ✅
- Improve int_dim_products with data from erp_new_sales_system ✅
- Improve int_dim_shippers with data from erp_new_sales_system ✅
- Improve int_dim_customers with data from erp_new_sales_system ✅
- Improve int_dim_employees with data from erp_new_sales_system ✅
- Create stage/erp_new_system sources.yml ✅
- Create script stg_ for each source ✅
- Adjust freight value on fact_orders (it is using the entire freight value for each order_detail) ✅
- Criar tabela de vendas e CRUD ✅
- Criar tabela de detalhes da venda e CRUD ✅
- Criar tabela de produtos e CRUD ✅
- Criar tabela de vendedores e CRUD ✅
- Criar dim_customer ✅
- Criar dim_shipper ✅