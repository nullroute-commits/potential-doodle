# Installation Guide

This guide walks through setting up the Django CI/CD template repository from scratch.

## Prerequisites

Ensure you have the following installed on your system:

- **Python 3.11 or higher**
- **Poetry 1.5.1 or higher**
- **Git**
- **Docker** (optional, for containerization)
- **Podman** (optional, Docker alternative)
- **LXC/LXD** (optional, for system containers)

## Step-by-Step Installation

### 1. Clone the Repository

```bash
git clone https://github.com/<ORG>/<TEMPLATE_REPO>.git
cd <TEMPLATE_REPO>
```

### 2. Setup Python Environment

Run the setup target to create a virtual environment:

```bash
make setup
```

This will:
- Create a Python 3.11 virtual environment in `.venv/`
- Upgrade pip to the latest version
- Install Poetry 1.5.1 and pip-tools 7.3.0

Alternatively, manually set up:

```bash
python3.11 -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\activate
pip install --upgrade pip
pip install poetry==1.5.1 pip-tools==7.3.0
```

### 3. Install Dependencies

Install all project dependencies:

```bash
make deps
```

Or manually:

```bash
source .venv/bin/activate
poetry install
```

### 4. Create Django Project

For first-time setup, create the Django project structure:

```bash
source .venv/bin/activate
poetry run django-admin startproject app src
```

This creates a Django project named `app` inside the `src/` directory.

### 5. Configure Database and Cache

Edit `src/app/settings.py` to configure PostgreSQL and Redis:

```python
import os

# Database configuration
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

# Cache configuration
CACHES = {
    "default": {
        "BACKEND": "django.core.cache.backends.redis.RedisCache",
        "LOCATION": f"redis://{os.getenv('REDIS_HOST', 'localhost')}:{os.getenv('REDIS_PORT', '6379')}/1",
    }
}
```

### 6. Set Up Environment Variables

Copy the example environment file:

```bash
cp .env.example .env
```

Edit `.env` and set your values:

```env
POSTGRES_PASSWORD=your_secure_password
POSTGRES_HOST=localhost  # or 'db' for Docker Compose
POSTGRES_PORT=5432
REDIS_HOST=localhost     # or 'cache' for Docker Compose
REDIS_PORT=6379
DJANGO_SECRET_KEY=your-secret-key-here
DJANGO_DEBUG=True
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1
```

### 7. Install Pre-commit Hooks

Set up pre-commit hooks for automatic code quality checks:

```bash
source .venv/bin/activate
pre-commit install
```

Test the hooks:

```bash
pre-commit run --all-files
```

### 8. Run Database Migrations

If using Docker Compose:

```bash
docker-compose up -d db
source .venv/bin/activate
export $(cat .env | xargs)
cd src
python manage.py migrate
```

### 9. Run Tests

Verify everything is working:

```bash
make test
```

### 10. Start Development Server

**Option A: Docker Compose (Recommended)**

```bash
docker-compose up
```

Access the application at http://localhost:8000

**Option B: Local Development**

```bash
# Start PostgreSQL and Redis separately, then:
source .venv/bin/activate
export $(cat .env | xargs)
cd src
python manage.py runserver
```

## Verification

Check that all components are working:

```bash
# Run all quality checks
make lint        # Code formatting and linting
make typecheck   # Type checking
make security    # Security scan
make test        # Run tests
make coverage    # Generate coverage report
```

## Building Containers

Build container images:

```bash
# Docker
make build-docker

# Podman
make build-podman

# LXC
make build-lxc
```

## Troubleshooting

### Poetry Installation Issues

If Poetry installation fails:

```bash
curl -sSL https://install.python-poetry.org | python3 -
export PATH="$HOME/.local/bin:$PATH"
```

### Python Version Issues

Ensure Python 3.11+ is installed:

```bash
python3 --version
```

If not available, install it:

- **Ubuntu/Debian**: `sudo apt-get install python3.11`
- **macOS**: `brew install python@3.11`
- **Windows**: Download from python.org

### Database Connection Issues

Ensure PostgreSQL is running:

```bash
# Docker Compose
docker-compose up db

# Or check system PostgreSQL
sudo systemctl status postgresql
```

### Permission Issues with Docker

If you encounter permission errors:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

## Next Steps

- Read the [Configuration Guide](docs/configuration.md)
- Review [Container Deployment](docs/containers.md)
- Set up [CI/CD Pipeline](docs/cicd.md)
- See [Contributing Guidelines](CONTRIBUTING.md)
