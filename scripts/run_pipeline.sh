#!/usr/bin/env sh
set -eu

# 1️⃣ Lint & formatting (black, flake8, isort, pydocstyle)
pre-commit run --all-files

# 2️⃣ Type checking
mypy src

# 3️⃣ Security scanning
bandit -r src -ll

# 4️⃣ Unit / integration tests (with DB & cache services)
# Spin up dependent services using Docker Compose in detached mode
docker compose up -d db cache
# Wait for DB to become ready (simple retry loop)
until pg_isready -h localhost -U app_user; do sleep 1; done
# Run pytest against the live services
pytest tests -vv

# 5️⃣ Coverage report
coverage run -m pytest tests && coverage xml

# 6️⃣ Build production images (runtime & optional extra tags)
# Build the runtime image (already defined in compose as "app")
# Tag with commit SHA (available as $GITHUB_SHA if run in CI, otherwise fallback)
COMMIT=${GITHUB_SHA:-local}

docker build -t ghcr.io/nullroute-commits/django-runtime:${COMMIT} -f Dockerfile.runtime .

docker push ghcr.io/nullroute-commits/django-runtime:${COMMIT}

# 7️⃣ Clean up auxiliary services
docker compose down

echo "✅ CI pipeline completed successfully"
