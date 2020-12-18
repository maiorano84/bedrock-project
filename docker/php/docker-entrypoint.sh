#!/bin/sh

# Fixes an uploads permissions issue on Windows
chown www-data:www-data -R /var/www/html

exec "$@"
