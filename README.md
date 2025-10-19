# Django CI/CD Template with Containerized Pipeline

A production-ready Django template repository with a complete containerized CI/CD pipeline. All development, testing, linting, security scanning, and deployment steps run inside Docker/Podman containers with no external dependencies required.

## Features

- 🐳 **Fully Containerized**: All CI/CD steps run in Alpine-based Docker containers
- 🔒 **Security First**: Integrated security scanning with Bandit
- 🧪 **Comprehensive Testing**: pytest with coverage reporting
- 📦 **Multi-stage Builds**: Optimized builder and runtime images
- 🚀 **Ready to Deploy**: Production-ready configuration with Gunicorn
- 🔧 **Developer Friendly**: Makefile, pre-commit hooks, and automated workflows
- 📊 **Database & Cache**: PostgreSQL 15 and KeyDB (Redis-compatible) included

## Quick Start

### Prerequisites

- Docker or Podman
- Python 3.11+
- Make (optional, but recommended)

### Setup

1. **Clone the repository**:
```bash
git clone https://github.com/nullroute-commits/potential-doodle.git
cd potential-doodle
```

2. **Set up environment**:
```bash
# Copy environment template
cp .env.example .env

# Setup Python environment and install dependencies
make setup
make deps
```

3. **Create Django project** (first time only):
```bash
poetry shell
django-admin startproject app src
```

4. **Start all services**:
```bash
docker compose up
```

The Django application will be available at `http://localhost:8000`

## Architecture

### Container Images

**Dockerfile.builder**: CI/CD pipeline image
- Based on `python:3.11-alpine`
- Includes Poetry, pytest, mypy, bandit, pre-commit
- Runs all quality checks and tests

**Dockerfile.runtime**: Production application image  
- Based on `python:3.11-alpine`
- Multi-stage build for minimal size
- Runs Django with Gunicorn

### Services

The `docker-compose.yml` orchestrates 4 services:

- **ci-builder**: Executes the CI/CD pipeline
- **app**: Django application (production runtime)
- **db**: PostgreSQL 15 (Alpine)
- **cache**: KeyDB (Redis-compatible, Alpine)

## Usage

### Development

```bash
# Run linters and formatters
make lint

# Run type checks
make typecheck

# Run security scan
make security

# Run tests
make test

# Run tests with coverage
make coverage

# Run all checks
make all
```

### Docker Commands

```bash
# Build images
make build-docker

# Start all services
docker compose up

# Start in detached mode
docker compose up -d

# View logs
docker compose logs -f app

# Stop services
docker compose down
```

### CI/CD Pipeline

The complete CI/CD pipeline can be executed with:

```bash
./scripts/run_pipeline.sh
```

This runs:
1. Code quality checks (black, flake8, isort, pylint, pydocstyle)
2. Type checking (mypy)
3. Security scanning (bandit)
4. Test suite (pytest)
5. Coverage reporting
6. Docker image build
7. Cleanup

### Publishing Images

```bash
./scripts/publish_images.sh
```

This publishes images to GitHub Container Registry:
- `ghcr.io/nullroute-commits/django-ci-builder:latest`
- `ghcr.io/nullroute-commits/django-runtime:latest`
- `ghcr.io/nullroute-commits/django-runtime:<commit-sha>`

## Project Structure

```
potential-doodle/
├── Dockerfile.builder        # CI pipeline image
├── Dockerfile.runtime        # Production runtime image
├── docker-compose.yml        # Service orchestration
├── pyproject.toml           # Poetry dependencies & config
├── requirements.txt         # Frozen dependencies
├── .pre-commit-config.yaml  # Pre-commit hooks
├── Makefile                 # Task automation
├── CONTRIBUTING.md          # Contribution guidelines
├── .env.example             # Environment variables template
├── scripts/
│   ├── run_pipeline.sh      # Execute CI/CD pipeline
│   └── publish_images.sh    # Publish container images
├── src/                     # Django application source
├── tests/                   # Test suite
└── docs/                    # Documentation
```

## Configuration

### Environment Variables

Copy `.env.example` to `.env` and configure:

- `POSTGRES_PASSWORD`: Database password
- `POSTGRES_HOST`: Database host (default: `db`)
- `POSTGRES_PORT`: Database port (default: `5432`)
- `REDIS_HOST`: Cache host (default: `cache`)
- `REDIS_PORT`: Cache port (default: `6379`)
- `DJANGO_SECRET_KEY`: Django secret key
- `DJANGO_DEBUG`: Debug mode (default: `False`)
- `GITHUB_TOKEN`: Token for pushing images

### Database & Cache

Configure Django to use PostgreSQL and Redis by updating `src/app/settings.py`:

```python
import os

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'app_db',
        'USER': 'app_user',
        'PASSWORD': os.getenv('POSTGRES_PASSWORD'),
        'HOST': os.getenv('POSTGRES_HOST', 'localhost'),
        'PORT': os.getenv('POSTGRES_PORT', '5432'),
    }
}

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.redis.RedisCache',
        'LOCATION': f"redis://{os.getenv('REDIS_HOST', 'localhost')}:{os.getenv('REDIS_PORT', '6379')}/1",
    }
}
```

## Development Tools

### Pre-commit Hooks

Automatically run code quality checks before commits:

```bash
poetry run pre-commit install
```

Hooks include:
- black (code formatting)
- isort (import sorting)
- flake8 (linting)
- pylint (additional linting)
- pydocstyle (docstring checking)
- mypy (type checking)

### Make Targets

- `make help` - Show all available targets
- `make setup` - Setup Python environment
- `make deps` - Install dependencies
- `make lint` - Run linters
- `make typecheck` - Run type checks
- `make security` - Run security scan
- `make test` - Run tests
- `make coverage` - Generate coverage report
- `make build-docker` - Build Docker images
- `make run-docker` - Start services
- `make clean` - Clean temporary files
- `make all` - Run complete CI/CD pipeline

## Technology Stack

- **Language**: Python 3.11+
- **Framework**: Django 4.2.5
- **Database**: PostgreSQL 15 (Alpine)
- **Cache**: KeyDB (Redis-compatible, Alpine)
- **WSGI Server**: Gunicorn 21.2.0
- **Package Manager**: Poetry 1.5.1
- **Testing**: pytest, pytest-django, coverage
- **Code Quality**: black, isort, flake8, pylint, pydocstyle
- **Type Checking**: mypy
- **Security**: bandit
- **Containers**: Docker/Podman with Alpine Linux

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development setup, workflow, and guidelines.

## License

This project is licensed under the GPL-3.0 License - see the [LICENSE](LICENSE) file for details.

## No External Dependencies

This template runs entirely in containers with no external GitHub Actions, runners, or services required. Everything needed for CI/CD is defined in the repository itself:

- ✅ No GitHub Actions workflows needed
- ✅ No external CI/CD services
- ✅ No runner configuration required
- ✅ Runs anywhere Docker/Podman is available
- ✅ Complete pipeline isolation
- ✅ Reproducible builds

## Support

For questions, issues, or feature requests, please open an issue on GitHub.
