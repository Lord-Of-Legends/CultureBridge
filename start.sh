#!/bin/bash

echo "🚀 Starting Ollama server..."
ollama serve &

# Give Ollama a few seconds to start
sleep 5

echo "⬇️ Pulling llama2-uncensored model..."
ollama pull llama2-uncensored

echo "🌐 Starting Node server..."
node server.js
