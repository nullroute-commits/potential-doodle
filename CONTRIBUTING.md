# Contributing to potential-doodle

Thank you for your interest in contributing to this project!

## Development Setup

This project uses a fully containerized development and CI/CD workflow. You don't need to install Python or any dependencies locally—everything runs inside Docker containers.

### Prerequisites

- Docker (or Podman with Docker-compatible CLI)
- Docker Compose (bundled with Docker Desktop)
- Git

### Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/nullroute-commits/potential-doodle.git
   cd potential-doodle
   ```

2. Run the full CI pipeline inside the builder container:
   ```bash
   docker compose run --rm ci-builder
   ```

   This will:
   - Run all linters and formatters (black, flake8, isort, pydocstyle)
   - Perform type checking with mypy
   - Run security scans with bandit
   - Execute all tests with pytest
   - Generate coverage reports

3. For local development and testing:
   ```bash
   docker compose up -d db cache app
   ```

   The Django application will be available at http://localhost:8000

## Code Quality Standards

All code must pass the following checks:

- **Formatting**: Black with 100-character line length
- **Import sorting**: isort with Black profile
- **Linting**: flake8 with max line length 100
- **Type checking**: mypy with strict settings
- **Security**: bandit security scanner
- **Testing**: pytest with minimum 80% coverage
- **Documentation**: pydocstyle with Google convention

These checks are enforced automatically via pre-commit hooks in the builder container.

## Making Changes

1. Create a new branch for your feature or bugfix:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes to the code

3. Test your changes:
   ```bash
   docker compose run --rm ci-builder
   ```

4. Commit your changes with a descriptive message:
   ```bash
   git commit -m "Add feature: description"
   ```

5. Push your branch and create a pull request

## Running Individual Commands

You can also run individual pipeline steps using the Makefile:

```bash
# Run only linters
make lint

# Run only type checking
make typecheck

# Run only security scans
make security

# Run only tests
make test

# Generate coverage report
make coverage

# Build the runtime image
make build-runtime
```

Note: The Makefile assumes you have the required tools installed locally. For a fully isolated environment, use the Docker-based workflow.

## Environment Variables

The application uses environment variables for configuration. Create a `.env` file (not tracked in git) with:

```bash
POSTGRES_PASSWORD=your-secure-password
REDIS_PASSWORD=your-redis-password
DJANGO_SECRET_KEY=your-secret-key
DJANGO_DEBUG=False
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1
```

An example file `.env.example` is provided in the repository.

## Project Structure

```
potential-doodle/
├── src/
│   ├── app/
│   │   ├── __init__.py
│   │   ├── settings.py
│   │   ├── urls.py
│   │   ├── wsgi.py
│   │   └── asgi.py
│   └── manage.py
├── tests/
│   ├── __init__.py
│   └── test_basic.py
├── scripts/
│   ├── run_pipeline.sh
│   └── publish_images.sh
├── docs/
├── Dockerfile.builder
├── Dockerfile.runtime
├── docker-compose.yml
├── pyproject.toml
├── poetry.lock
├── requirements.txt
├── .pre-commit-config.yaml
├── pytest.ini
├── Makefile
├── README.md
├── CONTRIBUTING.md
└── LICENSE
```

## Troubleshooting

### Database Connection Issues

If you encounter database connection errors:

```bash
docker compose down -v  # Remove volumes
docker compose up -d db cache
```

### Permission Issues

If you have permission issues with Docker:

```bash
sudo usermod -aG docker $USER
newgrp docker
```

### Container Build Failures

If the builder container fails to build:

```bash
docker compose build --no-cache ci-builder
```

## Getting Help

If you need help or have questions:

1. Check existing issues on GitHub
2. Create a new issue with a detailed description of your problem
3. Include relevant error messages and logs

## License

By contributing to this project, you agree that your contributions will be licensed under the same license as the project (see LICENSE file).
