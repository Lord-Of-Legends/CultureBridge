#!/bin/bash

# Start Ollama in background
ollama serve &

# Wait for it to start
sleep 5

# Start Node.js app
npm start
