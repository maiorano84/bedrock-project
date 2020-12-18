ARG PHP_VERSION=7.4

FROM wordpress:php${PHP_VERSION:-7.4}-fpm-alpine
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["php-fpm"]
