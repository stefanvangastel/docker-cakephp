FROM ubuntu:xenial
MAINTAINER Stefan van Gastel <stefanvangastel@gmail.com>

# Install packages (PHP 7)
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install \
	supervisor \
	git-core \
	wget \
	apache2 \
	libapache2-mod-php \
	php-mcrypt \
	php-intl \
	php-mbstring \
	php-zip \
	php-mysql

# Delete all the apt list files since they're big and get stale quickly
RUN rm -rf /var/lib/apt/lists/*

# Listen to localhost servername
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Add image configuration and scripts
ADD start-apache2.sh /start-apache2.sh

# Make sure scripts are excutable
RUN chmod 755 /*.sh

# Add supervisor config for webserver
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf

# Add apache config to enable .htaccess and do some stuff you want
ADD apache_default /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# Link docroot to /app
RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html

####################################################
# Replace with application specific actions below  #
####################################################

# Example, deploy a default CakePHP 3 installation

# Clean the /app dir
RUN rm -rf /app

# Get composer
RUN wget -O /usr/local/bin/composer https://getcomposer.org/composer.phar && chmod +x /usr/local/bin/composer

# Clone your application (cloning CakePHP 3 / app instead of composer create project for example)
#RUN php ./composer.phar create-project --prefer-dist cakephp/app /app
RUN git clone https://github.com/cakephp/app.git /app

# Composer install application
RUN cd /app && composer -n install

# Copy the app.php file
RUN cp /app/config/app.default.php /app/config/app.php

# Make sessionhandler based on env file
RUN sed -i -e "s/'php',/env('SESSION_DEFAULTS', 'php'),/" /app/config/app.php 

# Set permissions for webserver
RUN chgrp -R www-data /app/logs /app/tmp && chmod -R g+rw /app/logs /app/tmp 

####################################################
#       End of app specific settings               #
####################################################

#Expose ports
EXPOSE 80
CMD ["supervisord", "-n"]
