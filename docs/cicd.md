# CI/CD Pipeline

## Overview

This template provides a complete CI/CD pipeline for autonomous bot execution.

## Execution Order

The bot should execute steps in this order:

1. `clone_repo` - Clone the repository
2. `setup_python_environment` - Set up Python and Poetry
3. `initialize_repository_structure` - Create directory structure
4. `add_dependency_files` - Add pyproject.toml and configuration
5. `create_django_project` - Bootstrap Django
6. `configure_caching_and_database` - Configure PostgreSQL and Redis
7. `add_alpine_container_definitions` - Add container files
8. `install_pre_commit_hooks` - Set up code quality hooks
9. `write_makefile` - Create orchestration Makefile
10. `populate_ci_scripts` - Add shell scripts
11. `run_initial_tests` - Validate setup
12. `build_container_images` - Build Docker/Podman images
13. `publish_images` - Push to registry
14. `generate_documentation` - Build docs
15. `tag_and_release` - Create release

## Makefile Targets

The Makefile provides a single entry point for all operations:

```bash
make all          # Run everything
make setup        # Set up environment
make deps         # Install dependencies
make lint         # Run linters
make typecheck    # Run mypy
make security     # Run bandit
make test         # Run tests
make coverage     # Generate coverage
make build-docker # Build Docker image
make build-podman # Build Podman image
make build-lxc    # Create LXC container
make docs         # Build documentation
make clean        # Clean artifacts
make release      # Tag and release
```

## Shell Scripts

If `make` is unavailable, use shell scripts:

### run_all.sh

Executes the complete pipeline:

```bash
./scripts/run_all.sh
```

### publish_images.sh

Publishes container images to registry:

```bash
./scripts/publish_images.sh
```

## Code Quality Checks

### Linting

- **black**: Code formatting
- **isort**: Import sorting
- **flake8**: Style guide enforcement
- **pylint**: Code analysis
- **pydocstyle**: Docstring conventions

### Type Checking

- **mypy**: Static type checking

### Security

- **bandit**: Security vulnerability scanning

## Testing

- **pytest**: Test runner
- **pytest-django**: Django testing utilities
- **coverage**: Code coverage analysis

## Pre-commit Hooks

All quality checks run automatically before commits:

```bash
pre-commit install
pre-commit run --all-files
```

## GitHub Actions Integration

Create `.github/workflows/ci.yml` for automated CI/CD:

```yaml
name: CI/CD

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      - name: Install dependencies
        run: make setup deps
      - name: Run tests
        run: make test
      - name: Build images
        run: make build-docker
```

## Bot Requirements

For successful execution, the bot needs:

- Python 3.11+
- Docker or Podman installed
- Git credentials for pushing images
- Environment variables for secrets
