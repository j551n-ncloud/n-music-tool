#!/bin/bash

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== N-Music Tool - Music Services Setup ===${NC}"
echo "This script will set up Navidrome and/or Feishin music services."

# Check if Docker and Docker Compose are installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed. Please install Docker first.${NC}"
    echo "Visit: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${RED}Error: Docker Compose is not installed. Please install Docker Compose first.${NC}"
    echo "Visit: https://docs.docker.com/compose/install/"
    exit 1
fi

# Get current config if exists
CONFIG_FILE="${HOME}/.config/n-music/config"
MUSIC_PATH=""
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
    MUSIC_PATH="$BASE_PATH"
else
    # Default if no config found
    MUSIC_PATH="${HOME}/Music"
fi

echo -e "${YELLOW}Current music directory:${NC} $MUSIC_PATH"
echo ""

# Create directories if they don't exist
mkdir -p "$(pwd)/navidrome/data"
mkdir -p "$MUSIC_PATH"

# Check if docker-compose.yml exists
if [ ! -f "docker-compose.yml" ]; then
    echo -e "${RED}Error: docker-compose.yml not found in the current directory.${NC}"
    exit 1
fi

# Uncomment the Navidrome and Feishin sections in docker-compose.yml
echo -e "${YELLOW}Enabling music services in docker-compose.yml...${NC}"

# Create backup
cp docker-compose.yml docker-compose.yml.bak

# Uncomment Navidrome section
sed -i 's/# navidrome:/navidrome:/g' docker-compose.yml
sed -i 's/#   image: deluan\/navidrome:latest/  image: deluan\/navidrome:latest/g' docker-compose.yml
sed -i 's/#   container_name: navidrome/  container_name: navidrome/g' docker-compose.yml
sed -i 's/#   user: 1000:1000/  user: 1000:1000/g' docker-compose.yml
sed -i 's/#   ports:/  ports:/g' docker-compose.yml
sed -i 's/#     - "4533:4533"/    - "4533:4533"/g' docker-compose.yml
sed -i 's/#   restart: unless-stopped/  restart: unless-stopped/g' docker-compose.yml
sed -i 's/#   environment:/  environment:/g' docker-compose.yml
sed -i 's/#   volumes:/  volumes:/g' docker-compose.yml
sed -i 's/#     - .\/navidrome\/data:\/data/    - .\/navidrome\/data:\/data/g' docker-compose.yml
sed -i 's/#     - .\/music:\/music:ro/    - .\/music:\/music:ro/g' docker-compose.yml

# Ask about Feishin
echo ""
echo -e "${BLUE}Would you like to enable Feishin client as well? (y/n)${NC}"
read -r enable_feishin
if [[ "$enable_feishin" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    # Uncomment Feishin section
    sed -i 's/# feishin:/feishin:/g' docker-compose.yml
    sed -i 's/#   image:/  image:/g' docker-compose.yml
    sed -i 's/#   container_name: feishin/  container_name: feishin/g' docker-compose.yml
    sed -i 's/#   environment:/  environment:/g' docker-compose.yml
    sed -i 's/#     - SERVER_NAME=navidrome/    - SERVER_NAME=navidrome/g' docker-compose.yml
    sed -i 's/#     - SERVER_LOCK=true/    - SERVER_LOCK=true/g' docker-compose.yml
    sed -i 's/#     - SERVER_TYPE=navidrome/    - SERVER_TYPE=navidrome/g' docker-compose.yml
    sed -i 's/#     - SERVER_URL=http:\/\/navidrome:4533/    - SERVER_URL=http:\/\/navidrome:4533/g' docker-compose.yml
    sed -i 's/#     - PUID=1000/    - PUID=1000/g' docker-compose.yml
    sed -i 's/#     - PGID=1000/    - PGID=1000/g' docker-compose.yml
    sed -i 's/#     - UMASK=002/    - UMASK=002/g' docker-compose.yml
    sed -i 's/#     - TZ=America\/Los_Angeles/    - TZ=America\/Los_Angeles/g' docker-compose.yml
    sed -i 's/#   ports:/  ports:/g' docker-compose.yml
    sed -i 's/#     - 9180:9180/    - 9180:9180/g' docker-compose.yml
    sed -i 's/#   restart: unless-stopped/  restart: unless-stopped/g' docker-compose.yml
    sed -i 's/#   depends_on:/  depends_on:/g' docker-compose.yml
    sed -i 's/#     - navidrome/    - navidrome/g' docker-compose.yml
fi

echo -e "${GREEN}Music services enabled in docker-compose.yml${NC}"
echo ""
echo -e "${YELLOW}Would you like to start the services now? (y/n)${NC}"
read -r start_services
if [[ "$start_services" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "${YELLOW}Starting services...${NC}"
    
    # Use the appropriate docker-compose command
    if command -v docker-compose &> /dev/null; then
        docker-compose up -d
    else
        docker compose up -d
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Music services started successfully!${NC}"
        echo ""
        echo -e "Navidrome is available at: ${BLUE}http://localhost:4533${NC}"
        if [[ "$enable_feishin" =~ ^([yY][eE][sS]|[yY])$ ]]; then
            echo -e "Feishin is available at: ${BLUE}http://localhost:9180${NC}"
        fi
        echo ""
        echo -e "${YELLOW}Default Navidrome admin credentials:${NC}"
        echo "Username: admin@admin.com"
        echo "Password: admin"
        echo -e "${YELLOW}Please change these after first login!${NC}"
    else
        echo -e "${RED}Failed to start services. Check docker logs for details.${NC}"
    fi
else
    echo -e "${YELLOW}You can start the services later with:${NC}"
    echo "docker-compose up -d"
fi