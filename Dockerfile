FROM node:10

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

EXPOSE 3000

CMD npm run dev


