# Container Deployment

## Overview

This template supports three container runtimes, all based on Alpine Linux for minimal image sizes:

- **Docker**: Industry-standard containerization
- **Podman**: Daemonless, rootless alternative to Docker
- **LXC**: System containers for full OS virtualization

## Building Images

### Docker

Build a Docker image:

```bash
make build-docker
```

This creates an image tagged with the current Git commit SHA:
```
ghcr.io/<ORG>/django-template:<commit-sha>
```

### Podman

Build a Podman image:

```bash
make build-podman
```

This creates an image tagged with:
```
ghcr.io/<ORG>/django-template:<commit-sha>-podman
```

### LXC

Create an LXC container:

```bash
make build-lxc
```

This launches an Alpine 3.18 container named `django-template-lxc`.

## Container Architecture

### Multi-stage Build

Both Docker and Podman images use multi-stage builds:

1. **Builder stage**: Installs build dependencies and compiles Python packages
2. **Runtime stage**: Copies only necessary files for a minimal final image

### Base Images

- **Python**: `python:3.11-alpine`
- **PostgreSQL**: `postgres:15-alpine`
- **KeyDB**: `eqalpha/keydb:latest-alpine`

### Build Dependencies

The builder stage installs:
- `gcc`: C compiler
- `musl-dev`: C standard library for Alpine
- `libffi-dev`: Foreign function interface library
- `postgresql-dev`: PostgreSQL client library headers

## Running Containers

### Docker Compose

Start all services:

```bash
docker-compose up
```

Stop all services:

```bash
docker-compose down
```

### Standalone Docker

Run the web container:

```bash
docker run -p 8000:8000 \
  -e POSTGRES_PASSWORD=secretpassword \
  -e POSTGRES_HOST=db \
  -e REDIS_HOST=cache \
  ghcr.io/<ORG>/django-template:<commit-sha>
```

### Podman

Run with Podman:

```bash
podman run -p 8000:8000 \
  -e POSTGRES_PASSWORD=secretpassword \
  -e POSTGRES_HOST=db \
  -e REDIS_HOST=cache \
  ghcr.io/<ORG>/django-template:<commit-sha>-podman
```

## Publishing Images

Publish images to GitHub Container Registry:

```bash
./scripts/publish_images.sh
```

Or manually:

```bash
docker push ghcr.io/<ORG>/django-template:<commit-sha>
podman push ghcr.io/<ORG>/django-template:<commit-sha>-podman
```

## Image Size Optimization

Alpine-based images significantly reduce size:

- Traditional Python image: ~900 MB
- Alpine Python image: ~50 MB
- Multi-stage build further reduces size by excluding build tools
