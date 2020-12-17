# Bedrock Project

A project scaffold for getting up and running quickly with
a [Roots/Bedrock](https://roots.io/bedrock/) project over Docker Compose

# Requirements

* [Docker Desktop](https://www.docker.com/products/docker-desktop) (Win/OSX/Linux)
* [Composer](https://getcomposer.org/)

**NOTE**: `composer` commands can also be substituted for the official
[Composer Docker Image](https://hub.docker.com/_/composer).

All commands in this README assume that Composer is installed natively on your system

# Basic Usage

All references to `<project-name>` can be replaced with the name of your project.

1. Run `composer create-project maiorano84/bedrock-project <project-name> && cd <project-name>`
2. Replace any variables in the `.env` file with your own configuration
3. Run `docker-compose up -d`

Once complete, your Bedrock site will be available at http://localhost

# Pretty URLs

A separate configuration has been provided to enable pretty URLs through
[Traefik](https://traefik.io/)

If you would like to use custom URLs, then you will need to prepare an external Docker Network
and ensure that no other services are running on your host's Port 80 (ie: NGINX, Apache, etc.).

Preparing the Traefik network is only necessary once. Once these commands are complete, any
subsequent Bedrock projects running the Traefik configuration will automatically be served over
that network.

Once the network and the Traefik container are both up and running, you can run the project
with the following: `docker-compose -f docker-compose.traefik.yml up -d`

Once complete, your Bedrock site will be available at `http://${NGINX_SERVER_NAME}`

# Setting up Traefik

The provided Traefik configuration is set up to respond to `*.docker.localhost` and will
automatically proxy requests to the running NGINX configuration.

## Network

```
docker network create -d bridge traefik-network
docker build -t traefik-web ./docker/traefik
```

## Container

```
docker run -itd --restart unless-stopped \
    -p 80:80 -p 8080:8080 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --name=traefik --network=traefik-network traefik-web
```

Once running, you may also access the Traefik Dashboard by navigating to http://localhost:8080
