#!/usr/bin/env bash
set -euo pipefail

VERSION=$(git rev-parse --short HEAD)
REGISTRY="ghcr.io/<ORG>"
IMAGE_NAME="django-template"

# Docker
docker tag ${IMAGE_NAME}:${VERSION} ${REGISTRY}/${IMAGE_NAME}:${VERSION}
docker push ${REGISTRY}/${IMAGE_NAME}:${VERSION}

# Podman (uses same registry)
podman tag ${IMAGE_NAME}:${VERSION}-podman ${REGISTRY}/${IMAGE_NAME}:${VERSION}-podman
podman push ${REGISTRY}/${IMAGE_NAME}:${VERSION}-podman
