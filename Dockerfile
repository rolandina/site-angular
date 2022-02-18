# ### STAGE 1: Build ###
# FROM node:16.13.2-alpine AS build
# WORKDIR /usr/src/app
# COPY package.json package-lock.json ./
# RUN npm install 
# COPY . .
# RUN npm run build

# ### STAGE 2: Run ###
# FROM nginx:1.20-alpine
# COPY nginx.conf /etc/nginx/nginx.conf
# COPY --from=build /usr/src/app/dist/my-app /usr/share/nginx/html


# Stage 1: Compile and Build angular codebase

# Use official node image as the base image
FROM node:17.5-alpine as build

# Set the working directory
WORKDIR /usr/src/app



# Install all the dependencies
COPY package.json package-lock.json ./

RUN npm install


# Add the source code to app
COPY . .


# Generate the build of the application
RUN npm run build --prod


# Stage 2: Serve app with nginx server

# Use official nginx image as the base image
FROM nginx:alpine


## Remove default nginx index page
RUN rm -rf /usr/share/nginx/html/*

# Copy the build output to replace the default nginx contents.
COPY --from=build /usr/src/app/dist/my-app /usr/share/nginx/html

# Expose port 80
EXPOSE 80