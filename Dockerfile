# Usa imagem base com Node.js e Python
FROM node:18-bullseye

# Instala dependências do sistema
RUN apt-get update && apt-get install -y \
  python3.11 python3.11-venv python3.11-dev \
  python3-pip git curl build-essential \
  && rm -rf /var/lib/apt/lists/*

# Linka python e pip
RUN ln -sf python3.11 /usr/bin/python3 && ln -sf pip3 /usr/bin/pip

# Cria diretório de trabalho
WORKDIR /app

# Copia tudo do seu projeto
COPY . .

# Instala dependências do backend
RUN pip install -r requirements.txt

# Instala e compila o frontend
WORKDIR /app/frontend
RUN npm install && npm run build

# Volta pro backend
WORKDIR /app

# Expõe porta
EXPOSE 3000

# Inicia o backend
CMD ["uvicorn", "opendevin.server.listen:app", "--host", "0.0.0.0", "--port", "3000"]
