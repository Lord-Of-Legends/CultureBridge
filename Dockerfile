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

# Set working directory
WORKDIR /app

# Copy dependencies and install
COPY package*.json ./
RUN npm install

# Copy all other files
COPY . .

# Make the start script executable
RUN chmod +x /app/start.sh

# Expose ports
EXPOSE 11434 5000

# Run startup script
CMD ["/app/start.sh"]
