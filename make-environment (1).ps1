# 2️⃣ Criar o ambiente virtual Python
python -m venv dbt-venv

# 3️⃣ Ativar o ambiente virtual
.\dbt-venv\Scripts\activate

# 4️⃣ Atualizar pip (opcional mas recomendado)
python -m pip install --upgrade pip

# 5️⃣ Instalar o dbt-bigquery
pip install -r requirements.txt

# 6️⃣ Definir variáveis de ambiente (para a sessão atual)
# Substitui aqui com o teu project_id real e nome
$env:PROJECT_ID = "data-eng-dev-437916"
$env:SCHEMA_PREFIX = "tomas"

# 7️⃣ Verifica instalação dbt
dbt --version

# Instalar pre-commit
pip install pre-commit

# Instalar hooks
pre-commit install

# Rodar hooks em todos os arquivos
pre-commit run --all-files

Write-Host "`n✅ Ambiente de desenvolvimento dbt com BigQuery configurado com sucesso!"
Write-Host "PROJECT_ID = $env:PROJECT_ID"
Write-Host "SCHEMA_PREFIX = $env:SCHEMA_PREFIX"
Write-Host "`n🚀 Agora podes rodar dbt!"
