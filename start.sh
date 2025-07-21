#!/bin/bash

# Start Ollama server in background
ollama serve &

# Wait for Ollama to be ready
echo "Waiting for Ollama to start..."
until curl -s http://localhost:11434 > /dev/null; do
  sleep 1
done

# Pull the model
echo "Pulling llama2-uncensored model..."
ollama pull llama2-uncensored

# Start your app (adjust if not server.js)
echo "Starting Node server..."
node server.js
