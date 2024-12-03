#!/bin/bash

# sigint
cleanup() {
  echo "Stopping Flask server..."
  kill $FLASK_PID
  echo "Stopping frontend server..."
  kill $FRONTEND_PID
  exit 0
}

trap cleanup SIGINT SIGTERM

# Deploy Backend
echo "Deploying Backend..."
cd ../Backend || { echo "Backend directory not found!"; exit 1; }
echo "Starting Flask server on port 5050..."
flask run -p 5050 & FLASK_PID=$!

# Deploy Frontend
echo "Deploying Frontend..."
cd ../Frontend || { echo "Frontend directory not found!"; exit 1; }

# Check if node_modules exists, and install if necessary
if [ ! -d "node_modules" ]; then
  echo "node_modules not found, running npm install..."
  npm install
else
  echo "node_modules found, skipping npm install."
fi

echo "Starting frontend server..."
npm start & FRONTEND_PID=$!

wait $FLASK_PID
wait $FRONTEND_PID

