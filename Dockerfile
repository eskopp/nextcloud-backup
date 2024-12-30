FROM alpine:3.21.0

# Install required tools
RUN apk add --no-cache \
    curl \
    zip \
    bash \
    git

# Set working directory
WORKDIR /app

# Copy the entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Define the entrypoint
ENTRYPOINT ["/entrypoint.sh"]
