FROM python:3.11-slim

# Instala Node.js 18.x e dependências
RUN apt-get update && apt-get install -y curl git build-essential \
  && curl -fsSL https://deb.nodesource.com/setup_18.x | bash - \
  && apt-get install -y nodejs \
  && apt-get clean

# Diretório do app
WORKDIR /app

# Copia os arquivos
COPY . .

# Instala Poetry
COPY requirements.txt .

# Instala dependências do backend
RUN pip install -r requirements.txt

# Compila o frontend
WORKDIR /app/frontend
RUN npm install && npm run build

# Volta pro backend
WORKDIR /app

# Expõe porta
EXPOSE 3000

# Inicia backend
CMD ["uvicorn", "opendevin.server.listen:app", "--host", "0.0.0.0", "--port", "3000"]
