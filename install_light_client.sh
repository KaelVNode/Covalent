#!/bin/bash

# ASCII Art for display
echo -e "\e[1;32m
 /$$$$$$                                      /$$          
 /$$__  $$                                    | $$          
| $$  \__/  /$$$$$$   /$$$$$$  /$$$$$$$   /$$$$$$$ /$$   /$$
|  $$$$$$  |____  $$ |____  $$| $$__  $$ /$$__  $$| $$  | $$
 \____  $$  /$$$$$$$  /$$$$$$$| $$  \ $$| $$  | $$| $$  | $$ 
 /$$  \ $$ /$$__  $$ /$$__  $$| $$  | $$| $$  | $$| $$  | $$ 
|  $$$$$$/|  $$$$$$$|  $$$$$$$| $$  | $$|  $$$$$$$|  $$$$$$$
 \______/  \_______/ \_______/|__/  |__/ \_______/ \____  $$ 
                                                   /$$  | $$ 
                                                  |  $$$$$$/ 
                                                   \______/  
"

# Function to prompt for private key input
prompt_private_key() {
    read -sp "Enter your PRIVATE_KEY: " PRIVATE_KEY
    echo
    if [ -z "$PRIVATE_KEY" ]; then
        echo "Private key cannot be empty."
        exit 1
    fi
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker is not installed or not in the PATH."
    exit 1
fi

# Prompt user for the number of light-client containers to run
read -p "How many light-client containers do you want to run (1-10)? " NUM_LIGHT_CLIENTS

# Validate input
if ! [[ "$NUM_LIGHT_CLIENTS" =~ ^[1-9][0-9]?$ ]] || [ "$NUM_LIGHT_CLIENTS" -gt 10 ]; then
    echo "Please enter a valid number between 1 and 10."
    exit 1
fi

# Check for PRIVATE_KEY
if [ -z "$PRIVATE_KEY" ]; then
    echo "PRIVATE_KEY not set. Please enter it now."
    prompt_private_key
fi

# Stop and remove existing light-client containers
for i in $(seq 1 "$NUM_LIGHT_CLIENTS"); do
    if docker ps -q -f name=light-client-$i | grep -q .; then
        echo "Stopping and removing existing container: light-client-$i"
        docker stop light-client-$i
        docker rm light-client-$i
    else
        echo "Container light-client-$i does not exist, skipping."
    fi
done

# Remove existing ewm-das directory if it exists
if [ -d "ewm-das" ]; then
    echo "Removing existing ewm-das directory."
    rm -rf ewm-das
else
    echo "ewm-das directory does not exist, skipping removal."
fi

# Clone the latest version of ewm-das from GitHub
echo "Cloning the latest version of ewm-das from GitHub..."
if ! git clone https://github.com/covalenthq/ewm-das; then
    echo "Failed to clone ewm-das repository."
    exit 1
fi

# Navigate to the ewm-das directory
cd ewm-das || { echo "Failed to navigate to ewm-das directory."; exit 1; }

# Build the Docker image using Dockerfile.lc
echo "Building the Docker image..."
if ! docker build -t covalent/light-client -f Dockerfile.lc .; then
    echo "Failed to build Docker image."
    exit 1
fi

# Run the specified number of Docker containers
for i in $(seq 1 "$NUM_LIGHT_CLIENTS"); do
    echo "Starting light-client-$i..."
    if ! docker run -d --restart always --name light-client-$i -e PRIVATE_KEY="$PRIVATE_KEY" covalent/light-client; then
        echo "Failed to run the Docker container light-client-$i."
        exit 1
    fi
done

# List all Docker containers
echo "Listing all Docker containers:"
docker ps -a

wait
