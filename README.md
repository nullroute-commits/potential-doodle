# Django CI/CD Template Repository

Enterprise-grade CI/CD template for Django applications with PostgreSQL, Redis/KeyDB caching, and Alpine-based containers.

## Features

- 🐍 **Python 3.11** with Poetry dependency management
- 🌐 **Django 4.2.5** web framework
- 🐘 **PostgreSQL 15** database (Alpine-based)
- 🔴 **KeyDB** (Redis-compatible) for caching
- 🐳 **Multi-runtime support**: Docker, Podman, and LXC
- 🏔️ **Alpine Linux** base images for minimal container sizes
- 🔒 **Security scanning** with Bandit
- ✅ **Comprehensive testing** with pytest and coverage
- 🎨 **Code quality tools**: Black, isort, flake8, pylint, mypy
- 📚 **Sphinx documentation** support
- 🔄 **Pre-commit hooks** for automated code quality checks

## Quick Start

### Prerequisites

- Python 3.11+
- Poetry 1.5.1+
- Docker or Podman (optional, for containerization)
- Git

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/<ORG>/<TEMPLATE_REPO>.git
   cd <TEMPLATE_REPO>
   ```

2. Set up the development environment:
   ```bash
   make setup
   ```

3. Install dependencies:
   ```bash
   make deps
   ```

4. Create Django project (first time only):
   ```bash
   . .venv/bin/activate
   poetry install
   poetry run django-admin startproject app src
   ```

## Usage

### Development

Run all quality checks and tests:
```bash
make all
```

### Individual Commands

- **Setup environment**: `make setup`
- **Install dependencies**: `make deps`
- **Run linters**: `make lint`
- **Type checking**: `make typecheck`
- **Security scan**: `make security`
- **Run tests**: `make test`
- **Generate coverage**: `make coverage`
- **Build Docker image**: `make build-docker`
- **Build Podman image**: `make build-podman`
- **Create LXC container**: `make build-lxc`
- **Build documentation**: `make docs`
- **Clean artifacts**: `make clean`
- **Create release**: `make release`

### Using Docker Compose

Start all services (database, cache, web):
```bash
docker-compose up
```

### Shell Scripts

If `make` is unavailable, use the shell scripts:
```bash
./scripts/run_all.sh          # Run all checks and builds
./scripts/publish_images.sh   # Publish container images
```

## Project Structure

```
.
├── src/                    # Django application source code
├── tests/                  # Test suite
├── containers/             # Container definitions
│   ├── Dockerfile          # Docker image (Alpine-based)
│   ├── Podmanfile          # Podman image (Alpine-based)
│   └── lxc-config.yaml     # LXC container configuration
├── scripts/                # Automation scripts
│   ├── run_all.sh          # Execute all CI/CD steps
│   └── publish_images.sh   # Publish container images
├── docs/                   # Sphinx documentation
├── .github/                # GitHub workflows and configuration
├── pyproject.toml          # Poetry configuration
├── requirements.txt        # Pinned dependencies
├── .pre-commit-config.yaml # Pre-commit hooks configuration
├── docker-compose.yml      # Multi-service orchestration
├── Makefile                # Task orchestration
└── README.md               # This file
```

## Configuration

### Database

Configure PostgreSQL via environment variables:
- `POSTGRES_PASSWORD`: Database password
- `POSTGRES_HOST`: Database host (default: localhost)
- `POSTGRES_PORT`: Database port (default: 5432)

### Cache

Configure Redis/KeyDB via environment variables:
- `REDIS_HOST`: Cache host (default: localhost)
- `REDIS_PORT`: Cache port (default: 6379)

### Django Settings

Edit `src/app/settings.py` to customize Django configuration.

## Container Images

All container images are based on **official Alpine Linux** images to minimize size:

- **Python**: `python:3.11-alpine`
- **PostgreSQL**: `postgres:15-alpine`
- **KeyDB**: `eqalpha/keydb:latest-alpine`

## CI/CD Integration

This repository is designed for autonomous bot execution. The bot should:

1. Clone the repository
2. Run `make setup` to prepare the environment
3. Run `make deps` to install dependencies
4. Create the Django project structure
5. Run `make all` to execute all checks and builds
6. Run `./scripts/publish_images.sh` to publish container images
7. Run `make release` to tag and release

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Notes for Autonomous Bots

- All commands assume execution from the repository root
- Replace `<ORG>` and `<TEMPLATE_REPO>` placeholders with actual values
- Verify Docker, Podman, and LXC binaries are installed before container builds
- Environment variables for secrets must be supplied via CI host or `.env` file
- Alpine images require build tools (gcc, musl-dev, libffi-dev, postgresql-dev) for compiled extensions
- If `make` is unavailable, fall back to shell scripts in `scripts/`
