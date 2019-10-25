# Create image based on the official Node image from dockerhub
FROM node:10

# Create app directory
WORKDIR /usr/src/app

# Copy dependency definitions
COPY package.json /usr/src/app

# Install dependecies
RUN npm install

# Get all the code needed to run the app
COPY . /usr/src/app

# Expose the port the app runs in
EXPOSE 5000

# Serve the app
CMD ["npm", "start"]