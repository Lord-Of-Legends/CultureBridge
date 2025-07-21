# Use Ubuntu as base
FROM ubuntu:22.04

# Avoid UI prompts during install
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
  curl \
  wget \
  git \
  unzip \
  sudo \
  nodejs \
  npm \
  libcurl4-openssl-dev \
  libssl-dev \
  && apt-get clean

# Install Node.js 18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Pull the LLaMA 3 model (free and fast)
RUN ollama pull llama3

# Set working directory
WORKDIR /app

# Copy everything
COPY . .

# Install Node.js dependencies
RUN npm install

# Expose both ports: 11434 for Ollama, 5000 for Node server
EXPOSE 11434 5000

# Run Ollama in background and start Node.js server
CMD ollama serve & sleep 5 && node server.js