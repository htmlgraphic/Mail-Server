## Mail Server Docker (HONEY POT)

A secure, minimal-configuration mail server which will accept any email it receives.

This repository is tailored to help with email development and testing, no email will be sent out from this container build.

 - **dovecot**:  The SMTP and IMAP server. This container uses postfix as MTA and dovecot as IMAP server.
	All incoming mail is accepted via authentication (via username and password) clients can send messages via STARTTLS on port 587.

 - **mailbase**: This image is just an implementation detail. It is a workaround to allow sharing of configuration files between multiple docker images and redeploys. 

---

[![](https://badge.imagelayers.io/htmlgraphic/imap-server:latest.svg)](https://imagelayers.io/?images=htmlgraphic%2Fimap-server:latest 'Get your own badge on imagelayers.io') Visualize Docker images and the layers that compose them.

---

## Run Docker Container
```bash
	$ git clone https://github.com/htmlgraphic/Mail-Server.git && cd Mail-Server
	$ git checkout loopback-master
	$ make (list other commands)
	$ make run (runs docker-compose)
```


## Run Google Cloud - VM Instance Container-Optimized OS
```bash
git clone https://github.com/htmlgraphic/Mail-Server.git && cd Mail-Server
git checkout loopback-master
docker run -d -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD:$PWD" -w="$PWD" docker/compose:1.24.0 up
````


## Test Driven Development

**[CircleCI](https://circleci.com/gh/htmlgraphic/Mail-Server)** - Test the Dockerfile process, can the container be built the correctly? Verify the build process with a number of tests. Currently with this service no code can be tested on the running container. Data can be echo and available grepping the output via `docker logs | grep value`

[![Circle CI](https://circleci.com/gh/htmlgraphic/Mail-Server/tree/master.svg?style=svg&circle-token=f6aa2aeba9a663c714d5b2da1af9554c5afc086a)](https://circleci.com/gh/htmlgraphic/Mail-Server/tree/develop)

Using **CircleCI** review the `circle.yml` file.


**[Shippable](https://shippable.com)** - Run tests on the actual built container. These tests ensure the scripts have been setup properly and the service can start with parameters defined. If any test(s) fail the system should be reviewed closer.

[![Build Status](https://img.shields.io/shippable/54b200441cda23c2985c89a2.svg)](https://app.shippable.com/projects/54b200441cda23c2985c89a2)

Using **Shippable** review the `shippable.yml` file. This service will use a `circle.yml` file configuration but for the unique features provided by **Shippable** it is best to use the deadicated `shippable.yml` file. This service will fully test the creation of your container and can push the complete image to your private Docker repo if you desire.


---



Setup
=====


### 1) Add needed domains

Any domains you want to receive mail for to the file `mailbase/domains`:

	example.org
	example.net

### 2) Add user aliases

Edit the file `mailbase/aliases`, to add any needed aliases:

	johndoe@example.org         john.doe@example.org
	john.doe@example.org        john.doe@example.org
	admin@forum.example.org     forum-admin@example.org
	@example.net                catch-all@example.net

An IMAP mail account is created for each entry on the right hand side.
Every mail sent to one of the addresses in the left column will
be delivered to the corresponding account in the right column.

### 3) Add user passwords

Edit the file `mailbase/passwords` with the following:

	john.doe@example.org:{PLAIN}password123
	admin@example.org:{SHA256-CRYPT}$5$ojXGqoxOAygN91er$VQD/8dDyCYOaLl2yLJlRFXgl.NSrB3seZGXBRMdZAr6

To get the hash values, you can either install dovecot locally or use lxc-attach to attach to the running
container and run `doveadm pw -s <scheme-name>` inside.


### 4) Build ALL Containers:

	make run

You can build single targets, so if you dont want the webmail you can just run `make dovecot` instead. The Makefile is extremely simple, dont be afraid to look inside.



Known issues / Todo / Wishlist
==============================
- Improve this guide
- HELO isn't set correctly, which can lead to problems with outgoing mail on some servers



#### PULL REQUESTS WELCOME!
