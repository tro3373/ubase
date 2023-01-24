SHELL := /bin/bash
app := ubase
timestamp := $(shell date '+%Y%m%d.%H%M%S')
# docker_user := "$(shell id -u):$(shell id -g)"
uid := $(shell id -u)
gid := $(shell id -g)
# export_docker_user := export docker_user=$(docker_user)
.DEFAULT_GOAL := up

tag:
	@tag="Release_${app}_${timestamp}" && git tag "$$tag" && echo "==> $$tag tagged."

# @docker_user=$(docker_user) docker-compose $(CMD) $(ARG)
# @docker-compose $(CMD) $(ARG)
_compose:
	@uid=$(uid) gid=$(gid) docker-compose $(CMD) $(ARG)

build:
	@make -s _compose CMD=build

up: start # logsf
start:
	@make -s _compose CMD="up -d"
stop: down
down:
	@make -s _compose CMD=down
restart:
	@make -s _compose CMD=restart

logs:
	@make -s _compose CMD=logs
logsf:
	@make -s _compose CMD="logs -f"

console:
	@docker exec -it $(app) /bin/bash --login
