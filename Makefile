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

# @docker_user=$(docker_user) docker-compose $(cmd) $(arg)
# @docker-compose $(cmd) $(arg)
_compose:
	@uid=$(uid) gid=$(gid) docker-compose $(cmd) $(arg)

build:
	@make -s _compose cmd=build

build-nc:
	@make -s _compose cmd="build --no-cache"

up: start console # logsf
start: _prepare
	@make -s _compose cmd="up -d"
clean:
	rm -rf .data
cup: clean up
stop: down
down:
	@make -s _compose cmd=down
restart:
	@make -s _compose cmd=restart

logs:
	@make -s _compose cmd=logs
logsf:
	@make -s _compose cmd="logs -f"

console:
	@docker exec -it $(app) /bin/bash --login

_prepare:
	@! test -e .data/.wine && mkdir -p .data/.wine || :
