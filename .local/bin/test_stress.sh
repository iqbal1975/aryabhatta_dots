#!/bin/bash

# Check if stress tool is installed
if ! command -v stress &>/dev/null; then
  echo "stress tool not found. Installing..."
  sudo pacman -S stress
fi

# Check for input arguments
if [ "$#" -ne 2 ]; then
  echo "Usage: $0  "
  exit 1
fi

cores=$1
duration=$2

# Validate input
if ! [[ "$cores" =~ ^[0-9]+$ ]] || ! [[ "$duration" =~ ^[0-9]+$ ]]; then
  echo "Both arguments must be positive integers."
  exit 1
fi

echo "Starting CPU stress test on $cores cores for $duration seconds..."

# Run stress test
stress --cpu "$cores" --timeout "$duration"

echo "Stress test completed!"
