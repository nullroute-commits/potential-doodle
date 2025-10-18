# Getting Started

This guide will help you set up the Django CI/CD template on your local machine.

## Prerequisites

Before you begin, ensure you have the following installed:

- Python 3.11 or higher
- Poetry 1.5.1 or higher
- Docker or Podman
- Git

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/<ORG>/<TEMPLATE_REPO>.git
cd <TEMPLATE_REPO>
```

### 2. Set Up Python Environment

```bash
make setup
```

This command will:
- Create a Python 3.11 virtual environment
- Upgrade pip
- Install Poetry and pip-tools

### 3. Install Dependencies

```bash
make deps
```

This will install all runtime and development dependencies using Poetry.

### 4. Create Django Project

If the Django project hasn't been created yet:

```bash
. .venv/bin/activate
poetry run django-admin startproject app src
```

### 5. Configure Environment Variables

```bash
cp .env.example .env
```

Edit the `.env` file with your configuration. Important variables:
- `SECRET_KEY`: Django secret key
- `POSTGRES_PASSWORD`: Database password
- `DEBUG`: Set to `False` in production

### 6. Install Pre-commit Hooks

```bash
. .venv/bin/activate
pre-commit install
```

## Verify Installation

Run the test suite to verify everything is working:

```bash
make test
```

## Next Steps

- Read the [Development Guide](development.md) to learn about the development workflow
- Check out [Container Configuration](containers.md) to understand the container setup
- See [Deployment Guide](deployment.md) for production deployment instructions
