FROM ubuntu:trusty
MAINTAINER Stefan van Gastel <stefanvangastel@gmail.com>

# Install packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y install \
	supervisor \
	git \
	wget \
	apache2 \
	libapache2-mod-php5 \
	php-apc \
	php5-mcrypt \
	php5-intl \
	php5-mysql

# Listen to localhost servername
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Add image configuration and scripts
ADD start-apache2.sh /start-apache2.sh

# Make sure scripts are excutable
RUN chmod 755 /*.sh

# Add supervisor config for webserver
ADD supervisord-apache2.conf /etc/supervisor/conf.d/supervisord-apache2.conf

# config to enable .htaccess
ADD apache_default /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

####################################################
# Replace with application specific actions below  #
####################################################

#Example, deploy a default CakePHP 3 installation

#Get composer
RUN wget https://getcomposer.org/composer.phar && chmod +x composer.phar

# Download latest version of CakePHP into /app
RUN rm -fr /app && php ./composer.phar create-project --prefer-dist cakephp/app /app

####################################################
# 	End of app specific settings               #
####################################################

# Link docroot to /app
RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html

#Expose ports
EXPOSE 80
CMD ["supervisord", "-n"]
