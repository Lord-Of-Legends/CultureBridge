#!/bin/bash

# Start Ollama server in the background
ollama serve &

# Wait for Ollama to start
echo "Waiting for Ollama server..."
until curl -s http://localhost:11434 > /dev/null; do
  sleep 1
done

# Pull model only if not already pulled
if ! ollama list | grep -q "llama2-uncensored"; then
  echo "Pulling llama2-uncensored model..."
  ollama pull llama2-uncensored
else
  echo "Model llama2-uncensored is already available."
fi

# Start your Node.js server
echo "Starting Node server..."
node server.js
