# Base image
FROM ubuntu:22.04

# Prevents some interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && \
    apt-get install -y curl gnupg ca-certificates build-essential nodejs npm git && \
    apt-get clean

# Install Node.js v18 via NodeSource (skip error by removing old node)
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Pull LLaMA 2 model
RUN ollama pull llama2

# Create app directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy the rest of the application
COPY . .

# Copy the startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose necessary ports (adjust if needed)
EXPOSE 11434 5000

# Start Ollama and your app
CMD ["/start.sh"]
