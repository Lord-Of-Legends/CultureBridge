# Use Ubuntu base image
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and Node.js 20
RUN apt-get update && \
    apt-get install -y curl gnupg ca-certificates build-essential git && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest && \
    apt-get clean

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Create app directory
WORKDIR /app

# Copy package.json and install node dependencies
COPY package*.json ./
RUN npm install

# Copy remaining files
COPY . .

# Make start script executable
RUN chmod +x /app/start.sh

# Expose required ports (Ollama + Express)
EXPOSE 11434 10000

# Start script
CMD ["/app/start.sh"]
