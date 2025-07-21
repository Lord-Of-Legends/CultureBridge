#!/bin/bash

# Start ollama in the background
ollama serve &

# Wait a bit for ollama to be ready
sleep 5

# Start your Node.js server
npm start