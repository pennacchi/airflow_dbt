# Criando virtual enviroment
python -m venv venv
source venv/bin/activate

# Instalando packages
dbt deps


# Configurando variáveis de ambiente
cd env
export $(grep -v '^#' .env | xargs)
cd ..

ou nano ~/.bashrc
export MINHA_VARIAVEL="meu_valor"
com as variáveis no arquivo .env

# Roadmap
- Create schema.yml of datamart
- Create datamart final tables
- Create airflow enviroment
- Create a dag on airflow that insert a new sale and execute dbt project

# Tarefas executadas
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