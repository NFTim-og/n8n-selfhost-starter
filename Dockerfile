FROM n8nio/n8n:latest

# Switch to root to install system dependencies
USER root

# Install Canvas dependencies with more comprehensive packages
RUN apk update && apk add --no-cache \
    build-base \
    g++ \
    cairo-dev \
    jpeg-dev \
    pango-dev \
    musl-dev \
    giflib-dev \
    pixman-dev \
    pangomm-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    fontconfig-dev \
    python3 \
    make \
    pkgconfig \
    linux-headers

# Create directory for custom nodes/modules with proper permissions
RUN mkdir -p /home/node/.n8n/nodes && \
    chown -R node:node /home/node/.n8n

# Switch back to node user for npm operations
USER node

# Set working directory
WORKDIR /home/node

# Try to install a pre-built Canvas package first, fallback to building from source
ENV PYTHON=python3
RUN npm install canvas@2.11.2 || npm install canvas --build-from-source

# Set environment variables
ENV NODE_ENV=production
ENV FONTCONFIG_PATH=/etc/fonts