FROM tutum/lamp:latest
MAINTAINER Stefan van Gastel <stefanvangastel@gmail.com>

#Get composer
RUN wget -O /usr/bin/composer https://getcomposer.org/composer.phar && chmod +x /usr/bin/composer

# Download latest version of CakePHP into /app
RUN rm -fr /app && php composer.phar create-project --prefer-dist cakephp/app /app

# Configure CakePHP to connect to local DB
ADD app.php /config/app.php

# Add database setup script
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
RUN chmod 755 /*.sh

EXPOSE 80 3306
CMD ["/run.sh"]
