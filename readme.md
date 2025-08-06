# Requirements
  - Python 3.9
  - Docker and Docker Compose


# Create virtual enviroment
python -m venv venv
source venv/bin/activate


# Setup bigquery
`Go to BigQuery and create a project and dataset. My project is 'penna-airflow-dbt"' and dataset is 'dbt'.Still on BigQuery generate a service account and download your project keys. `
`Go 'airflow' folder and replace variables values with the respective values of the json you download on the file 'Sample.env' and rename it to '.env'.`
cd airflow

# Adjust airflow user on linux
`Go to airflow and get your user id or create a user for airflow. To use the current user, execute command:`
id -u
`Update the variable AIRFLOW_UID on .env file`

# Set up a dbt image
`This step will create an image that will generate a temporary container everytime we run a taks on airflow related to dbt.`
cd dbt_project
docker build -t dbt_image .
`Run command 'docker images' to check if the image was created.`

# Set up airflow containers
`This will create the containers that will run airflow`
cd airflow
docker compose up airflow-dbt
cd ..


## Starting the project
`This will start running each container of airflow`
cd airflow
docker compose up -d
cd ..

# Run project
`There are 2 DAGs:`
  - `"append_new_sales": add new random data to csvs on dbt_project/seeds/erp_new_system.`
  - `"run_ransformations": will create/update all schemas (stage, intermediate, and datamart) of dataset`


## Do you want to execute dbt models locally?

# Install dependecies
`We only need on our enviroment dbt libraries (not necessary airflow).`
pip install -r requirements.txt


# Install dbt packages
dbt deps

# Setting up envirorment variables
`This will set your environment variables (linux)`
cd airflow
set -a; source .env; set +a
cd ..

# Roadmap
- I got an error of permission on airflow accessing new_sales_details.csv. Maybe it is because I removed the "AIRFLOW_UID"
- At the end of dag\append_new_sales, execute dbt -seed (I need to fix error on virtual enviroments)
- Discover how not to expose .env files on git
- Create a example file of the .env files
- Delete folder utils from this folder and docker
- Create a dag to run the workflow
- Create CI/CD
- Create an EC2, install and run the entire project
- Publish the project on github, linkedin, and telegram

# Executed tasks
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