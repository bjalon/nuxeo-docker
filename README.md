# Dockerfile for a standalone Nuxeo

This Dockerfile installs a Nuxeo 7.3 version without third parts, a PostgreSQL or a reverse proxy.

Useful for test. I plan to add PostgreSQL configuration (see element in comment).

## Start the container 

docker run -p 8080:8080 bjalon/nuxeo 

## Add your own Marketplace package 

* Create a directory
* Copy your own marketplace package
* Go in this directory

* Create a Dockerfile with the following content

	FROM bjalon/nuxeo
	
	ADD \*.zip $NUXEO\_MP\_THIRD\_DIR
	RUN ["/bin/bash", "-c", "$NUXEO\_HOME\_DIR/bin/nuxeoctl mp-install $NUXEO\_MP\_THIRD\_DIR/\*"]

Then execute

* docker build ./
* docker image
* docker run -p 8080:8080 idOfTheLastImageCreated

You should have access to your Nuxeo instance after a while.
