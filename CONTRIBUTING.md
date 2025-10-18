# Contributing to Django Template

Thank you for your interest in contributing to this enterprise-grade Django CI/CD template!

## Getting Started

1. **Fork the repository** and clone your fork locally
2. **Set up your development environment** by running:
   ```bash
   make setup
   make deps
   ```

## Development Workflow

### Making Changes

1. Create a new branch for your feature or bug fix:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. Make your changes following our coding standards (see below)

3. Run the linters and formatters:
   ```bash
   make lint
   ```

4. Run type checking:
   ```bash
   make typecheck
   ```

5. Run security scanning:
   ```bash
   make security
   ```

6. Run tests and ensure they pass:
   ```bash
   make test
   make coverage
   ```

### Code Quality Standards

This project enforces strict code quality standards:

- **Black** for code formatting
- **isort** for import sorting
- **flake8** for linting
- **pylint** for additional linting
- **pydocstyle** for docstring style checking
- **mypy** for type checking
- **bandit** for security issue scanning

All of these are configured in `.pre-commit-config.yaml` and will run automatically before commits if you install the pre-commit hooks:

```bash
. .venv/bin/activate && pre-commit install
```

### Testing

- Write tests for all new features and bug fixes
- Maintain or improve code coverage
- Tests are located in the `tests/` directory
- Use `pytest` for writing tests

### Container Builds

All container images should be based on official Alpine Linux images to minimize size:

- Docker images use `python:3.11-alpine`
- PostgreSQL uses `postgres:15-alpine`
- KeyDB uses `eqalpha/keydb:latest-alpine`

Test your container builds locally:

```bash
make build-docker
make build-podman
```

## Submitting Changes

1. Push your changes to your fork
2. Submit a pull request to the main repository
3. Ensure all CI checks pass
4. Wait for a maintainer to review your changes

## Questions?

If you have questions, please open an issue for discussion before starting work on a significant change.

## License

By contributing, you agree that your contributions will be licensed under the same MIT License that covers this project.
