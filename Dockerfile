# Base image
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies and Node.js 20
RUN apt-get update && \
    apt-get remove -y nodejs libnode-dev && \
    apt-get install -y curl gnupg ca-certificates build-essential git && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest && \
    apt-get clean

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Add Ollama to PATH
ENV PATH="/root/.ollama/bin:$PATH"

# Start Ollama server in background and preload model
RUN ollama serve & \
    sleep 3 && \
    ollama pull llama2-uncensored || ollama pull llama2:7b-chat

# Set working directory
WORKDIR /app

# Copy dependency definitions and install
COPY package*.json ./
RUN npm install

# Copy the rest of the app
COPY . .

# Make sure start.sh is executable
RUN chmod +x /app/start.sh

# Expose Ollama and app ports
EXPOSE 11434 5000

# Start script (Ollama + server)
CMD ["/app/start.sh"]
