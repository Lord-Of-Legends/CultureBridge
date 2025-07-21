#!/bin/bash

# Start Ollama in the background
ollama serve &

# Wait a bit for Ollama to boot up
sleep 5

# Start your Node.js app
npm start
