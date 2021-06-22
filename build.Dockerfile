FROM --platform=amd64 golang:1.16.5 AS builder

ARG TARGETPLATFORM
ARG TARGETOS
ARG TARGETARCH

ARG CLOUDFLARED_VERSION=2021.6.0

ENV GO111MODULE=on \
    CGO_ENABLED=0

WORKDIR /go/src/github.com/cloudflare/cloudflared/

RUN git clone --branch ${CLOUDFLARED_VERSION} --single-branch --depth 1 https://github.com/cloudflare/cloudflared.git && \
    cd cloudflared && \
    GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -mod=vendor -ldflags "-w -s -X 'main.Version=${CLOUDFLARED_VERSION}'" github.com/cloudflare/cloudflared/cmd/cloudflared

FROM alpine:3.14.0

RUN apk --update --no-cache --available add \
    ca-certificates \
    libressl \
    shadow \
    tzdata \
    && addgroup -g 1000 cloudflared \
    && adduser -u 1000 -G cloudflared -s /sbin/nologin -D cloudflared
    # && rm -rf /tmp/* /var/cache/apk/*

COPY --from=builder /go/src/github.com/cloudflare/cloudflared/cloudflared /usr/local/bin/

USER cloudflared

ENTRYPOINT ["/usr/local/bin/cloudflared", "--no-autoupdate"]
CMD ["version"]
