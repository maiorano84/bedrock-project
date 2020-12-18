ARG PHP_VERSION=7.4

FROM php:${PHP_VERSION}-cli-alpine
ENV PAGER=more

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN apk add --update ruby ruby-etc ruby-bigdecimal ruby-json ruby-io-console curl mysql-client gzip rsync openssh && \
    curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp && \
    gem install wordmove && \
    chmod +x /docker-entrypoint.sh

WORKDIR /var/www/html

ENTRYPOINT ["/docker-entrypoint.sh"]
