FROM golang:1.16.4 as builder

ARG CLOUDFLARED_VERSION=2021.5.6
ARG TARGET_GOOS=linux
ARG TARGET_GOARCH=arm64

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=${TARGET_GOOS} \
    GOARCH=${TARGET_GOARCH}

WORKDIR /go/src/github.com/cloudflare/cloudflared/

RUN git clone --branch ${CLOUDFLARED_VERSION} --single-branch --depth 1 https://github.com/cloudflare/cloudflared.git && \
    cd cloudflared && \
    go build -v -ldflags "-w -s -X 'main.Version=${CLOUDFLARED_VERSION}'" github.com/cloudflare/cloudflared/cmd/cloudflared

FROM alpine:3.13

RUN apk update && apk add --no-cache ca-certificates

FROM scratch

COPY --from=0 /go/src/github.com/cloudflare/cloudflared/cloudflared /cloudflared
COPY --from=1 /etc/ssl/certs /etc/ssl/certs

ENTRYPOINT ["cloudflared", "--no-autoupdate"]
CMD ["version"]