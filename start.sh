#!/bin/bash
set -e

# Start Ollama server
ollama serve &

# Wait for Ollama to become responsive
until curl -s http://localhost:11434 > /dev/null; do
  echo "Waiting for Ollama..."
  sleep 1
done

# Start Node.js server
node server.js
