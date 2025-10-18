# Agentic Bot Execution Checklist

This file provides a step-by-step execution plan for an autonomous bot to use this template repository.

## Prerequisites Verification

Before starting, verify that the following tools are available:

```bash
# Check Python version
python3.11 --version || python3 --version

# Check Git
git --version

# Check Docker (optional)
docker --version

# Check Podman (optional)
podman --version

# Check LXC (optional)
lxc --version
```

If any required tools are missing, abort with a clear error message.

## Execution Order

Follow these steps in order. Each step corresponds to a section in the agentic bot manifest.

### 1. Clone Repository ✓

**Status**: Already done (repository created)

**For users**:
```bash
git clone https://github.com/<ORG>/<TEMPLATE_REPO>.git
cd <TEMPLATE_REPO>
```

### 2. Setup Python Environment

**Command**:
```bash
make setup
```

**What it does**:
- Creates Python 3.11 virtual environment in `.venv/`
- Upgrades pip to latest version
- Installs Poetry 1.5.1 and pip-tools 7.3.0

**Verification**:
```bash
. .venv/bin/activate
poetry --version
```

### 3. Install Dependencies

**Command**:
```bash
make deps
```

**What it does**:
- Installs all runtime and development dependencies via Poetry
- Creates or updates `poetry.lock` file

**Verification**:
```bash
. .venv/bin/activate
poetry show django
```

### 4. Create Django Project

**Command**:
```bash
. .venv/bin/activate
poetry run django-admin startproject app src
```

**What it does**:
- Creates Django project structure in `src/app/`
- Creates `src/manage.py`

**Verification**:
```bash
test -f src/manage.py && echo "Django project created"
```

### 5. Configure Database and Cache

**Manual Step**: Edit `src/app/settings.py`

**For PostgreSQL** - Find the `DATABASES` section and replace with:
```python
import os

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": "app_db",
        "USER": "app_user",
        "PASSWORD": os.getenv("POSTGRES_PASSWORD"),
        "HOST": os.getenv("POSTGRES_HOST", "localhost"),
        "PORT": os.getenv("POSTGRES_PORT", "5432"),
    }
}
```

**For Cache** - Add after the DATABASES section:
```python
CACHES = {
    "default": {
        "BACKEND": "django.core.cache.backends.redis.RedisCache",
        "LOCATION": f"redis://{os.getenv('REDIS_HOST', 'localhost')}:{os.getenv('REDIS_PORT', '6379')}/1",
    }
}
```

### 6. Install Pre-commit Hooks

**Command**:
```bash
. .venv/bin/activate
pre-commit install
```

**What it does**:
- Installs pre-commit hooks for Git
- Hooks will run automatically on `git commit`

**Verification**:
```bash
pre-commit run --all-files
```

### 7. Run Code Quality Checks

**Commands**:
```bash
make lint        # Run all linters and formatters
make typecheck   # Run mypy type checking
make security    # Run bandit security scanning
```

**Expected outcome**:
- All code passes linting (or no source code yet)
- Type checking completes (may have warnings for empty project)
- Security scan completes (no issues expected)

### 8. Run Tests

**Command**:
```bash
make test
```

**What it does**:
- Runs pytest test suite
- Executes tests in `tests/` directory

**Expected outcome**:
- Basic tests pass (test_basic.py)
- Django tests require Django project to be created

### 9. Generate Coverage Report

**Command**:
```bash
make coverage
```

**What it does**:
- Runs tests with coverage tracking
- Generates HTML report in `htmlcov/`
- Generates XML report for CI tools

**Verification**:
```bash
test -d htmlcov && echo "Coverage report generated"
```

### 10. Build Container Images

**Docker**:
```bash
make build-docker
```

**Podman**:
```bash
make build-podman
```

**LXC**:
```bash
make build-lxc
```

**What it does**:
- Builds Alpine-based container images
- Tags with current Git commit SHA
- Uses multi-stage builds for optimization

**Verification**:
```bash
docker images | grep django-template
# or
podman images | grep django-template
```

### 11. Generate Documentation

**Command**:
```bash
make docs
```

**What it does**:
- Builds Sphinx documentation (when configured)
- Generates HTML docs in `docs/_build/html/`

**Note**: Requires Sphinx to be installed and configured

### 12. Publish Container Images

**Command**:
```bash
./scripts/publish_images.sh
```

**Prerequisites**:
- Container registry authentication (ghcr.io)
- `REGISTRY` environment variable set
- Built images available

**What it does**:
- Tags images with registry path
- Pushes to container registry
- Works for both Docker and Podman

### 13. Tag and Release

**Command**:
```bash
make release
```

**What it does**:
- Creates Git tag (v1.0.0)
- Pushes tag to remote
- Publishes container images

## All-in-One Execution

To run all steps sequentially (except manual configuration):

```bash
./scripts/run_all.sh
```

This script will:
1. Activate virtual environment
2. Run all make targets in sequence
3. Report success or failure

## Environment Variables

Create a `.env` file from the template:

```bash
cp .env.example .env
```

Edit `.env` to set:
- `SECRET_KEY`: Django secret key (generate with `python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'`)
- `POSTGRES_PASSWORD`: Database password
- `POSTGRES_HOST`: Database host (use `db` for docker-compose)
- `REDIS_HOST`: Cache host (use `cache` for docker-compose)

## Docker Compose Usage

For development with all services:

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f web

# Run migrations
docker-compose exec web python src/manage.py migrate

# Create superuser
docker-compose exec web python src/manage.py createsuperuser

# Stop services
docker-compose down
```

## Troubleshooting

### Poetry lock file issues
```bash
. .venv/bin/activate
poetry lock --no-update
```

### Permission issues with scripts
```bash
chmod +x scripts/*.sh
```

### Docker build fails
- Ensure internet connectivity for Alpine package downloads
- Check Docker daemon is running
- Verify sufficient disk space

### Pre-commit hooks fail
```bash
. .venv/bin/activate
pre-commit clean
pre-commit install
```

## Success Criteria

The template is successfully deployed when:

1. ✅ Virtual environment created
2. ✅ All dependencies installed
3. ✅ Django project created in `src/app/`
4. ✅ Database and cache configured
5. ✅ Pre-commit hooks installed
6. ✅ All linters pass
7. ✅ All tests pass
8. ✅ Coverage report generated
9. ✅ Container images built successfully
10. ✅ Documentation generated
11. ✅ Images published to registry
12. ✅ Release tagged and pushed

## Notes for Bot Implementers

- All commands assume execution from repository root
- Use `set -euo pipefail` in bash scripts for proper error handling
- Check exit codes after each command
- Log output for debugging
- Replace `<ORG>` and `<TEMPLATE_REPO>` placeholders before execution
- Ensure environment variables are set before starting services
- The template uses Python 3.11+ (compatible with 3.12)

## Clean Up

To remove all generated files and start fresh:

```bash
make clean
```

This removes:
- Virtual environment (`.venv/`)
- Build artifacts
- Coverage reports
- Documentation builds
- Python bytecode

## Additional Resources

- [README.md](README.md) - Main project documentation
- [CONTRIBUTING.md](CONTRIBUTING.md) - Contribution guidelines
- [IMPLEMENTATION.md](IMPLEMENTATION.md) - Implementation details
- [docs/getting-started.md](docs/getting-started.md) - Quick start guide
