# Create image based on the official Node image from dockerhub
FROM node:lts-buster-slim

#Argument that is passed from docer-compose.yaml file
ARG FRONT_END_PORT

#Echo the argument to check passed argument loaded here correctly
RUN echo "Argument port is : $FRONT_END_PORT"

# Create app directory
WORKDIR /usr/src/app

# Copy dependency definitions
COPY package.json /usr/src/app
COPY package-lock.json /usr/src/app

# Install dependecies
#RUN npm set progress=false \
#    && npm config set depth 0 \
#    && npm i install
RUN npm ci

# Get all the code needed to run the app
COPY . /usr/src/app

# Expose the port the app runs in
EXPOSE ${FRONT_END_PORT}

# Serve the app
CMD ["npm", "start"]
