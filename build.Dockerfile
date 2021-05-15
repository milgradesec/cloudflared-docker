FROM --platform=amd64 golang:1.16.4 AS builder

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

ARG CLOUDFLARED_VERSION=2021.5.6

ENV GO111MODULE=on \
    CGO_ENABLED=0

WORKDIR /go/src/github.com/cloudflare/cloudflared/

RUN git clone --branch ${CLOUDFLARED_VERSION} --single-branch --depth 1 https://github.com/cloudflare/cloudflared.git && \
    cd cloudflared && \
    GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -ldflags "-w -s -X 'main.Version=${CLOUDFLARED_VERSION}'" github.com/cloudflare/cloudflared/cmd/cloudflared

FROM gcr.io/distroless/base-debian10:nonroot

COPY --from=builder --chown=nonroot /go/src/github.com/cloudflare/cloudflared/cloudflared /usr/local/bin/

USER nonroot

ENTRYPOINT ["cloudflared", "--no-autoupdate"]
CMD ["version"]