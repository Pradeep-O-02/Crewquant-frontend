# Stage 1: Build the React app
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package.json and lock file first to leverage Docker cache
COPY package.json ./
COPY package-lock.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the project files
COPY . .

# Build the app for production
RUN npm run build

# Stage 2: Serve the built app with Nginx
FROM nginx:stable-alpine

# Copy the build output to Nginx's public directory
COPY --from=builder /app/build /usr/share/nginx/html

# Remove default Nginx configuration and replace with custom if needed
# COPY nginx.conf /etc/nginx/nginx.conf  # (Optional)

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
