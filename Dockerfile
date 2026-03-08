# INTENTIONALLY VULNERABLE DOCKERFILE - FOR SECURITY SCANNER TESTING ONLY
# Uses old base image with known CVEs to trigger Trivy container scanning.

FROM node:14-alpine

# OCI Labels for Code-to-Runtime mapping (Method 2)
# These are overridden at build time with dynamic values via --label flags
LABEL org.opencontainers.image.source="https://github.com/zava-corporation/shift-left-demo"
LABEL org.opencontainers.image.description="Shift-left security demo - intentionally vulnerable"
LABEL org.opencontainers.image.vendor="Zava Corporation"
LABEL org.opencontainers.image.licenses="MIT"

# Run as root (security issue)
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 3000

ENV NODE_ENV=development
ENV PORT=3000

CMD ["node", "src/app.js"]
