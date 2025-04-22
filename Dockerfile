FROM python:3.10-slim

# Set working directory
WORKDIR /app

# Set default environment variable for BASE_PATH
ENV BASE_PATH="/music"

# Install system dependencies
RUN apt-get update && apt-get install -y \
    bash \
    curl \
    ffmpeg \
    git \
    nano \
    findutils \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir --break-system-packages \
    spotdl \
    eyeD3

# Copy script and make executable
COPY n-music.sh setup.sh /app/
RUN chmod +x /app/n-music.sh /app/setup.sh

# Create config directory
RUN mkdir -p /root/.config/n-music

# Create Docker entrypoint script
RUN echo '#!/bin/bash\n\
# Set BASE_PATH from environment variable\n\
echo "BASE_PATH=\"$BASE_PATH\"" > /root/.config/n-music/config\n\
\n\
# Create the music directory if it does not exist\n\
mkdir -p "$BASE_PATH"\n\
\n\
# Run the N-Music script\n\
exec /app/n-music.sh "$@"\n\
' > /app/docker-entrypoint.sh && chmod +x /app/docker-entrypoint.sh

# Create volume for music storage
VOLUME /music

# Set entry point to the entrypoint script
ENTRYPOINT ["/app/docker-entrypoint.sh"]