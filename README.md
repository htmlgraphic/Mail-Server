## Mail Server Docker (HONEY POT)

[![CircleCI](https://circleci.com/gh/htmlgraphic/Mail-Server/tree/loopback-master.svg?style=svg)](https://circleci.com/gh/htmlgraphic/Mail-Server/tree/loopback-master) 
[![Run Status](https://api.shippable.com/projects/54b200441cda23c2985c89a2/badge?branch=loopback-master)](https://app.shippable.com/github/htmlgraphic/Mail-Server/dashboard) 


A secure, minimal-configuration mail server which will accept any email it receives.

This repository is tailored to help with email development and testing, no email will be sent out from this container build.

 - **dovecot**:  The SMTP and IMAP server. This container uses postfix as MTA and dovecot as IMAP server.
	All incoming mail is accepted via authentication (via username and password) clients can send messages via STARTTLS on port 587.

 - **mailbase**: This image is just an implementation detail. It is a workaround to allow sharing of configuration files between multiple docker images and redeploys. 

---

## Run Docker Container
```bash
	> git clone https://github.com/htmlgraphic/Mail-Server.git && cd Mail-Server
	> git checkout loopback-master
	> make (list other commands)
	> make run (runs docker-compose)
```


## Run Google Cloud - VM Instance
```bash
	> git clone https://github.com/htmlgraphic/Mail-Server.git && cd Mail-Server
	> git checkout loopback-master
	> docker run -d -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD:$PWD" -w="$PWD" docker/compose:1.24.0 up
````

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
