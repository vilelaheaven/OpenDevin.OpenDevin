# Usa Node + Python como base
FROM node:18-bullseye

# Instala dependências do sistema e Python 3.11
RUN apt-get update && apt-get install -y \
    python3.11 python3.11-venv python3.11-dev \
    python3-pip git curl build-essential \
    && rm -rf /var/lib/apt/lists/*

# Aliases para python e pip
RUN ln -sf python3.11 /usr/bin/python3 && ln -sf pip3 /usr/bin/pip

# Instala Poetry
RUN curl -sSL https://install.python-poetry.org | python3 - && \
    ln -s ~/.local/bin/poetry /usr/local/bin/poetry

# Cria diretório de trabalho
WORKDIR /app

# Copia os arquivos
COPY . .

# Instala dependências do backend
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
