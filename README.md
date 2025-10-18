# Django CI/CD Template Repository

**Enterprise-grade CI/CD template for Django applications with PostgreSQL and KeyDB (Redis-compatible) using Alpine Linux containers**

This repository provides a complete, production-ready scaffolding for Django applications with:
- ✅ **Alpine-based containers** for minimal image sizes
- ✅ **Multi-stage Docker builds** for optimized production images
- ✅ **PostgreSQL 15** database backend
- ✅ **KeyDB** (Redis-compatible) for caching
- ✅ **Comprehensive code quality tools** (Black, Flake8, Pylint, MyPy, Bandit)
- ✅ **Pre-commit hooks** for automated code quality checks
- ✅ **Poetry** for dependency management
- ✅ **Docker, Podman, and LXC** support
- ✅ **Makefile** for easy orchestration
- ✅ **CI/CD scripts** for automation

## 📋 Table of Contents

- [Quick Start](#quick-start)
- [Repository Structure](#repository-structure)
- [Prerequisites](#prerequisites)
- [Setup Instructions](#setup-instructions)
- [Usage](#usage)
- [Container Builds](#container-builds)
- [Configuration](#configuration)
- [Development Workflow](#development-workflow)
- [CI/CD Integration](#cicd-integration)
- [Contributing](#contributing)
- [License](#license)

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/<ORG>/<TEMPLATE_REPO>.git
cd <TEMPLATE_REPO>

# Set up Python environment and dependencies
make setup
make deps

# Create Django project (if not already created)
. .venv/bin/activate && poetry run django-admin startproject app src

# Run all quality checks and tests
make lint typecheck security test

# Start the development environment
docker-compose up
```

## 📁 Repository Structure

```
.
├── src/                    # Django application source code
├── tests/                  # Test suite
├── containers/             # Container definitions (Alpine-based)
│   ├── Dockerfile         # Multi-stage Docker build
│   ├── Podmanfile         # Podman build definition
│   └── lxc-config.yaml    # LXC container configuration
├── scripts/                # Automation scripts
│   ├── run_all.sh         # Execute full CI/CD pipeline
│   └── publish_images.sh  # Publish container images to registry
├── docs/                   # Documentation (Sphinx)
├── .github/                # GitHub Actions workflows (to be added)
├── pyproject.toml          # Poetry configuration and dependencies
├── requirements.txt        # Exported requirements
├── .pre-commit-config.yaml # Pre-commit hooks configuration
├── docker-compose.yml      # Multi-container orchestration
├── Makefile               # Task orchestration
├── .env.example           # Environment variables template
├── CONTRIBUTING.md        # Contribution guidelines
└── README.md              # This file
```

## 📦 Prerequisites

### Required Software

- **Python 3.11+**
- **Poetry 1.5.1+** (for dependency management)
- **Docker** or **Podman** (for container builds)
- **Git** (for version control)

### Optional Software

- **LXC/LXD** (for LXC container support)
- **Make** (for task orchestration; scripts can be run directly if make is unavailable)

### System Dependencies

For building psycopg2 (PostgreSQL adapter), you'll need:
- `gcc`
- `musl-dev`
- `libffi-dev`
- `postgresql-dev`

These are automatically installed in the Alpine-based container builds.

## 🛠️ Setup Instructions

### 1. Environment Setup

```bash
# Create and activate Python virtual environment
make setup

# Install all dependencies (runtime + development)
make deps
```

### 2. Create Django Project

```bash
# Activate virtual environment
. .venv/bin/activate

# Create Django project in src/ directory
poetry run django-admin startproject app src
```

### 3. Configure Environment Variables

```bash
# Copy example environment file
cp .env.example .env

# Edit .env with your configuration
# Important: Change SECRET_KEY and POSTGRES_PASSWORD in production!
```

### 4. Install Pre-commit Hooks

```bash
# Activate virtual environment
. .venv/bin/activate

# Install pre-commit hooks
pre-commit install

# Run hooks on all files (optional, to test setup)
pre-commit run --all-files
```

## 🎯 Usage

### Development Commands

#### Code Quality

```bash
# Run all formatters and linters
make lint

# Run type checking
make typecheck

# Run security scanning
make security
```

#### Testing

```bash
# Run test suite
make test

# Generate coverage report
make coverage
```

#### Container Operations

```bash
# Build Docker image
make build-docker

# Build Podman image
make build-podman

# Create LXC container
make build-lxc
```

#### Documentation

```bash
# Build Sphinx documentation
make docs
```

#### Cleanup

```bash
# Remove build artifacts and virtual environment
make clean
```

### Running the Application

#### Using Docker Compose (Recommended)

```bash
# Start all services (database, cache, web)
docker-compose up

# Run in detached mode
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down
```

#### Manual Django Development Server

```bash
# Activate virtual environment
. .venv/bin/activate

# Run migrations
python src/manage.py migrate

# Create superuser
python src/manage.py createsuperuser

# Run development server
python src/manage.py runserver
```

## 🐳 Container Builds

All container images are based on **official Alpine Linux** variants to minimize size.

### Docker

```bash
# Build image
docker build -t django-template:latest -f containers/Dockerfile .

# Run container
docker run -p 8000:8000 django-template:latest
```

### Podman

```bash
# Build image
podman build -t django-template:latest -f containers/Podmanfile .

# Run container
podman run -p 8000:8000 django-template:latest
```

### LXC

```bash
# Launch container from configuration
lxc init images:alpine/3.18 django-template-lxc
lxc config set django-template-lxc security.nesting true
lxc start django-template-lxc
```

## ⚙️ Configuration

### Django Settings

Key configurations in `src/app/settings.py`:

- **Database**: PostgreSQL with environment variable support
- **Caching**: Redis/KeyDB backend
- **Static files**: Configured for production use
- **Security**: SECRET_KEY from environment variable

### Database Configuration

PostgreSQL is configured via environment variables:

- `POSTGRES_DB`: Database name (default: `app_db`)
- `POSTGRES_USER`: Database user (default: `app_user`)
- `POSTGRES_PASSWORD`: Database password (required)
- `POSTGRES_HOST`: Database host (default: `localhost`, `db` in Docker)
- `POSTGRES_PORT`: Database port (default: `5432`)

### Cache Configuration

KeyDB (Redis-compatible) is configured via:

- `REDIS_HOST`: Redis host (default: `localhost`, `cache` in Docker)
- `REDIS_PORT`: Redis port (default: `6379`)

## 💻 Development Workflow

1. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature
   ```

2. **Make your changes**
   - Edit source code in `src/`
   - Add tests in `tests/`

3. **Run quality checks**
   ```bash
   make lint typecheck security test
   ```

4. **Commit your changes**
   - Pre-commit hooks will automatically run
   - Fix any issues reported by the hooks

5. **Push and create pull request**
   ```bash
   git push origin feature/your-feature
   ```

## 🔄 CI/CD Integration

### Automated Script Execution

The `scripts/run_all.sh` script executes the complete CI/CD pipeline:

```bash
./scripts/run_all.sh
```

This runs:
1. Environment setup
2. Dependency installation
3. Linting and formatting
4. Type checking
5. Security scanning
6. Test suite
7. Coverage analysis
8. Docker image build
9. Podman image build
10. Documentation generation

### Publishing Container Images

```bash
# Build and publish images to container registry
./scripts/publish_images.sh
```

**Note**: Update `<ORG>` placeholder in scripts and Makefile with your GitHub organization or username.

### GitHub Actions

Add a `.github/workflows/ci.yml` file to enable automated CI/CD on GitHub:

```yaml
name: CI/CD Pipeline

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      - name: Run CI pipeline
        run: ./scripts/run_all.sh
```

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

### Code Quality Standards

This project enforces strict code quality:
- **Black** (code formatting)
- **isort** (import sorting)
- **Flake8** (linting)
- **Pylint** (additional linting)
- **pydocstyle** (docstring style)
- **MyPy** (type checking)
- **Bandit** (security scanning)

All checks run automatically via pre-commit hooks.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built with [Django](https://www.djangoproject.com/) - The web framework for perfectionists with deadlines
- Uses [Poetry](https://python-poetry.org/) for dependency management
- Container images based on [Alpine Linux](https://alpinelinux.org/) for minimal size
- [KeyDB](https://keydb.dev/) for high-performance caching
- [PostgreSQL](https://www.postgresql.org/) for robust database support

## 📞 Support

For questions, issues, or suggestions:
- Open an issue on GitHub
- Refer to [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines

---

**Happy coding! 🚀**
