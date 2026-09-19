FROM php:8.3-fpm

ARG UID=1000
ARG GID=1000

ENV COMPOSER_HOME=/var/www/.composer

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        curl \
        git \
        unzip \
        zip \
        nano \
        libzip-dev \
    && docker-php-ext-install \
        zip \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

RUN groupadd -g ${GID} app \
    && useradd -m -u ${UID} -g ${GID} -s /bin/bash app \
    && mkdir -p /var/www/html /var/www/html/vendor /var/www/.composer \
    && chown -R app:app /var/www/html /var/www/.composer \
    && chmod -R 775 /var/www/html /var/www/.composer \
    && chmod 1777 /tmp

COPY php.ini /usr/local/etc/php/conf.d/99-app.ini

WORKDIR /var/www/html

USER app

CMD ["php-fpm"]
