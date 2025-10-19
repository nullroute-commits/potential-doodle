FROM python:3.11-alpine AS builder
WORKDIR /workspace

# Install build‑time system packages needed for compiled Python deps (psycopg2, etc.)
RUN apk add --no-cache gcc musl-dev libffi-dev postgresql-dev git

# Install Poetry and other tooling
RUN pip install --no-cache-dir poetry==1.5.1 pip-tools==7.3.0 pre-commit==3.5.0 bandit==1.7.5

# Copy project files (excluding .git which is ignored)
COPY pyproject.toml poetry.lock requirements.txt ./
COPY src ./src
COPY tests ./tests
COPY docs ./docs
COPY .pre-commit-config.yaml .

# Install dependencies (no virtualenv – we stay in the container)
RUN poetry config virtualenvs.create false && \
    poetry install --no-interaction --no-ansi

# Install pre‑commit hooks (they will be executed inside the container)
RUN pre-commit install || true

# Entry point defaults to a shell; CI scripts will override it
ENTRYPOINT ["/bin/sh"]
