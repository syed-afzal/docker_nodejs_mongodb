FROM node:10

#Argument that is passed from docer-compose.yaml file
ARG NODE_PORT

#Echo the argument to check passed argument loaded here correctly
RUN echo "Argument port is : $NODE_PORT"

# Create app directory
WORKDIR /usr/src/app

# Bundle app source
#COPY . .
COPY . .

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
RUN npm install


#In my case my app binds to port 3000 so you'll use the EXPOSE instruction to have it mapped by the docker daemon:

EXPOSE ${NODE_PORT}

CMD npm run dev


