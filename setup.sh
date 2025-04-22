#!/bin/bash

# Color codes for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== N-Music Tool Setup ===${NC}"
echo "This script will set up your base music directory for N-Music Tool."

# Check if config directory exists, create if not
CONFIG_DIR="${HOME}/.config/n-music"
if [ ! -d "$CONFIG_DIR" ]; then
    echo -e "${YELLOW}Creating config directory at ${CONFIG_DIR}${NC}"
    mkdir -p "$CONFIG_DIR"
fi

# Get current config if exists
CONFIG_FILE="${CONFIG_DIR}/config"
CURRENT_BASE_PATH=""
if [ -f "$CONFIG_FILE" ]; then
    source "$CONFIG_FILE"
    CURRENT_BASE_PATH="$BASE_PATH"
fi

# Show current setting if exists
if [ -n "$CURRENT_BASE_PATH" ]; then
    echo -e "${YELLOW}Current music directory is set to:${NC} $CURRENT_BASE_PATH"
else
    echo -e "${YELLOW}No music directory currently configured. Default will be ~/Music${NC}"
fi

# Ask user for new path
echo ""
echo -e "${BLUE}Please specify your music directory:${NC}"
echo "1) Use default (~/Music)"
echo "2) Enter custom path"
if [ -n "$CURRENT_BASE_PATH" ]; then
    echo "3) Keep current setting ($CURRENT_BASE_PATH)"
fi

read -p "Choose an option: " path_choice

case "$path_choice" in
    1)
        NEW_BASE_PATH="${HOME}/Music"
        ;;
    2)
        read -p "Enter the full path to your music directory: " custom_path
        # Remove trailing slash if present
        NEW_BASE_PATH="${custom_path%/}"
        ;;
    3)
        if [ -n "$CURRENT_BASE_PATH" ]; then
            NEW_BASE_PATH="$CURRENT_BASE_PATH"
        else
            echo -e "${YELLOW}Invalid option. Using default path.${NC}"
            NEW_BASE_PATH="${HOME}/Music"
        fi
        ;;
    *)
        echo -e "${YELLOW}Invalid option. Using default path.${NC}"
        NEW_BASE_PATH="${HOME}/Music"
        ;;
esac

# Create the directory if it doesn't exist
if [ ! -d "$NEW_BASE_PATH" ]; then
    echo -e "${YELLOW}Creating music directory: $NEW_BASE_PATH${NC}"
    mkdir -p "$NEW_BASE_PATH"
fi

# Write the config file
echo "# N-Music Tool configuration" > "$CONFIG_FILE"
echo "# Created on $(date)" >> "$CONFIG_FILE"
echo "BASE_PATH=\"$NEW_BASE_PATH\"" >> "$CONFIG_FILE"

echo -e "${GREEN}Configuration complete!${NC}"
echo -e "Music directory set to: ${BLUE}$NEW_BASE_PATH${NC}"
echo ""
echo -e "${YELLOW}You can change this setting anytime by running setup.sh again.${NC}"