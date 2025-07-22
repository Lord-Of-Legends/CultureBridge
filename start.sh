#!/bin/bash

# Start Ollama server in the background
ollama serve &

# Wait for the Ollama server to be ready
echo "Waiting for Ollama to start..."
until curl -s http://localhost:11434 > /dev/null; do
  sleep 1
done

# Pull model
ollama pull llama2-uncensored

# Start the Node.js server
echo "Starting Node server..."
node server.js
