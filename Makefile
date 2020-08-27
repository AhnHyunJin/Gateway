APP=gateway
CONTAINER=infuser-gateway

VERSION:=0.1
ENV:=dev #서비스 환경에 따라 dev, stage, prod로 구분

SERVICE_PORT = 9090
NETWORK_OPTION=--publish $(SERVICE_PORT):$(SERVICE_PORT)

ifneq ($(OS),Windows_NT)
	UNAME_S := $(shell uname -s)
	ifeq ($(UNAME_S),Linux)
		NETWORK_OPTION=--network="host"
	endif
	ifeq ($(UNAME_S),Darwin)
		NETWORK_OPTION=--publish $(SERVICE_PORT):$(SERVICE_PORT)
	endif
endif


build:
	go build ./main.go

docker-build:
	docker build --tag $(CONTAINER):$(VERSION) --build-arg=GATEWAY_ENV=$(ENV) .

run-docker:
	docker run --rm --detach $(NETWORK_OPTION) --name $(APP) $(CONTAINER):$(VERSION)

docker-log:
	docker logs --follow $(APP)

.PHONY: build docker run-docker docker-log