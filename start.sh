#!/bin/bash

# Start Ollama server in background
ollama serve &

# Wait for Ollama server to become ready
sleep 5

# Pull the model once server is up
ollama pull llama2

# Start your Node.js app
npm start
