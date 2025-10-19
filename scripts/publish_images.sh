#!/usr/bin/env sh
set -eu

echo "📦 Publishing container images..."

# Assumes the builder container has already built the runtime image and tagged it
# Push both to GitHub Container Registry

COMMIT=${GITHUB_SHA:-local}
REGISTRY="ghcr.io/nullroute-commits"

# Login to GitHub Container Registry (requires GITHUB_TOKEN)
if [ -n "${GITHUB_TOKEN:-}" ]; then
  echo "${GITHUB_TOKEN}" | docker login ghcr.io -u USERNAME --password-stdin
fi

# Push builder image
echo "Pushing builder image..."
docker push ${REGISTRY}/django-ci-builder:latest

# Push runtime image with commit tag
echo "Pushing runtime image (${COMMIT})..."
docker push ${REGISTRY}/django-runtime:${COMMIT}

# Push runtime image with latest tag
echo "Pushing runtime image (latest)..."
docker push ${REGISTRY}/django-runtime:latest

echo "✅ All images published successfully"
