REGISTRY=cell
CONTEXT=$(abspath $(shell pwd))
IMAGE=playground
BLAH=${CONTEXT}

.PHONY: build

build:
	docker build -t ${REGISTRY}/${IMAGE} ${CONTEXT}

fresh:
	docker build --pull --no-cache -t ${REGISTRY}/${IMAGE} ${CONTEXT}

