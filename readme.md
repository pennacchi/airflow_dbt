# Iniciando a sessão na EC2
ssh -i "penna_airflow_dbt.pem" ec2-user@ec2-34-201-57-66.compute-1.amazonaws.com

# Instalando git
Como a distribuição do Linux é a fedora, precisamos instalar via dnf

# Criando virtual enviroment
python -m venv venv
source venv/bin/activate

# Atualizando repositório git

# Configurando variáveis de ambiente
cd env
export $(grep -v '^#' .env | xargs)
cd ..