FROM node:10

#Argument that is passed from docer-compose.yaml file
ARG NODE_PORT

#Echo the argument to check passed argument loaded here correctly
RUN echo "Argument port is : $NODE_PORT"

# Create app directory
WORKDIR /usr/src/app

#COPY . .
COPY package.json /usr/src/app/package.json
#COPY package-lock.json /usr/src/app/package-lock.json

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
RUN npm install

COPY . /usr/src/app
#In my case my app binds to port NODE_PORT so you'll use the EXPOSE instruction to have it mapped by the docker daemon:

EXPOSE ${NODE_PORT}

CMD npm run dev


