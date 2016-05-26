FROM tutum/lamp:latest
MAINTAINER Stefan van Gastel <stefanvangastel@gmail.com>

#Install packages
RUN apt-get update && apt-get install -y \
  php5-intl \
  wget \
  git

#Get composer
RUN wget -O /usr/bin/composer https://getcomposer.org/composer.phar && chmod +x /usr/bin/composer

# Download latest version of CakePHP into /app
# You can replace these steps with custom steps
RUN rm -fr /app && composer create-project --prefer-dist cakephp/app /app

# Configure CakePHP to connect to local DB
ADD app.php /app/config/app.php

# Add database setup script
ADD create_mysql_admin_user.sh /create_mysql_admin_user.sh
RUN chmod 755 /*.sh

#Expose ports to the host
EXPOSE 80 3306
CMD ["/run.sh"]
