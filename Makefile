
IMAGE_NAME=awgserver:custom
BUILD_DIR=$(dir $(abspath $(lastword $(MAKEFILE_LIST))))

genkey:
	ssh-keygen -t ed25519 -f ./key -N ""

build:
	docker build $(ARGS) -t $(IMAGE_NAME) $(BUILD_DIR)

stop:
	docker stop awgserver
	docker rm awgserver

sh:
	docker exec -it awgserver bash

run:
	docker run -d \
	  --name awgserver \
	  --restart unless-stopped \
	  -p 51820:51820/udp \
	  --cap-add=NET_ADMIN \
	  --cap-add=NET_RAW \
	  --device /dev/net/tun \
	  awgserver:custom

run_local:
	docker run --rm -it -p 51820:51820/udp \
	  --cap-add=NET_ADMIN \
	  --cap-add=NET_RAW \
	  --device /dev/net/tun \
	   awgserver:custom
