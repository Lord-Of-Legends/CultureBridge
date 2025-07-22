#!/bin/bash

# Start Ollama server in background
ollama serve &

# Wait until Ollama API is ready
echo "Waiting for Ollama to start..."
until curl -s http://localhost:11434 > /dev/null; do
  sleep 1
done

# Pull the model if not present
curl -X POST http://localhost:11434/api/pull -d '{"name":"llama2-uncensored"}'

# Start the Node server
node server.js
