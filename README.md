# Docker starter with Node JS and MongoDB services

## Overview

This repository shows how to get a Node.js app running with  MongoDB inside a Docker container on a local machine/computer. You can also see your code changes on local machine to the running container of your docker image. In addition any addition to DB would also reflect to your local machine DB. 

It's sound good  :ok_hand: , so let's start :runner:

For this demo to work, [Docker](http://docker.com) and [Node.js](http://nodejs.org) need to be installed.

## GuideLine Steps

#### 1. Clone the repo
First we will get through the `Dockerfile` then `docker-compose file`.

#### 2. Snippet of `DockerFile`

```bash
FROM node:10

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install

# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY . .

#In my case my app binds to port 3000 so you'll use the EXPOSE instruction to have it mapped by the docker daemon:

EXPOSE 3000

CMD npm run dev
```

##### 2.1 Explanation of `DockerFile`

The first line tells Docker to use another Docker (Node) image.

We’re using is the official Docker image for Node.js and it’s version 10 image.

The second line, sets a working directory from where the app code will live inside the Docker container.

We are copying the package.json file on third line.

We run npm install for dependencies in container on line four.

We are copying/bundling our code working directory into container working directory on line five.

On Line 6, we setup the port that Docker will expose when the container is running. Port 3000 in our case.

On line 7, we tell docker to execute our app inside the container by using node to run `npm run dev. It is the command which I registered in __package.json__ in script section.

###### `Note: For development purpose I used __nodemon__ , If you need to deploy at production you should change CMD from __npm run dev__ to __npm start__.`

Now lets understand the `docker-compose` file

#### 3. Snippet of `docker-compose`

```bash
version: "2"
services:
  app:
    container_name: app
    restart: always
    build: .
    ports:
      - "3000:3000"
    volumes:
      - .:/usr/src/app
    links:
      - mongo
  mongo:
    container_name: mongo
    image: mongo:4.2.0
    volumes:
      - ./data:/data/db
    ports:
      - "27017:27017"
```


##### 3.1 Explanation of `docker-compose`

__Version__

The first line defines version of a file. Didn't get no problem, continue reading. We will understand in the next para.

The Compose file is a YAML file defining services, networks, and volumes for a Docker application. So it is only a version of describing compose.yaml file. There are several versions of the Compose file format – 1, 2, 2.x, and 3.x.

__Services__

Our main work to create a container starts from here. As you see there are two services(Docker images), one is __Node__ and other images is __MongoDB__.

We define two services app and mongo:

##### 3.1.1 Service app

We make image of app from our `DockeFile`, explanation below.

__Explanation of service app__

- Defining a service called __app__.
- Adding a container name for the app service as giving the container a memorable name makes it easier to work with and we can avoid randomly generated container names (Although in this case, __container_name__ is also __app__, this is merely personal preference, the name of the service and container do not have to be the same.) Too make this works you need to create a directory `/data` in your root folder of application in host machine.
- Docker container starts automatically if its fails.
- Building the __app__ image using the Dockerfile in the current directory and
- Mapping the host port to the container port.

##### 3.1.2 Service mongo

We add another service called **mongo** but this time instead of building it from `DockerFile` we write all the instruction here directly. We simply pull down the standard __mongo image__ from the Docker Hub registry as we have done it for Node image.

__Explanation of service mongo__

- For persistent storage, we mount the host directory ( as it is I have done in `DockerFile` to reflect the changes) `/data` (this is where the dummy data I added when I was running the app locally lives) to the container directory `/data/db`, which was identified as a potential mount point in the `mongo Dockerfile` we saw earlier.
- Mounting volumes gives us persistent storage so when starting a new container, Docker Compose will use the volume of any previous containers and copy it to the new container, ensuring that no data is lost.
- Finally, we link the app container to the mongo container so that the mongo service is reachable from the app service.
- In last mapping the host port to the container port.

:key: `One important :key: too note otherwise you can't access your mongodb service of container from host machine.` 

:bulb: You should check your __mongo__ version is same as used in image. You can see the version of __mongo__ image in `docker-compose `file, I used __image: mongo:4.2.0__. If your mongo db version on your machine is not same then furst you have to updated your  local __mongo__ version in order to works correctly.

#### 4. Commands to Build and Run the Docker image/containes

##### Explanation of `docker-compose`

We can now navigate to the project directory, open up a terminal window and run 

```bash
$ docker-compose up
```

It will start make the image and start the two container one is __Node__ and other is __mongo__. If image makes correctly you will see the output like:

```
app      | > docker_node_mongo_starter@1.0.0 dev /usr/src/app
app      | > nodemon server/server.js
app      | 
app      | [nodemon] 1.19.4
app      | [nodemon] to restart at any time, enter `rs`
app      | [nodemon] watching dir(s): *.*
app      | [nodemon] watching extensions: js,mjs,json
app      | [nodemon] starting `node server/server.js`
app      | { PORT: 3000, MONGODB_URI: 'mongodb://mongo:27017/TodoApp' }
app      | Server is up on port 3000
mongo    | 2019-10-17T11:22:06.621+0000 I  NETWORK  [listener] connection accepted from 172.18.0.3:57620 #1 (1 connection now open)
mongo    | 2019-10-17T11:22:06.630+0000 I  NETWORK  [conn1] received client metadata from 172.18.0.3:57620 conn1: { driver: { name: "nodejs", version: "3.1.1" }, os: { type: "Linux", name: "linux", architecture: "x64", version: "4.15.0-65-generic" }, platform: "Node.js v10.16.3, LE, mongodb-core: 3.1.0" }
app      | 2019-10-17 11:22:06 INFO  MongoDB connected on mongodb://mongo:27017/TodoApp
```

Now to check an api of todos you hit the api using __curl__. Curl is need to be installed on your machine. Otherwise you should use postman for hitting an api.

```bash
$  curl http://localhost:3000/api
```

If everything works fine you will get the response 

`{"code":200,"success":true,"message":"Successfully completed","data":[]}`

As you can see the data is an empty array, because innitial there is no todos in DataBase.

To insert some todos in DB hit the post api of todos e.g:

```bash
$   curl -d '{"text":"Testing todo"}' -H "Content-Type: application/json" -X POST http://localhost:3000/api/todos
```

Here I added the text todo of testing todo you can write any text you want. You can add much todos as you want. To check todo is insert to DB, call the `get` todo api again as we called earlier and this time you will see the added todo in data array.

`{"code":200,"success":true,"message":"Successfully completed","data":[{"_id":"5da71f426e17e00020a67539","text":"Testing todo","__v":0}]}`

That's all Folks :tada:

#### Conclusion

We have a build a simple application that persists data in MongoDB. We were able to Dockerize that application and use docker-compose to lunch both the application and MongoDB in a single command. Lastly, we used volumes to ensure the persisted data remains after the MongoDB container is destroyed. We can close both dockers with