docker-cakephp
======================

Dockerfile for deploying your CakePHP application in a Docker container, able to connect to a remote database with database-based sessions and inject ENV vars to configure your application.

Based on Ubuntu 16.04 Xenial and PHP 7.0

Note: This project is meant to be an example to study the basics and essentials, therefore it is build on an Ubuntu base image rather then a PHP base image.

Usage
-----

You can edit the `Dockerfile` to add your own git, composer or custom commands to add your application code to the image.

To create the image `myvendor/mycakephpapp`, execute the following command on the docker-cakephp directory:

```bash
docker build -t myvendor/mycakephpapp .
```

Optional: You can now push your new image to a registry:

```bash
docker push myvendor/mycakephpapp
```

Running your CakePHP docker image
-----------------------------------

Start your image forwarding container port 80 to localhost port 80:

```bash
docker run -d -p 80:80 myvendor/mycakephpapp
```

Example: Connecting to a MySQL container
-----------------------------------
Start a [MySQL container](https://hub.docker.com/_/mysql/) 

```bash
docker run -d \
	--name mysql-server \
	-p 3306:3306 \
	-e MYSQL_ROOT_PASSWORD=sekret \
	-e MYSQL_DATABASE=cakephp \
	mysql:latest
```

Start your image and:
* Link it to the MySQL container you just started (so your container can contact it)
* Connect to a remote database server using the CakePHP DATABASE_URL env variable filled with the variables given in the command above.
* Use the `database` session handler using our the SESSION_DEFAULTS env variable (see `Dockerfile` for implementation)

```bash
docker run -d -p 80:80 \
	-e "DATABASE_URL=mysql://root:sekret@mysql-server/cakephp?encoding=utf8&timezone=UTC&cacheMetadata=true" \
	-e "SESSION_DEFAULTS=database" \
	--link mysql-server:mysql \
	myvendor/mycakephpapp
```


Test your deployment
--------------------------

Visit `http://localhost/` in your browser or 

	curl http://localhost/

You can now start using your CakePHP container!

Things to look out for
-----------------------------------
* Think about handling session when running multiple containers behind a loadbalancer. You could modify the `Dockerfile` to `sed` the `config/app.php` file to use the database or cache session handler as implemented in the example.
* If you want to store any files (e.g. uploads), please remember containers are 'stateless' and the data will be gone when you delete them.
