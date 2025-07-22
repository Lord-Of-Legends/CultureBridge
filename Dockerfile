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

# Pull the llama2-uncensored model at runtime
# Note: We'll do this in start.sh to avoid Render build failures

# Set working directory
WORKDIR /app

# Copy and install dependencies
COPY package*.json ./
RUN npm install

# Copy all other files
COPY . .

# Make the startup script executable
RUN chmod +x /app/start.sh

# Expose dynamic port for Render
EXPOSE ${PORT}

# Start Ollama and your app
CMD ["/app/start.sh"]
