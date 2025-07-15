# Iniciando a sessão na EC2
ssh -i "penna_airflow_dbt.pem" ec2-user@ec2-34-201-57-66.compute-1.amazonaws.com

# Instalando git
Como a distribuição do Linux é a fedora, precisamos instalar via dnf

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
- Create intermediate place for erp_new_system (maybe)
- Improve int_dim_customers with data from erp_new_sales_system
- Improve int_dim_employees with data from erp_new_sales_system
- Improve int_dim_products with data from erp_new_sales_system
- Improve int_dim_shippers with data from erp_new_sales_system
- Improve int_fact_orders with data from erp_new_sales_system

# Tarefas executadas
- Create stage/erp_new_system sources.yml ✅
- Create script stg_ for each source ✅
- Adjust freight value on fact_orders (it is using the entire freight value for each order_detail) ✅
- Criar tabela de vendas e CRUD ✅
- Criar tabela de detalhes da venda e CRUD ✅
- Criar tabela de produtos e CRUD ✅
- Criar tabela de vendedores e CRUD ✅
- Criar dim_customer ✅
- Criar dim_shipper ✅