FROM node:18-alpine

LABEL maintainer="DevOps Academy - Pasima"

# Install serve and markdown-html
RUN npm install -g serve markdown-html

# Create working directories
WORKDIR /app
COPY . .

# Make entrypoint executable
RUN chmod +x entrypoint.sh

# Build blog on image build
RUN ./entrypoint.sh

# Expose the port
EXPOSE 8080

# Serve the /public folder when container starts
CMD ["serve", "-l", "8080", "public"]
