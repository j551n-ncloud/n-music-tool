#!/bin/bash

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== N-Music Tool Binary Builder ===${NC}"
echo "This script will create a standalone binary version of N-Music Tool."

# Check if shc is installed
if ! command -v shc &> /dev/null; then
    echo -e "${YELLOW}The 'shc' tool is required but not installed.${NC}"
    echo -e "Installing shc..."
    
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y shc
    elif command -v yum &> /dev/null; then
        sudo yum install -y shc
    elif command -v brew &> /dev/null; then
        brew install shc
    else
        echo -e "${RED}Could not install shc. Please install it manually and try again.${NC}"
        echo "Visit: https://github.com/neurobin/shc"
        exit 1
    fi
fi

# Directory for binary output
mkdir -p bin

# Copy the original script to a temp file for modifications
cp n-music.sh bin/n-music-binary.sh

# Make executable
chmod +x bin/n-music-binary.sh

# Create the binary with shc
echo -e "${YELLOW}Creating binary...${NC}"
shc -f bin/n-music-binary.sh -o bin/n-music

# Check if successful
if [ $? -eq 0 ]; then
    echo -e "${GREEN}Binary creation successful!${NC}"
    echo -e "Binary created at: ${BLUE}$(pwd)/bin/n-music${NC}"
    
    # Clean up temporary files
    rm -f bin/n-music-binary.sh bin/n-music-binary.sh.x.c
    
    # Make the binary executable
    chmod +x bin/n-music
    
    # Offer to install to a system path
    echo ""
    echo -e "${YELLOW}Would you like to install the binary to /usr/local/bin?${NC}"
    echo "This will make it available system-wide as 'n-music'."
    echo "Administrator (sudo) privileges will be required."
    
    read -p "Install system-wide? (y/n): " install_choice
    case "$install_choice" in
        [Yy]*)
            echo -e "${YELLOW}Installing to /usr/local/bin...${NC}"
            sudo cp bin/n-music /usr/local/bin/
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}Installation successful!${NC}"
                echo "You can now run 'n-music' from anywhere."
            else
                echo -e "${RED}Installation failed. You may need to copy the binary manually.${NC}"
            fi
            ;;
        *)
            echo -e "${YELLOW}Skipping system-wide installation.${NC}"
            echo "You can run the binary directly from: $(pwd)/bin/n-music"
            ;;
    esac
else
    echo -e "${RED}Binary creation failed.${NC}"
    # Clean up temporary files
    rm -f bin/n-music-binary.sh bin/n-music-binary.sh.x.c
fi