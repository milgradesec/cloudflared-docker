ARG CLOUDFLARED_VERSION=2021.5.6
ARG TARGET_GOOS=linux
ARG TARGET_GOARCH=arm64

FROM golang:1.16.4 as builder

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    CLOUDFLARED_VERSION=${CLOUDFLARED_VERSION} \
    TARGET_GOOS=${TARGET_GOOS} \
    TARGET_GOARCH=${TARGET_GOARCH}

WORKDIR /go/src/github.com/cloudflare/cloudflared/

RUN git clone --branch ${CLOUDFLARED_VERSION} https://github.com/cloudflare/cloudflared

RUN make cloudflared

FROM gcr.io/distroless/base-debian10:nonroot

COPY --from=builder --chown=nonroot /go/src/github.com/cloudflare/cloudflared/cloudflared /usr/local/bin/

USER nonroot

ENTRYPOINT ["cloudflared", "--no-autoupdate"]
CMD ["version"]