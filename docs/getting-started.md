# Getting Started

## Prerequisites

Before you begin, ensure you have the following installed:

- Python 3.11 or higher
- Poetry 1.5.1 or higher
- Git
- Docker or Podman (optional, for containerization)

## Installation

### 1. Clone the Repository

```bash
git clone https://github.com/<ORG>/<TEMPLATE_REPO>.git
cd <TEMPLATE_REPO>
```

### 2. Set Up Python Environment

```bash
make setup
```

This will:
- Create a Python 3.11 virtual environment
- Install pip, Poetry, and pip-tools

### 3. Install Dependencies

```bash
make deps
```

This installs all runtime and development dependencies using Poetry.

### 4. Create Django Project

For first-time setup, create the Django project structure:

```bash
. .venv/bin/activate
poetry install
poetry run django-admin startproject app src
```

### 5. Install Pre-commit Hooks

```bash
. .venv/bin/activate
pre-commit install
```

## Next Steps

- Configure your database settings in `src/app/settings.py`
- Run tests with `make test`
- Start development with `docker-compose up`
