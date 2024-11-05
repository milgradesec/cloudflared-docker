VERSION := 2024.9.1

.PHONY: all
all: docker-build

.PHONY: build
docker-build:
	docker --log-level=debug buildx build . \
		--file build.Dockerfile \
		--build-arg=CLOUDFLARED_VERSION=$(VERSION) \
		--platform linux/amd64,linux/arm64,linux/arm/v7

.PHONY: release
docker-release:
	docker --log-level=debug buildx build . \
		--file build.Dockerfile \
		--build-arg=CLOUDFLARED_VERSION=$(VERSION) \
		--platform linux/amd64,linux/arm64,linux/arm/v7 \
		--tag ghcr.io/milgradesec/cloudflared:$(VERSION) \
		--tag ghcr.io/milgradesec/cloudflared:latest \
		--tag milgradesec/cloudflared:$(VERSION) \
		--tag milgradesec/cloudflared:latest \
		--push
