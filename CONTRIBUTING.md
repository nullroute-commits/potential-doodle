# Contributing to Django CI/CD Template

Thank you for your interest in contributing to this enterprise-grade Django CI/CD template repository!

## Getting Started

### Prerequisites

- Python 3.11+
- Poetry 1.5.1+
- Docker or Podman
- Git

### Setup Development Environment

1. Clone the repository:
   ```bash
   git clone https://github.com/<ORG>/<TEMPLATE_REPO>.git
   cd <TEMPLATE_REPO>
   ```

2. Set up the Python environment:
   ```bash
   make setup
   ```

3. Install dependencies:
   ```bash
   make deps
   ```

4. Install pre-commit hooks:
   ```bash
   . .venv/bin/activate && pre-commit install
   ```

## Development Workflow

### Code Quality

Before committing, ensure your code passes all quality checks:

```bash
make lint          # Run formatters and linters
make typecheck     # Run mypy type checks
make security      # Run security scans with bandit
```

### Testing

Run the test suite:

```bash
make test          # Run all tests
make coverage      # Generate coverage report
```

### Building Containers

Build container images:

```bash
make build-docker  # Build Docker image
make build-podman  # Build Podman image
make build-lxc     # Create LXC container
```

## Code Style

This project uses:
- **Black** for code formatting
- **isort** for import sorting
- **flake8** for linting
- **pylint** for additional linting
- **mypy** for type checking
- **pydocstyle** for docstring style

All of these are enforced via pre-commit hooks.

## Pull Request Process

1. Create a feature branch from `main`
2. Make your changes
3. Ensure all tests pass and code quality checks succeed
4. Update documentation as needed
5. Submit a pull request with a clear description of changes

## Questions?

If you have questions or need help, please open an issue on GitHub.
