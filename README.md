docker-cakephp
======================

Dockerfile for deploying a CakePHP application in a Docker container, able to connect to a remote database with database-based sessions.

Usage
-----

You can edit the `Dockerfile` to add your own git, composer or custom commands to add your application code to the image.

To create the image `myvendor/mycakephpapp`, execute the following command on the docker-cakephp directory:

	docker build -t myvendor/mycakephpapp .

Optional: You can now push your new image to the / a registry:

	docker push myvendor/mycakephpapp


Running your CakePHP docker image
-----------------------------------

Start your image forwarding container port 80 to localhost port 80:

	docker run -d -p 80:80 myvendor/mycakephpapp

Example: Connecting to a MySQL container
-----------------------------------
Start a [MySQL container](https://hub.docker.com/_/mysql/) 

	```
	docker run -d \
		--name mysql-server \
		-p 3306:3306 \
		-e MYSQL_ROOT_PASSWORD=pwd \
		-e MYSQL_DATABASE=cakephp \
		mysql:latest
	```

Start your image and:
* Link it to the MySQL container you just started (so your container can contact it)
* Connect to a remote database server using the CakePHP DATABASE_URL env variable filled with the variables given in the command above.
* Use the `database` session handler using our the SESSION_DEFAULTS env variable (see `Dockerfile` for implementation)

	```
	docker run -d -p 80:80 \
		-e "DATABASE_URL=mysql://root:pwd@mysql-server/cakephp?encoding=utf8&timezone=UTC&cacheMetadata=true" \
		-e "SESSION_DEFAULTS=database" \
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
