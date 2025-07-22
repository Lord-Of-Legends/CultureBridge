# Use official Node.js image
FROM node:20

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh

# Create app directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json ./
RUN npm install

# Copy app source
COPY . .

# Ensure start.sh is executable
RUN chmod +x ./start.sh

# Expose port
EXPOSE 5000

# Start script
CMD ["./start.sh"]
