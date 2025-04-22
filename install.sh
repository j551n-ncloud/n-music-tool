#!/bin/bash
# Installation script for N-Music Tool with virtual environment

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

echo -e "${YELLOW}=== N-Music Tool Installation ===${NC}"
echo "This script will install N-Music Tool with all dependencies in a virtual environment."

# Check for Python3
if ! command_exists python3; then
    echo -e "${RED}Error: Python 3 is not installed. Please install Python 3 and try again.${NC}"
    exit 1
fi

# Check Python version
PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
echo -e "${GREEN}Found Python ${PYTHON_VERSION}${NC}"

# Check for pip
if ! command_exists pip3; then
    echo -e "${YELLOW}Installing pip for Python 3...${NC}"
    if command_exists apt-get; then
        sudo apt-get update && sudo apt-get install -y python3-pip
    elif command_exists brew; then
        brew install python3
    else
        echo -e "${RED}Error: Cannot install pip. Please install pip for Python 3 manually.${NC}"
        exit 1
    fi
fi

# Check for venv module
echo -e "${YELLOW}Checking for Python venv module...${NC}"
python3 -c "import venv" 2>/dev/null
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}Installing Python venv module...${NC}"
    if command_exists apt-get; then
        sudo apt-get update && sudo apt-get install -y python3-venv
    else
        echo -e "${RED}Warning: Could not install Python venv automatically. You may need to install it manually.${NC}"
    fi
fi

# Check for ffmpeg
if ! command_exists ffmpeg; then
    echo -e "${YELLOW}Installing ffmpeg (required by spotdl)...${NC}"
    if command_exists apt-get; then
        sudo apt-get update && sudo apt-get install -y ffmpeg
    elif command_exists brew; then
        brew install ffmpeg
    else
        echo -e "${RED}Warning: Cannot install ffmpeg automatically. You may need to install it manually.${NC}"
    fi
fi

# Create virtual environment
echo -e "${YELLOW}Creating virtual environment...${NC}"
python3 -m venv .venv
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to create virtual environment.${NC}"
    exit 1
fi

# Activate virtual environment
echo -e "${YELLOW}Activating virtual environment...${NC}"
source .venv/bin/activate
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to activate virtual environment.${NC}"
    exit 1
fi

# Install dependencies
echo -e "${YELLOW}Installing Python dependencies...${NC}"
pip install --upgrade pip
pip install spotdl eyeD3

# Make scripts executable
chmod +x n-music.sh setup.sh
if [ -f "build-binary.sh" ]; then
    chmod +x build-binary.sh
fi
if [ -f "setup-music-services.sh" ]; then
    chmod +x setup-music-services.sh
fi

# Create activation script
echo -e "${YELLOW}Creating activation script...${NC}"
cat > run.sh << 'EOL'
#!/bin/bash
source .venv/bin/activate
./n-music.sh
EOL
chmod +x run.sh

# Run setup script to configure BASE_PATH
echo -e "${YELLOW}Running setup to configure your music directory...${NC}"
./setup.sh

echo -e "${GREEN}=== Installation Complete ===${NC}"
echo -e "To use N-Music Tool, run: ${YELLOW}./run.sh${NC}"
echo -e "This will activate the virtual environment and start the tool."
echo ""
echo -e "Other available commands:"
echo -e "- ${YELLOW}./setup.sh${NC} - Change your music directory configuration"
if [ -f "build-binary.sh" ]; then
    echo -e "- ${YELLOW}./build-binary.sh${NC} - Create a standalone binary executable"
fi
if [ -f "setup-music-services.sh" ]; then
    echo -e "- ${YELLOW}./setup-music-services.sh${NC} - Set up optional music streaming servers"
fi
echo ""
echo -e "${GREEN}Would you like to run N-Music Tool now? (y/n)${NC}"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    ./run.sh
fi