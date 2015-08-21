# Build a container via the command "make build"
# By Jason Gegere <jason@htmlgraphic.com>

VERSION 			= 2.1.9
NAME 				= imap-server
IMAGE_REPO 	= htmlgraphic
IMAGE_NAME 	= $(IMAGE_REPO)/$(NAME)
DOMAIN 			= htmlgraphic.com

all:: help


help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "     make build		- Build image $(IMAGE_NAME):$(VERSION)"
	@echo "     make push		- Push $(IMAGE_NAME):$(VERSION) to public docker repo"
	@echo "     make run		- Create a container for $(NAME)"
	@echo "     make start		- Start the EXISTING $(NAME) container"
	@echo "     make stop		- Stop $(NAME) container"
	@echo "     make restart	- Stop and start $(NAME) container"
	@echo "     make rm		- Remove $(NAME) container"
	@echo "     make data		- Build containers for persistent data"

#### MAIL SERVICE

build:
	@echo "Building $(IMAGE_NAME):$(VERSION)..."
	cd dovecot; docker build -t $(IMAGE_NAME):$(VERSION) .

push:
	@echo "note: If the repository is set as an automatted build you will NOT be able to push"
	docker push $(IMAGE_NAME):$(VERSION)

run:
	@echo "Run $(IMAGE_NAME):$(VERSION)..."
	docker run -d --restart=always --volumes-from mailvol --volumes-from mailbase --name $(NAME) -e LOG_TOKEN=$(IMAP_LOG_TOKEN) -p 25:25 -p 587:587 -p 143:143 $(IMAGE_NAME):$(VERSION)

start:
	@echo "Starting $(NAME):$(VERSION)..."
	docker start $(NAME)

stop:
	@echo "Stopping $(NAME):$(VERSION)..."
	docker stop $(NAME)

restart: stop start

rm: stop
	@echo "Removing $(NAME):$(VERSION)..."
	docker rm $(NAME)

data:
	@echo "Creating data containers for IMAP Server..."
	docker run -v /srv --name mailvol ubuntu:14.04
	cd mailbase; docker build --no-cache -t mailbase .
	docker run --name mailbase mailbase



#### BELOW NEEDS TO BE REFINED, SIMPLIFIED AND IMPROVED


rainloop: dovecot
	cd rainloop; docker build -t rainloop:1.6.9 .

mailpile: dovecot
	cd mailpile; docker build -t mailpile:latest .

owncloud: dovecot
	cd owncloud; docker build -t owncloud:7.0.2 .

run-rainloop:
	docker run -d -p 127.0.0.1:33100:80 rainloop:1.6.9

run-mailpile:
	docker run -d -p 127.0.0.1:33411:33411 mailpile:latest

run-owncloud:
	docker run -d -p 127.0.0.1:33200:80 -v /srv/owncloud:/var/www/owncloud/data owncloud:7.0.2

run-all: run run-rainloop run-owncloud
