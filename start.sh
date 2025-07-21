#!/bin/bash

# Start Ollama in the background
ollama serve &

# Wait for Ollama to initialize
echo "Starting Ollama..."
sleep 5

# Optional: Pull llama2-uncensored again (if not pre-pulled in Dockerfile)
ollama pull llama2-uncensored

# Start the Node.js server
echo "Starting Node server..."
node server.js
