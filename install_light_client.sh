#!/bin/bash

# Function to prompt for private key input
prompt_private_key() {
    read -sp "Enter your PRIVATE_KEY: " PRIVATE_KEY
    echo
    if [ -z "$PRIVATE_KEY" ]; then
        echo "Private key cannot be empty."
        exit 1
    fi
}

# Check if PRIVATE_KEY is provided as an environment variable
if [ -z "$PRIVATE_KEY" ]; then
    echo "PRIVATE_KEY not set. Please enter it now."
    prompt_private_key
fi

# Stop and remove existing light-client containers if they exist
for i in {1..5}; do
    if docker ps -q -f name=light-client-$i; then
        docker stop light-client-$i
        docker rm light-client-$i
    fi
done

# Remove the existing ewm-das directory if it exists
if [ -d "ewm-das" ]; then
    rm -rf ewm-das
fi

# Clone the latest version of ewm-das from GitHub
if ! git clone https://github.com/covalenthq/ewm-das; then
    echo "Failed to clone ewm-das repository."
    exit 1
fi

# Navigate to the ewm-das directory
cd ewm-das || { echo "Failed to navigate to ewm-das directory."; exit 1; }

# Build the Docker image using Dockerfile.lc
if ! docker build -t covalent/light-client -f Dockerfile.lc .; then
    echo "Failed to build Docker image."
    exit 1
fi

# Run multiple Docker containers with different names
for i in {1..5}; do
    if ! docker run -d --restart always --name light-client-$i -e PRIVATE_KEY="$PRIVATE_KEY" covalent/light-client; then
        echo "Failed to run the Docker container light-client-$i."
        exit 1
    fi
done

# Show the logs of all running containers
for i in {1..5}; do
    echo "Logs for light-client-$i:"
    docker logs -f light-client-$i &
done

wait
