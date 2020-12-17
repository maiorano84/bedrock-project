FROM ruby:2.7-alpine

ENV PAGER=more

COPY docker-entrypoint.sh /docker-entrypoint.sh

RUN apk add --update curl mysql-client gzip rsync openssh \
    php7 php7-mysqli php7-iconv php7-ctype php7-json php7-phar && \
    curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /usr/local/bin/wp && \
    chmod +x /usr/local/bin/wp && \
    gem install wordmove && \
    adduser -S wordmove && \    
    chmod +x /docker-entrypoint.sh

USER wordmove

WORKDIR /var/www/html

ENTRYPOINT ["/docker-entrypoint.sh"]
