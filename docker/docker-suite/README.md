
This folder represents a few different ways to use docker including:
- [docker-compose](#docker-compose)
- [docker swarm](#Swarm)
- [docker-machine](#Machine)


# docker-compose

### **Install a service with docker-compose**
cd to the `/php-apache-sql` folder and run

```shell script
docker-compose up
```

Which will build 3 images to the specifications in the 
`/apache` and `/php` Dockerfiles and the docker-compose.yml file

```shell script
--- Some output ommitted ---
php       | [07-Jul-2020 18:06:30] NOTICE: fpm is running, pid 1
php       | [07-Jul-2020 18:06:30] NOTICE: ready to handle connections
mysql     | 2020-07-07T18:06:32.127135Z 0 [System] [MY-011323] [Server] X Plugin ready for connections. Socket: '/var/run/mysqld/mysqlx.sock' bind-address: '::' port: 33060
apache    | [Tue Jul 07 18:06:32.134571 2020] [mpm_event:notice] [pid 1:tid 140302753025352] AH00489: Apache/2.4.43 (Unix) configured -- resuming normal operations
apache    | [Tue Jul 07 18:06:32.134631 2020] [core:notice] [pid 1:tid 140302753025352] AH00094: Command line: 'httpd -D FOREGROUND'
mysql     | 2020-07-07T18:06:32.168533Z 0 [Warning] [MY-010068] [Server] CA certificate ca.pem is self signed.
mysql     | 2020-07-07T18:06:32.171182Z 0 [Warning] [MY-011810] [Server] Insecure configuration for --pid-file: Location '/var/run/mysqld' in the path is accessible to all OS users. Consider choosing a different directory.
mysql     | 2020-07-07T18:06:32.197188Z 0 [System] [MY-010931] [Server] /usr/sbin/mysqld: ready for connections. Version: '8.0.20'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server - GPL.
```

now try to curl localhost
```shell script
$ curl localhost
<h1>Hello World!</h1>
<h3>Attempting MySQL connection from php...</h3>
Connected to MySQL successfully!
```

If you run into issues check and ensure the images were properly created:
```
docker image ls
```
which should return something like

```shell script
REPOSITORY              TAG                 IMAGE ID            CREATED             SIZE
php-apache-sql_apache   latest              72123c019cbe        About an hour ago   59.2MB
php-apache-sql_php      latest              316c531e75bf        About an hour ago   85.6MB
httpd                   alpine              e7e8868c7697        22 hours ago        56.1MB
php                     fpm-alpine          78e945602ecc        3 weeks ago         81.4MB
mysql                   latest              be0dbf01a0f3        4 weeks ago         541MB
```

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

Examples and images were referenced from:  
https://docs.docker.com/engine/reference/builder/   
https://hub.docker.com/_/php  
https://takacsmark.com/docker-swarm-tutorial-for-beginners/#your-first-swarm-cluster
https://docs.docker.com/machine/install-machine/
https://www.virtualbox.org/wiki/Downloads