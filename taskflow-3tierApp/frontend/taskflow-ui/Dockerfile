# Build stage
FROM node:18-alpine AS build

WORKDIR /app

# Copy package files
COPY  package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Build frontend
RUN npm run build

# Production stage using Nginx
FROM nginx:alpine

# Copy build output to Nginx
COPY --from=build /app/dist /usr/share/nginx/html

# Expose frontend port
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]