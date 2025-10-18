# potential-doodle

A Django application with fully containerized CI/CD pipeline. All development, testing, linting, security scanning, and deployment steps run inside Docker/Podman containers—no external GitHub Actions or runners required.

## Features

- **🐳 Fully Containerized**: All CI/CD steps run inside Docker containers
- **🔒 Secure by Default**: Bandit security scanning integrated into the pipeline
- **✅ Quality Assured**: Automated linting, type checking, and testing
- **📦 Multi-stage Builds**: Optimized builder and runtime images
- **🚀 Production Ready**: Lightweight Alpine-based runtime with Gunicorn
- **💾 PostgreSQL + Redis**: Full stack with database and caching
- **📊 Coverage Reports**: Automated test coverage tracking

## Quick Start

### Prerequisites

- Docker (or Podman with Docker-compatible CLI)
- Docker Compose

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/nullroute-commits/potential-doodle.git
cd potential-doodle
```

### 2️⃣ Run the Full CI Pipeline

Execute all CI/CD steps inside the isolated builder container:

```bash
docker compose run --rm ci-builder
```

This will:
- ✨ Run linting and formatting (black, flake8, isort, pydocstyle)
- 🔍 Perform type checking (mypy)
- 🔒 Execute security scans (bandit)
- 🧪 Run all tests (pytest)
- 📊 Generate coverage reports
- 🏗️ Build production images

### 3️⃣ Start the Application Stack

For local development or testing:

```bash
docker compose up -d db cache app
```

The Django application will be available at: **http://localhost:8000**

### 4️⃣ Health Check

```bash
curl http://localhost:8000/health/
```

Expected response: `OK`

## Project Structure

```
potential-doodle/
├── src/                    # Django application source code
│   ├── app/               # Main Django project
│   │   ├── settings.py    # Django settings
│   │   ├── urls.py        # URL configuration
│   │   ├── wsgi.py        # WSGI application
│   │   └── asgi.py        # ASGI application
│   └── manage.py          # Django management script
├── tests/                  # Test suite
│   └── test_basic.py      # Basic application tests
├── scripts/               # CI/CD scripts
│   ├── run_pipeline.sh    # Main CI pipeline orchestration
│   └── publish_images.sh  # Image publishing script
├── docs/                   # Documentation
├── Dockerfile.builder      # Builder image for CI/CD
├── Dockerfile.runtime      # Production runtime image
├── docker-compose.yml      # Service orchestration
├── pyproject.toml         # Poetry configuration
├── poetry.lock            # Locked dependencies
├── requirements.txt       # Runtime dependencies
├── pytest.ini             # Pytest configuration
├── .pre-commit-config.yaml # Code quality hooks
├── Makefile               # Local development commands
├── .env.example           # Example environment variables
├── CONTRIBUTING.md        # Contribution guidelines
└── README.md              # This file
```

## Docker Images

### Builder Image (`ghcr.io/nullroute-commits/django-ci-builder`)

Multi-purpose container for all CI/CD operations:
- Based on Python 3.11 Alpine
- Includes Poetry, pre-commit, pytest, mypy, bandit
- Runs linting, testing, and security scans
- Used for development and continuous integration

### Runtime Image (`ghcr.io/nullroute-commits/django-runtime`)

Lightweight production container:
- Based on Python 3.11 Alpine
- Minimal dependencies (only runtime requirements)
- Runs Django with Gunicorn
- Optimized for production deployment

## Development Workflow

### Using Make (Local Development)

If you have Python and tools installed locally:

```bash
# Run all checks
make all

# Individual commands
make lint          # Run linters
make typecheck     # Type checking
make security      # Security scanning
make test          # Run tests
make coverage      # Coverage report
make build-runtime # Build production image
```

### Using Docker (Recommended)

Everything runs in isolated containers:

```bash
# Full pipeline
docker compose run --rm ci-builder

# Individual services
docker compose up -d db        # Start database
docker compose up -d cache     # Start Redis/KeyDB
docker compose up -d app       # Start Django app

