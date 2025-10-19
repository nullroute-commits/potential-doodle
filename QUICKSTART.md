# Quick Start Guide

This guide will get you up and running with the Django CI/CD template in 5 minutes.

## Prerequisites

- Docker (or Podman)
- Git

That's it! No Python, Poetry, or other tools need to be installed on your host system.

## Step 1: Clone and Configure

```bash
# Clone the repository
git clone https://github.com/nullroute-commits/potential-doodle.git
cd potential-doodle

# Create environment file
cp .env.example .env

# (Optional) Edit .env to set passwords
# nano .env
```

## Step 2: Start All Services

```bash
# Start PostgreSQL, KeyDB, and Django app
docker compose up
```

The Django application will be available at http://localhost:8000

## Step 3: Create Django Project (First Time Only)

In a new terminal:

```bash
# Enter the builder container
docker compose run --rm ci-builder sh

# Inside the container, create Django project
poetry run django-admin startproject app src

# Exit the container
exit
```

## Step 4: Run CI/CD Pipeline

```bash
# Execute the complete pipeline (lint, test, security, build)
docker compose run --rm ci-builder /workspace/scripts/run_pipeline.sh
```

This will:
1. ✅ Check code quality (black, flake8, isort, pylint, pydocstyle)
2. ✅ Verify types (mypy)
3. ✅ Scan for security issues (bandit)
4. ✅ Run tests with coverage (pytest)
5. ✅ Build production Docker images
6. ✅ Clean up

## Step 5: Develop

### Add New Django App

```bash
docker compose run --rm ci-builder sh -c "cd src && poetry run python manage.py startapp myapp"
```

### Run Migrations

```bash
docker compose run --rm app python manage.py migrate
```

### Create Superuser

```bash
docker compose run --rm app python manage.py createsuperuser
```

### Run Tests

```bash
docker compose run --rm ci-builder pytest tests -vv
```

## Common Commands

### View Logs
```bash
docker compose logs -f app
```

### Stop All Services
```bash
docker compose down
```

### Rebuild Images
```bash
docker compose build
```

### Access Database
```bash
docker compose exec db psql -U app_user -d app_db
```

### Access Redis/KeyDB CLI
```bash
docker compose exec cache keydb-cli
```

## Local Development (Without Docker)

If you prefer to develop locally:

```bash
# Setup Python environment
make setup
make deps

# Activate virtual environment
poetry shell

# Run development server
python src/manage.py runserver
```

Note: You'll need PostgreSQL and Redis/KeyDB running locally or update settings to use SQLite.

## Next Steps

- Read [README.md](README.md) for comprehensive documentation
- Check [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines  
- See [IMPLEMENTATION.md](IMPLEMENTATION.md) for technical details

## Troubleshooting

### Port Already in Use
If port 8000 is in use, edit `docker-compose.yml` and change the port mapping:
```yaml
ports:
  - "8080:8000"  # Change 8080 to any available port
```

### Permission Issues
On Linux, if you get permission errors:
```bash
sudo chown -R $USER:$USER .
```

### Clean Start
To start fresh:
```bash
docker compose down -v  # Remove volumes too
docker compose up --build
```

## Support

Open an issue on GitHub for questions or problems.

---

**That's it!** You now have a production-ready Django template with complete CI/CD infrastructure running in containers. 🚀
