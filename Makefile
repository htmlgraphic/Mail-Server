# Build a container via the command "make build"
# By Jason Gegere <jason@htmlgraphic.com>

VERSION 	= 2.1.9
NAME 		= imap-server
IMAGE_REPO 	= htmlgraphic
IMAGE_NAME 	= $(IMAGE_REPO)/$(NAME)
DOMAIN 		= htmlgraphic.com

all:: help


help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "     make build		- Build image $(IMAGE_NAME):$(VERSION)"
	@echo "     make push		- Push $(IMAGE_NAME):$(VERSION) to public docker repo"
	@echo "     make run		- Run docker-compose and create local development environment"
	@echo "     make start		- Start the EXISTING $(NAME) container"
	@echo "     make stop		- Stop local environment build"
	@echo "     make restart	- Stop and start $(NAME) container"
	@echo "     make rm		- Remove $(NAME) container"

#### MAIL SERVICE

build:
	@echo "Building $(IMAGE_NAME):$(VERSION)..."
	cd dovecot; docker build -t $(IMAGE_NAME):$(VERSION) .

push:
	@echo "note: If the repository is set as an automatted build you will NOT be able to push"
	docker push $(IMAGE_NAME):$(VERSION)

run:
	@echo "Run $(IMAGE_NAME):$(VERSION)..."
	docker-compose -f docker-compose.yml up -d

start:
	@echo "Starting $(NAME):$(VERSION)..."
	docker start $(NAME)

stop:
	@echo "Stopping $(NAME):$(VERSION)..."
	docker-compose stop

restart: stop start

rm: stop
	@echo "Removing $(NAME):$(VERSION)..."
	docker rm $(NAME)


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
