ARG PHP_VERSION=8.0

# Step 1 -- Composer
FROM php:${PHP_VERSION:-8.0}-cli-alpine AS builder

WORKDIR /app

COPY --from=composer:latest /usr/bin/composer /usr/local/bin
COPY ./code /app

RUN composer install --no-dev

# Step 2 -- PHP FPM
FROM wordpress:php${PHP_VERSION:-8.0}-fpm-alpine AS final

COPY --from=builder --chown=www-data:www-data /app /var/www/html

RUN rm -rf /var/www/html/wp-content

ENTRYPOINT ["php-fpm"]
