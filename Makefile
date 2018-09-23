# Build a container via the command "make build"
# By Jason Gegere <jason@htmlgraphic.com>

VERSION 	= loopback
NAME 		= mail
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
	cd dovecot; docker build \
		--build-arg VCS_REF=`git rev-parse --short HEAD` \
		--build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--rm -t $(IMAGE_NAME):$(VERSION) .

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
	docker-compose stop
	docker rm -f $(NAME)
