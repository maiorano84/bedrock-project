# Bedrock Project

A local project scaffold for getting up and running quickly with
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
with the following: `docker-compose -f traefik.yml up -d`

Once complete, your Bedrock site will be available at `http://${NGINX_SERVER_NAME}`

# Setting up Traefik

The provided commands will get you quickly set up with a simple base installation that should cover most of your needs.
For additional options, see the [Static Configuration Documentation](https://doc.traefik.io/traefik/reference/static-configuration/cli/)

## Network

```
docker network create -d bridge traefik-network
```

## Container

```
docker run -d -p 80:80 -p 443:443 -p 8080:8080 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --name=traefik \
    --restart unless-stopped \
    --network=traefik-network \
    -l traefik.enable=false \
    traefik:2.4 \
    --api.insecure=true \
    --entrypoints.web.address=:80 \
    --entrypoints.websecure.address=:443
```

Once running, you may also access the Traefik Dashboard by navigating to http://localhost:8080

# CLI Tools

Some command line tools are available as Compose services to make life a little easier:

* `composer` - [Composer](https://getcomposer.org/)
* `wp` - [WP CLI](https://wp-cli.org/)
* `wordmove` - [Wordmove](https://github.com/welaika/wordmove)

To run a CLI command as a service, simply run the following:

`docker-compose -f cli.yml run --rm <service>...`
