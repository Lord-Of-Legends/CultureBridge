#!/bin/bash

echo "🚀 Starting Ollama server..."
ollama serve &

echo "⏳ Waiting for Ollama server to be ready..."
until curl -s http://localhost:11434 > /dev/null; do
  echo "🔁 Still waiting for Ollama..."
  sleep 1
done
echo "✅ Ollama server is up."

# Only pull if not already pulled
if ! ollama list | grep -q "llama2-uncensored"; then
  echo "⬇️ Pulling model llama2-uncensored..."
  curl -X POST http://localhost:11434/api/pull -d '{"name":"llama2-uncensored"}'
else
  echo "📦 Model llama2-uncensored already available."
fi

echo "⌛ Waiting a moment to make sure model loads..."
sleep 2

echo "🚀 Starting Node.js app..."
node server.js
