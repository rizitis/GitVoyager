# Use an official lightweight Linux base image
FROM alpine:latest

# Install necessary dependencies
RUN apk add --no-cache \
    bash \
    git \
    curl \
    nano \
    && rm -rf /var/cache/apk/*

# Set up working directory
WORKDIR /app

# Copy GitVoyager project files into the container
COPY . .

# Make the GitVoyager script executable
RUN chmod +x ./gitv

# Expose a volume for the configuration file and downloaded files
VOLUME [ "/config", "/downloads" ]

# Set up an environment variable for the configuration file
ENV CONFIG_FILE_PATH=/config/gitv.conf
ENV LOC_DIR=/downloads

# Entry point for the container
CMD ["./gitv"]