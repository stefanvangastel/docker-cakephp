FROM ubuntu:xenial
MAINTAINER Stefan van Gastel <stefanvangastel@gmail.com>

# Install packages and PHP 7
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -q && apt-get install -qqy \
	git-core \
	composer \ 
	#Installing mod-php installs both recommended PHP 7 and Apache2
	libapache2-mod-php \
	php-mcrypt \
	php-intl \
	php-mbstring \
	php-zip \
	php-xml \
	php-codesniffer \
	php-mysql && \
	# Delete all the apt list files since they're big and get stale quickly
	rm -rf /var/lib/apt/lists/*

# Add apache config to enable .htaccess and do some stuff you want
COPY apache_default /etc/apache2/sites-available/000-default.conf

# Enable mod rewrite and listen to localhost
RUN a2enmod rewrite && \
	echo "ServerName localhost" >> /etc/apache2/apache2.conf

################################################################
# Example, deploy a default CakePHP 3 installation from source #
################################################################

# Clone your application (cloning CakePHP 3 / app instead of composer create project to demonstrate application deployment example)
RUN rm -rf /var/www/html && \
	git clone https://github.com/cakephp/app.git /var/www/html

# Set workdir (no more cd from now)
WORKDIR /var/www/html

# Composer install application
RUN composer -n install

# Copy the app.php file
RUN cp config/app.default.php config/app.php && \
	# Inject some non random salt for this example 
	sed -i -e "s/__SALT__/somerandomsalt/" config/app.php && \
	# Make sessionhandler configurable via environment
	sed -i -e "s/'php',/env('SESSION_DEFAULTS', 'php'),/" config/app.php  && \
	# Set write permissions for webserver
	chgrp -R www-data logs tmp && \
	chmod -R g+rw logs tmp 

####################################################
# Expose port and run Apache webserver             #
####################################################

EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