# View logs
docker compose logs -f app

# Stop all services
docker compose down

# Clean up volumes
docker compose down -v
```

## Configuration

### Environment Variables

Create a `.env` file (not tracked in git) for local configuration:

```bash
cp .env.example .env
```

Key variables:
- `POSTGRES_PASSWORD`: Database password
- `REDIS_PASSWORD`: Redis/KeyDB password
- `DJANGO_SECRET_KEY`: Django secret key
- `DJANGO_DEBUG`: Debug mode (True/False)
- `DJANGO_ALLOWED_HOSTS`: Comma-separated allowed hosts

### Secrets Management

**Important**: Never commit secrets to version control!

Secrets can be provided via:
1. Environment variables (`.env` file locally)
2. CI platform variables (GitHub Secrets, GitLab CI/CD variables)
3. Secret management systems (HashiCorp Vault, AWS Secrets Manager)

## CI/CD Pipeline

The pipeline (`scripts/run_pipeline.sh`) executes:

1. **Linting & Formatting**: black, flake8, isort, pydocstyle
2. **Type Checking**: mypy with strict settings
3. **Security Scanning**: bandit for vulnerabilities
4. **Testing**: pytest with database and cache services
5. **Coverage**: Generate XML and terminal reports
6. **Building**: Create production-ready Docker images

All steps run inside the builder container with no external dependencies.

## Publishing Images

To publish images to a container registry:

```bash
# Set authentication (GitHub Container Registry example)
echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin

# Run publish script
docker compose run --rm ci-builder ./scripts/publish_images.sh
```

Images are tagged with:
- Commit SHA: `ghcr.io/nullroute-commits/django-runtime:${COMMIT}`
- Latest: `ghcr.io/nullroute-commits/django-runtime:latest`

## Testing

### Running Tests

```bash
# With Docker
docker compose run --rm ci-builder pytest tests -vv

# Locally (if tools installed)
make test
```

### Writing Tests

Tests are located in the `tests/` directory. Example:

```python
import pytest
from django.test import Client

@pytest.mark.django_db
def test_health_check() -> None:
    client = Client()
    response = client.get("/health/")
    assert response.status_code == 200
```

## Troubleshooting

### Database Connection Errors

```bash
docker compose down -v
docker compose up -d db cache
# Wait for database to be ready
docker compose exec db pg_isready -U app_user
```

### Permission Errors

```bash
# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker
```

### Build Cache Issues

```bash
# Rebuild without cache
docker compose build --no-cache
```

## Podman Support

This project is compatible with Podman. Simply alias Docker to Podman:

```bash
alias docker=podman
alias docker-compose="podman-compose"
```

Or use Podman directly:

```bash
podman-compose run --rm ci-builder
```

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our development process and how to submit contributions.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Architecture

### Service Dependencies

```
┌─────────────────┐
│   ci-builder    │  CI/CD Pipeline Container
└─────────────────┘

┌─────────────────┐     ┌──────────────┐     ┌──────────────┐
│      app        │────▶│      db      │     │    cache     │
│  (Django/Gun.)  │     │ (PostgreSQL) │     │   (KeyDB)    │
└─────────────────┘     └──────────────┘     └──────────────┘
```

### Build Process

```
Developer/CI
    │
    ▼
┌─────────────────────┐
│  Dockerfile.builder │──▶ CI/CD Operations
└─────────────────────┘    • Linting
    │                      • Type checking
    │                      • Security scans
    │                      • Testing
    ▼
┌──────────────────────┐
│  Dockerfile.runtime  │──▶ Production Image
└──────────────────────┘   • Minimal size
    │                      • Gunicorn
    │                      • Django app
    ▼
 Container Registry
(ghcr.io)
```

## Support

For issues, questions, or contributions:
- 📝 Open an issue on GitHub
- 💬 Check existing discussions
- 📧 Contact maintainers

---

**Built with ❤️ using Django, Docker, and modern DevOps practices**
