FROM python:3.11-alpine AS builder
WORKDIR /app

# Install build‑time dependencies (gcc, musl-dev, libffi-dev) needed for psycopg2
RUN apk add --no-cache gcc musl-dev libffi-dev postgresql-dev

# Copy poetry config and install dependencies without creating a virtualenv
COPY pyproject.toml poetry.lock ./
RUN pip install --no-cache-dir poetry==1.5.1 && \
    poetry config virtualenvs.create false && \
    poetry install --no-dev --no-interaction --no-ansi

# Copy source code and pre‑compile bytecode
COPY . /app
RUN python -m compileall .

# Runtime stage – minimal Alpine image
FROM python:3.11-alpine
WORKDIR /app
COPY --from=builder /usr/local/lib/python3.11/site-packages /usr/local/lib/python3.11/site-packages
COPY --from=builder /app /app
ENV PYTHONUNBUFFERED=1
CMD ["gunicorn", "app.wsgi:application", "--bind", "0.0.0.0:8000"]
