# Base image
FROM node:20

# Set working directory
WORKDIR /app

# Copy package files & install dependencies
COPY package*.json ./
RUN npm install

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Copy source code
COPY . .

# Ensure start.sh is executable
RUN chmod +x /app/start.sh

# Expose ports for Render
EXPOSE 10000 11434

# Start Ollama and the app
CMD ["/app/start.sh"]
