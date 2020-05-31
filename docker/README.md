
This folder represents a few different ways to use docker including:
- [Dockerfile](#Dockerfile)
- [docker swarm](#Swarm)
- [docker-machine](#Machine)


# Dockerfile

### **Install a service with Dockerfile**
cd to the `/php` folder

Start with
```shell script
docker build -t php:myapp .
```
Which will build an image to the specifications in the Dockerfile
```shell script
FROM php:7.4-cli
COPY . /usr/src/myapp
WORKDIR /usr/src/myapp
CMD [ "php", "./hello-world.php" ]
```
To ensure the image was properly created run
 
```
docker image ls
```
which should return something like

```shell script
REPOSITORY                 TAG                 IMAGE ID            CREATED             SIZE
php                        7.4-cli             f6c37cd548d0        6 days ago          405MB
```
After which running

```shell script
docker run -it --rm <IMAGE-ID>
```

should show you the php code in hello-world.php
```shell script
<html>
 <head>
  <title>PHP Test</title>
 </head>
 <body>
 <p>Hello World</p> 
 </body>
</html>
```

The container should exit on its own, but running
```shell script
docker container kill <CONTAINER-ID> 
```
can remove stale running containers as well.

# Swarm
### **Creating a web cluster using docker swarm**  

download node packages
```shell script
docker run --rm -v $(pwd):/home/node -w /home/node node:11.1.0-alpine npm init -y
docker run --rm -v $(pwd):/home/node -w /home/node node:11.1.0-alpine npm i -S express
```

initialize the swarm
```shell script
docker swarm init
```

Create a docker-compose.yml file
```shell script
version: '3'

services:
  web:
    build: .
    image: takacsmark/swarm-example:1.0
    ports:
      - 80:3000
    networks:
      - mynet

networks:
  mynet:
```

build the image
```shell script
docker-compose build
```

Then deploy the stack using swarm
```shell script
docker stack deploy nodejs -c docker-compose.yml
```

confirm the stack properly deployed
```shell script
curl localhost
```

should return
```shell script
Hello from Swarm <os.hostname>
```

Now scale this service
```shell script
docker service scale nodejs_web=4
```

Confirm by running
```shell script
curl localhost
```

multiple times that the value for `<os.hostname>` changes and 
```shell script
docker service ls
```

returns 4 replicas
```shell script
ID                  NAME                MODE                REPLICAS            IMAGE                          PORTS
ysoyp3sai6i7        node_web            replicated          4/4                 takacsmark/swarm-example:1.0   *:80->3000/tcp
```

Remove stack and leave swarm
```shell script
docker stack rm nodejs 
docker swarm leave --force
```

# Machine

### **mulit-host cluster**
Install docker-machine 
```shell script
https://docs.docker.com/machine/install-machine/
```

Install virtualbox
```shell script
https://www.virtualbox.org/wiki/Downloads
```

Create a few machines
```shell script
docker-machine create --driver virtualbox vm1
docker-machine create --driver virtualbox vm2
```

ssh into the newly created vm and start a swarm 
```shell script
docker-machine ssh vm1
  ( '>')
  /) TC (\   Core is distributed with ABSOLUTELY NO WARRANTY.
 (/-_--_-\)           www.tinycorelinux.net

docker@vm1:~$ docker swarm init --advertise-addr eth1
Swarm initialized: current node (esd4gmsnuojpn5sdiv87plo7p) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-2w40j0j037qhblqyltt92qhhc42dyaqdwnkdfvnkqsq50p4qaq-ea69pzudct47t96hddyn8tye8 192.168.99.100:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

docker@vm1:~$ exit                                                                                                                                                                                         
logout

docker swarm init --advertise-addr eth1
```

Then join the swarm on vm2 using the join command produced above 
```docker swarm join --token SWMTKN-1-2w40j0j037qhblqyltt92qhhc42dyaqdwnkdfvnkqsq50p4qaq-ea69pzudct47t96hddyn8tye8 192.168.99.100:2377```

```shell script
docker-machine ssh vm2
   ( '>')
  /) TC (\   Core is distributed with ABSOLUTELY NO WARRANTY.
 (/-_--_-\)           www.tinycorelinux.net

docker@vm2:~$     docker swarm join --token SWMTKN-1-2w40j0j037qhblqyltt92qhhc42dyaqdwnkdfvnkqsq50p4qaq-ea69pzudct47t96hddyn8tye8 192.168.99.100:2377
This node joined a swarm as a worker.
docker@vm2:~$  
```

push the docker image into Docker Hub public repo
```shell script
docker-compose push
```

To get the Compose file on our host machine onto the docker-machine VMs
```shell script
docker-machine env vm1
```

Now deploy the stack as usual
```shell script
docker stack deploy node -c docker-compose.yml
```
And go to the IP address (leave off the tcp header and port)
```shell script
NAME   ACTIVE   DRIVER       STATE     URL                         SWARM   DOCKER     ERRORS
vm1    *        virtualbox   Running   tcp://192.168.99.100:2376           v19.03.5   
vm2    -        virtualbox   Running   tcp://192.168.99.101:2376           v19.03.5   
```

# References

Examples were referenced from:  
https://docs.docker.com/engine/reference/builder/   
https://hub.docker.com/_/php  
https://takacsmark.com/docker-swarm-tutorial-for-beginners/#your-first-swarm-cluster
https://docs.docker.com/machine/install-machine/
https://www.virtualbox.org/wiki/Downloads