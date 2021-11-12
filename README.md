# 🐳 Cloudflare Tunnel for arm64

[![Docker CI](https://github.com/milgradesec/cloudflared-docker-arm64/actions/workflows/ci.yml/badge.svg)](https://github.com/milgradesec/cloudflared-docker-arm64/actions/workflows/ci.yml)

## Why

Currently Cloudflare doesn't provide an official linux/arm64 docker image of `cloudflared` suitable for devices like RaspberryPi and AWS Graviton.

## Installing `cloudflared`

Get from Github Container Registry:

```shell
docker pull ghcr.io/milgradesec/cloudflared:latest
```

Get from Docker Hub:

```shell
docker pull milgradesec/cloudflared:latest
```

## About

The image is slightly modified to run as limited user instead of root.
