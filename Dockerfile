FROM node:18-alpine

LABEL maintainer="DevOps Academy - Pasima"

RUN apk add --no-cache pandoc \
    && npm install -g serve

WORKDIR /app
COPY . .

# Run with sh to avoid bash-only flags issues
RUN sh entrypoint.sh

EXPOSE 8080
CMD ["serve", "-l", "8080", "public"]

