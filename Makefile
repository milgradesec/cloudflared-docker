VERSION:=2021.10.2

all: 
	docker --log-level=debug buildx build . \
		-f build.Dockerfile \
		--build-arg=CLOUDFLARED_VERSION=$(VERSION) \
		--platform linux/arm64 \
		--tag ghcr.io/milgradesec/cloudflared:$(VERSION) \
		--tag ghcr.io/milgradesec/cloudflared:latest \
		--push
