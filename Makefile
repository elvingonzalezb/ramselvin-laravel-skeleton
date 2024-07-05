#!/bin/bash

UID = $(shell id -u)
DOCKER_BE = ramselvin-application-laravel
DOCKER_DB = ramselvin-application-database

help: ## Show this help message
	@echo 'usage: make [target]'
	@echo
	@echo 'targets:'
	@egrep '^(.+)\:\ ##\ (.+)' ${MAKEFILE_LIST} | column -t -c 2 -s ':#'

start: ## Start the containers
	docker network ramselvin-application-laravel-network || true
	cp -n docker-compose.yml docker-compose.yml || true
	U_ID=${UID} docker-compose up -d

down: ## Down the containers
	U_ID=${UID} docker-compose down

stop: ## Stop the containers
	U_ID=${UID} docker-compose stop

restart: ## Restart the containers
	$(MAKE) stop && $(MAKE) start

build: ## Rebuilds all the containers
	docker network ramselvin-application-laravel-network || true
	cp -n docker-compose.yml docker-compose.yml || true
	U_ID=${UID} docker-compose build

composer-install: ## Installs composer dependencies
	U_ID=${UID} docker exec --user ${UID} ${DOCKER_BE} composer install --no-interaction

ssh-be: ## bash into the be container
	U_ID=${UID} docker exec -it --user ${UID} ${DOCKER_BE} bash

ssh-db: ## bash into the database container and start MySQL client
	U_ID=${UID} docker exec -it ${DOCKER_DB} mysql -u root -proot

