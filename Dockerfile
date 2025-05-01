# Imagem base com Python 3.11 + Node.js (via conda/miniconda)
FROM condaforge/mambaforge:latest

# Instala Node.js
RUN mamba install -y nodejs=18 npm && \
    mamba clean --all --yes

# Define diretório de trabalho
WORKDIR /app

# Copia os arquivos
COPY . .

# Instala Poetry
RUN pip install poetry

# Instala dependências com Poetry
RUN poetry config virtualenvs.create false && poetry install --no-root

# Compila o frontend
WORKDIR /app/frontend
RUN npm install && npm run build

# Volta pro backend
WORKDIR /app

# Expõe a porta do backend
EXPOSE 3000

# Comando de inicialização
CMD ["uvicorn", "opendevin.server.listen:app", "--host", "0.0.0.0", "--port", "3000"]
