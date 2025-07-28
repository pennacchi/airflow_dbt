# Create virtual enviroment
python -m venv venv
source venv/bin/activate


# Install dependecies
pip install -r requirements.txt


# Intalling dbt packages
dbt deps


# Setting up enviroment variables (option 1)
cd env
export $(grep -v '^#' .env | xargs)
cd ..

# Setting up enviroment variables (option 2)
nano ~/.bashrc
export MINHA_VARIAVEL="meu_valor"
com as variáveis no arquivo .env

# Roadmap
- Create airflow enviroment
- Create a dag on airflow that insert a new sale and execute dbt project

# Executed tasks
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