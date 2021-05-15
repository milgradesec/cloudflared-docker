ARG CLOUDFLARED_VERSION=2021.5.6
ARG TARGET_GOOS=linux
ARG TARGET_GOARCH=arm64

FROM golang:1.16.4 as builder

ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    TARGET_GOOS=${TARGET_GOOS} \
    TARGET_GOARCH=${TARGET_GOARCH}

WORKDIR /go/src/github.com/cloudflare/cloudflared/

RUN git clone --branch ${TAG} --single-branch --depth 1 https://github.com/cloudflare/cloudflared.git

# compile cloudflared
RUN make cloudflared

# use a distroless base image with glibc
FROM gcr.io/distroless/base-debian10:nonroot

# copy our compiled binary
COPY --from=builder --chown=nonroot /go/src/github.com/cloudflare/cloudflared/cloudflared /usr/local/bin/

# run as non-privileged user
USER nonroot

# command / entrypoint of container
ENTRYPOINT ["cloudflared", "--no-autoupdate"]
CMD ["version"]