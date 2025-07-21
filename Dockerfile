# Base image
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies & Node.js 20
RUN apt-get update && \
    apt-get remove -y nodejs libnode-dev && \
    apt-get install -y curl gnupg ca-certificates build-essential git && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest && \
    apt-get clean

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Pull llama2-uncensored model
RUN /root/.ollama/bin/ollama pull llama2-uncensored

# Set working directory
WORKDIR /app

# Copy and install dependencies
COPY package*.json ./
RUN npm install

# Copy all other files
COPY . .

# Add startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose ports
EXPOSE 11434 5000

# Start Ollama and the app
CMD ["/start.sh"]
