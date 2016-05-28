docker-cakephp
======================

Out-of-the-box CakePHP 3 docker image for deploying your CakePHP application able to connect to a remote database (MySQL) server.


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
	
Start your image forwarding container port 80 to localhost port 80 and:
* Connect to a remote database server using the CakePHP DATABASE_URL env variable
* Use the `database` session handler (see `Dockerfile` for implementation)

	```
	docker run -d -p 80:80 \
		-e "DATABASE_URL=mysql://my_user:sekret@example.com/my_app?encoding=utf8&timezone=UTC&cacheMetadata=true" \
		-e "SESSION_DEFAULTS=database" \
		myvendor/mycakephpapp
	```

Test your deployment:

	curl http://localhost/

You can now start using your CakePHP container!

Things to look out for
-----------------------------------
* Think about handling session when running multiple containers behind a loadbalancer. You could modify the `Dockerfile` to `sed` the `config/app.php` file to use the database or cache session handler as implemented in the example.
* If you want to store any files (e.g. uploads), please remember containers are 'stateless' and the data will be gone when you delete them.
