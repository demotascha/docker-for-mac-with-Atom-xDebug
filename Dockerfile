FROM php:7.1-fpm
MAINTAINER DemoHuang <demotascha@gmail.com>

# Install modules
RUN apt-get update && apt-get install -y \
  locales libgeoip-dev \
	libmcrypt-dev  \
	libicu-dev \
	libxslt-dev \
	mysql-client

RUN docker-php-ext-install -j$(nproc) pdo pdo_mysql mysqli mbstring mcrypt intl bcmath xsl opcache\
    && docker-php-ext-enable pdo pdo_mysql mysqli mbstring mcrypt intl bcmath xsl opcache

# install xdebug
# default host ip of docker-machine
RUN pecl install -o -f xdebug apcu
RUN echo "zend_extension=$(find /usr/local/lib/php/extensions/no-debug-non-zts-20160303/ -name xdebug.so)" > /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_host=10.254.254.254" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.idekey=ATOM" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.max_nesting_level=512" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.remote_log=/var/log/xdebug.log" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_enable=0" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.profiler_enable_trigger=1" >> /usr/local/etc/php/conf.d/xdebug.ini \
    && echo "xdebug.coverage_enable=0" >> /usr/local/etc/php/conf.d/xdebug.ini

RUN apt-get install -y wget git zsh
# Install Zsh
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

# install composer
COPY composer.sh /composer.sh
RUN /composer.sh

# php storm command line debug
ENV PHP_IDE_CONFIG serverName=www.demo.local.tw
ENV XDEBUG_CONFIG idekey=ATOM

RUN docker-php-ext-enable apcu

# testing env variables
ENV TESTING_DB_HOST mysql

EXPOSE 9000
CMD ["php-fpm"]
