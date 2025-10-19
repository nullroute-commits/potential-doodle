#!/usr/bin/env sh
set -eu

# Assumes the builder container has already built the runtime image and tagged it
# Push both Docker and Podman registries (if Podman is preferred, the same OCI endpoint works)
COMMIT=${GITHUB_SHA:-local}
REGISTRY="ghcr.io/nullroute-commits"
IMAGE="django-runtime"

# Docker push
docker push ${REGISTRY}/${IMAGE}:${COMMIT}

# Optional: also push with "latest" tag
docker tag ${REGISTRY}/${IMAGE}:${COMMIT} ${REGISTRY}/${IMAGE}:latest
docker push ${REGISTRY}/${IMAGE}:latest

echo "🚀 Images published to ${REGISTRY}"
