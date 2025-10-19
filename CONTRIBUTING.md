# Contributing to Django CI/CD Template

Thank you for your interest in contributing to this project! This document provides guidelines and instructions for contributing.

## Development Setup

### Prerequisites

- Python 3.11 or higher
- Docker or Podman
- Git

### Getting Started

1. Clone the repository:
```bash
git clone https://github.com/nullroute-commits/potential-doodle.git
cd potential-doodle
```

2. Set up your development environment:
```bash
make setup
make deps
```

3. Install pre-commit hooks:
```bash
poetry run pre-commit install
```

## Development Workflow

### Running Tests

```bash
# Run all tests
make test

# Run tests with coverage
make coverage
```

### Code Quality

Before committing code, ensure it passes all quality checks:

```bash
# Run linters
make lint

# Run type checks
make typecheck

# Run security scan
make security

# Run all checks
make all
```

### Pre-commit Hooks

This project uses pre-commit hooks to enforce code quality. The hooks will run automatically on `git commit`:

- **black**: Code formatting
- **isort**: Import sorting
- **flake8**: Linting
- **pylint**: Additional linting
- **pydocstyle**: Docstring style checking
- **mypy**: Static type checking

To run hooks manually:
```bash
pre-commit run --all-files
```

## Docker Development

### Building Images

```bash
# Build all images
make build-docker

# Build specific image
docker build -f Dockerfile.builder -t django-ci-builder .
docker build -f Dockerfile.runtime -t django-runtime .
```

### Running Services

```bash
# Start all services
make run-docker

# Or with docker-compose directly
docker compose up

# Run in detached mode
docker compose up -d
```

## Project Structure

```
potential-doodle/
├── src/              # Django application source code
├── tests/            # Test suite
├── docs/             # Documentation
├── scripts/          # CI/CD and automation scripts
├── Dockerfile.builder    # Builder image for CI pipeline
├── Dockerfile.runtime    # Runtime image for production
├── docker-compose.yml    # Service orchestration
├── pyproject.toml        # Poetry configuration
├── Makefile             # Task automation
└── README.md            # Project documentation
```

## Making Changes

1. Create a new branch:
```bash
git checkout -b feature/your-feature-name
```

2. Make your changes and commit:
```bash
git add .
git commit -m "Add feature: description"
```

3. Push to your fork and submit a pull request

## Pull Request Guidelines

- Write clear, descriptive commit messages
- Include tests for new features
- Update documentation as needed
- Ensure all CI checks pass
- Keep changes focused and atomic

## Code Style

This project follows:
- PEP 8 style guide
- Black code formatting (88 character line length)
- isort for import organization
- Type hints for all functions (mypy)

## Testing Guidelines

- Write tests for all new features
- Maintain test coverage above 80%
- Use pytest fixtures for test setup
- Follow AAA pattern (Arrange, Act, Assert)

## Security

- Run `bandit` security checks before submitting
- Never commit secrets or credentials
- Use environment variables for configuration
- Report security vulnerabilities privately

## Questions?

Feel free to open an issue for:
- Bug reports
- Feature requests
- Documentation improvements
- Questions about the project

## License

By contributing, you agree that your contributions will be licensed under the project's GPL-3.0 license.
