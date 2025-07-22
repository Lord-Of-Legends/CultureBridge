#!/bin/bash
set -e

# Start Ollama server on 0.0.0.0 in background
ollama serve --host 0.0.0.0 &
OLLAMA_PID=$!

# Wait for Ollama to be available
echo "Waiting for Ollama..."
until curl -s http://localhost:11434 > /dev/null; do
  sleep 1
done
echo "Ollama is ready."

# Pull your model
ollama pull llama2-uncensored

# Start Node.js server (must bind to 0.0.0.0)
echo "Starting Node server..."
node server.js
