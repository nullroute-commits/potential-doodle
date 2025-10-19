# Contributing Guide

## Containerized CI/CD Pipeline

This repository implements a fully containerized CI/CD pipeline where all development, testing, linting, security scanning, and deployment steps run inside Docker/Podman containers. No external GitHub services (actions, runners, secrets) are required.

## Getting Started

### Prerequisites

- Docker (or Podman with Docker-compatible CLI) installed and running
- Git

### Usage Instructions

#### 1️⃣ Clone the Repository

```sh
git clone https://github.com/nullroute-commits/potential-doodle.git
cd potential-doodle
```

#### 2️⃣ Execute the Full CI Pipeline

To execute the complete CI pipeline inside the isolated builder container:

```sh
docker compose run --rm ci-builder
```

This command will:
- Spin up required services (PostgreSQL, KeyDB)
- Run linting checks
- Perform type-checking
- Execute security scans
- Run tests with coverage
- Build the production image
- Push the image to the configured registry

#### 3️⃣ Local Development

For local development without the full pipeline, start the runtime stack:

```sh
docker compose up -d db cache app
```

Access the Django application at http://localhost:8000.

#### 4️⃣ Release a New Version

When ready to release a new version:

1. Bump the version tag in `pyproject.toml`
2. Commit your changes
3. Run the image publishing script:

```sh
docker compose run --rm ci-builder ./scripts/publish_images.sh
```

The image will be pushed with both the commit SHA tag and a `latest` tag.

## Architecture

### Docker Images

- **Builder Image** (`ghcr.io/nullroute-commits/django-ci-builder`): Runs all CI steps (lint, type-check, security, tests, coverage, packaging) in an isolated environment.
- **Runtime Image** (`ghcr.io/nullroute-commits/django-runtime`): Lightweight Alpine image that runs the Django app in production.

### Services

- **ci-builder**: Executes the complete CI pipeline
- **app**: Django application runtime
- **db**: PostgreSQL 15 (Alpine)
- **cache**: KeyDB (Redis-compatible)

## Local Development with Makefile

For quick iteration without Docker, you can use the Makefile:

```sh
make lint        # Run linting checks
make typecheck   # Run type checking
make security    # Run security scans
make test        # Run tests
make coverage    # Generate coverage report
make build-runtime  # Build runtime image
make publish     # Publish images
make all         # Run all checks
```

## Environment Variables

Secrets and configuration should be provided via environment variables or a `.env` file (which should be excluded from version control).

Example `.env` file:

```
POSTGRES_PASSWORD=your_secure_password
REDIS_PASSWORD=your_redis_password
DJANGO_SECRET_KEY=your_django_secret_key
DEBUG=False
```

## Notes

- All CI logic lives inside the `ci-builder` container; no external GitHub Actions or secrets are required.
- The builder image includes all required tools (Poetry, pre-commit, Bandit, MyPy, pytest, coverage, etc.).
- Developers do not need to install these tools locally.
- For Podman users: Replace `docker` commands with `podman` equivalents. The compose file is compatible with both.

## Pipeline Stages

1. **Linting & Formatting**: black, flake8, isort, pydocstyle
2. **Type Checking**: mypy
3. **Security Scanning**: bandit
4. **Testing**: pytest with coverage
5. **Coverage Report**: XML and HTML reports
6. **Image Building**: Production-ready Docker images
7. **Image Publishing**: Push to container registry
