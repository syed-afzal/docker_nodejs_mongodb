# Docker starter with Node JS and MongoDB services

## Overview

This repository shows how to get a Node.js app running with  MongoDB inside a Docker container on a local machine/computer. You can also see your code changes on a local machine to the running container of your docker image. In addition to this, not only your code changes reflect to your container, your every **CRUD** operation to **DB** will also saved inside your local machine **DB**.

It's sound good  :ok_hand: , so let's start :runner:

## Prerequisite

For this demo to work, [Docker](http://docker.com) and [git](https://git-scm.com/) needs to be installed on your local(host) machine.

## GuideLine Steps

#### 1. Clone the repo
First we will get through the `Dockerfile` then `docker-compose file`.

#### 2. Snippet of `DockerFile`

```bash
FROM node:10

# Create app directory
WORKDIR /usr/src/app

# Bundle app source into the container
COPY . .

# If you are building your code for production
# RUN npm ci --only=production
RUN npm install

#In my case my app binds to port 3000 so you'll use the EXPOSE instruction to have it mapped by the docker daemon:

EXPOSE 3000

CMD npm run dev
```

##### 2.1 Explanation of `DockerFile`

- The first line tells Docker to use another Node image from the [DockerHub](https://hub.docker.com/). We’re using the official Docker image for Node.js and it’s version 10 image.

- The second line, sets a working directory from where the app code will live inside the Docker container.

- We are copying/bundling our code working directory into container working directory on line three.

- We run npm install for dependencies in container on line four.

- On Line 5, we setup the port that Docker will expose when the container is running. Port 3000 in our case.

 -On line 6, we tell docker to execute our app inside the container by using node to run `npm run dev. It is the command which I registered in __package.json__ in script section.

###### :clipboard: `Note: For development purpose I used __nodemon__ , If you need to deploy at production you should change CMD from __npm run dev__ to __npm start__.`

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
    depends_on:
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

The first line defines the version of a file. It sounds confusing :confused:. What is meant by version of file ?? 

:pill: The Compose file is a YAML file defining services, networks, and volumes for a Docker application. So it is only a version of describing compose.yaml file. There are several versions of the Compose file format – 1, 2, 2.x, and 3.x.

__Services__

Our main goal to create a container, it starts from here. As you can see there are two services(Docker images), one is __Node__ and other is __MongoDB__.

We define two services app and mongo:

##### 3.1.1 Service app

We make image of app from our `DockeFile`, explanation below.

__Explanation of service app__

- Defining a **nodesjs** service as __app__.
- We named our **node server** container service as **app**. Assigning a name to the containers makes it easier to read when there are lot of containers on a machine, it can aslo avoid randomly generated container names. (Although in this case, __container_name__ is also __app__, this is merely personal preference, the name of the service and container do not have to be the same.) 
- Docker container starts automatically if its fails.
- Building the __app__ image using the Dockerfile from the current directory.
- Mapping the host port to the container port.

##### 3.1.2 Service mongo

We add another service called **mongo** but this time instead of building it from `DockerFile` we write all the instruction here directly. We simply pull down the standard __mongo image__ from the [DockerHub](https://hub.docker.com/) registry as we have done it for Node image.

__Explanation of service mongo__

- Defining a **mongodb** service as __mongo__.
- Pulling the mongo 4.2.0 image image again from [DockerHub](https://hub.docker.com/).
- Mount our current db directory to container. 
- For persistent storage, we mount the host directory ( just like I did it in **Node** image inside `DockerFile` to reflect the changes) `/data` ( you need to create a directory in root of your project in order to save changes to locally as well) to the container directory `/data/db`, which was identified as a potential mount point in the `mongo Dockerfile` we saw earlier.
- Mounting volumes gives us persistent storage so when starting a new container, Docker Compose will use the volume of any previous containers and copy it to the new container, ensuring that no data is lost.
- Finally, we link/depends_on the app container to the mongo container so that the mongo service is reachable from the app service.
- In last mapping the host port to the container port.

:key: `If you wish to check your DB changes on your local machine as well. You should have installed MongoDB locally, otherwise you can't access your mongodb service of container from host machine.` 

:white_check_mark: You should check your __mongo__ version is same as used in image. You can see the version of __mongo__ image in `docker-compose `file, I used __image: mongo:4.2.0__. If your mongo db version on your machine is not same then furst you have to updated your  local __mongo__ version in order to works correctly.

#### 4. Commands to Build and Run the Docker image/containes

We can now navigate to the project directory, open up a terminal window and run :

```bash
$ sudo docker-compose up
```

It will start make the image and start the two container one is __Node__ and other is __mongo__. If image makes correctly you will see the output like :

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

To Install curl run the command :

```bash
$  sudo apt-get update
```

then

```bash
$  sudo apt-get install curl
```

After installing curl run the command:

```bash
$  curl http://localhost:3000/api
```

If everything works fine you will get the response 

`{"code":200,"success":true,"message":"Successfully completed","todos":[]}`

Right now there is no todos in DataBase.

To insert some todos in DB hit the post api of todos e.g:

```bash
$   curl -d '{"text":"Testing todo"}' -H "Content-Type: application/json" -X POST http://localhost:3000/api/todos
```

I added the text for todo is "testing todo" you can write any text you want. You can add much todos as you want. To check todo is insert in DB, call the `get` todo api again as we called earlier and this time you will see the added todo in todos array.

`{"code":200,"success":true,"message":"Successfully completed","todos":[{"_id":"5da71f426e17e00020a67539","text":"Testing todo","__v":0}]}`

That's all Folks :tada:

#### Conclusion

We have a build a simple application that persists data in MongoDB. We were able to Dockerize that application and use docker-compose to lunch both the application and MongoDB in a single command. Lastly, we used volumes to ensure the persisted data remains after the MongoDB container is destroyed.
