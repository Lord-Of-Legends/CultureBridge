#!/bin/bash
echo "🚀 Starting Ollama server..."

# Start Ollama in the background
ollama serve &
OLLAMA_PID=$!

# Wait for Ollama to be ready
echo "⏳ Waiting for Ollama to become ready..."
until curl -s http://localhost:11434 | grep -q '"models"'; do
  sleep 1
done

echo "✅ Ollama is ready. Pulling model..."

# Pull model if not already pulled
ollama list | grep -q "llama2-uncensored" || ollama pull georgesung/llama2-uncensored

echo "✅ Model is ready."

# Start your Node.js server
echo "🚀 Launching Node.js server..."
node server.js
