docker-cakephp
======================

Out-of-the-box CakePHP docker image


Usage
-----

You can edit the Dockerfile to add your own Github URL

To create the image `stefanvangastel/cakephp`, execute the following command on the docker-cakephp folder:

	docker build -t stefanvangastel/cakephp .

You can now push your new image to the registry:

	docker push stefanvangastel/cakephp


Running your CakePHP docker image
-----------------------------------

Start your image:

	docker run -d -p 80:80 -e "SECURITY_SALT=<shake_your_salt_here>" stefanvangastel/cakephp

Test your deployment:

	curl http://localhost/

You can now start using your CakePHP container!