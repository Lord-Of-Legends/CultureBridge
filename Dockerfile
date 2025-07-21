# Base image
FROM ubuntu:22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies and remove conflicting Node packages
RUN apt-get update && \
    apt-get remove -y nodejs libnode-dev && \
    apt-get install -y curl gnupg ca-certificates build-essential git && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest && \
    apt-get clean

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Pull LLaMA 2 model
RUN ollama pull llama2

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy all other app files
COPY . .

# Copy and set permissions for start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose ports
EXPOSE 11434 5000

# Start Ollama and the app
CMD ["/start.sh"]
