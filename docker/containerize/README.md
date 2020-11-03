# Containerize

This folder contains of example of
using docker-compose to containerize
a flask application behind an
nginx network configuration.

## How to Run

* run `docker-compose up` in the `./containerize` folder. Since the nginx image uses port 80 & 443 you may need to clear processes holding those ports first.

* Once the containers are running type
`curl -k https://localhost`

* run `drwetter/testssl.sh` for a security configuration test/overview

``` shell
docker run -ti --rm --network="host" drwetter/testssl.sh \
--parallel --quiet --std --protocols --headers https://localhost
```

## Hot Reload

hot reloads are enabled through the `volumes` directive on
`containerize_app_1` in the compose file. simply open the file `/app/src/server.py` and make changes to the index() method such as

 ``` python
 content = "It's easier to ask forgiveness than it is to get permission."
 ```

to

``` python
 content = "It's *faster* to ask forgiveness than it is to get permission."
 ```

and re-run

 ``` shell
 curl -k https://localhost
 ```

## Notes

* I've used the `python:3.8-slim-buster` image instead of alpine since I've seen issues
with it in past usage with python.
slim buster still carries similar size advantages however.

* Some research also indicated these issues stem from differences between the glibc libraries and musl libraries alpine uses.
