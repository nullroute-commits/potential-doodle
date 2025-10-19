# potential-doodle

A Django application with a fully containerized CI/CD pipeline. All development, testing, linting, security scanning, and CI/CD steps run inside Docker/Podman containers. No external GitHub services (actions, runners, secrets) are required.

## Quick Start

```sh
# Run the complete CI pipeline
docker compose run --rm ci-builder

# Or start the development environment
docker compose up -d db cache app
```

## Features

- **Fully Containerized**: All CI/CD operations run in Docker containers
- **No External Dependencies**: No GitHub Actions or external runners needed
- **Multi-Stage Build**: Separate builder and runtime images for optimization
- **Security First**: Built-in security scanning with Bandit
- **Type Safety**: MyPy type checking included
- **Code Quality**: Pre-commit hooks with black, flake8, isort, pydocstyle
- **Production Ready**: Lightweight Alpine-based runtime image

## Documentation

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed usage instructions and architecture overview.

## License

See [LICENSE](LICENSE) for license information.
