VERSION:=2021.12.3

.PHONY: all
all: docker-build

.PHONY: build
docker-build:
	docker --log-level=debug buildx build . \
		-f build.Dockerfile \
		--build-arg=CLOUDFLARED_VERSION=$(VERSION) \
		--platform linux/arm64

.PHONY: release
docker-release:
	docker --log-level=debug buildx build . \
		-f build.Dockerfile \
		--build-arg=CLOUDFLARED_VERSION=$(VERSION) \
		--platform linux/arm64 \
		--tag ghcr.io/milgradesec/cloudflared:$(VERSION) \
		--tag ghcr.io/milgradesec/cloudflared:latest \
		--tag milgradesec/cloudflared:$(VERSION) \
		--tag milgradesec/cloudflared:latest \
		--push
