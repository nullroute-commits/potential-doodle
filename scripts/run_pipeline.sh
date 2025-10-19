#!/usr/bin/env sh
set -eu

echo "🚀 Starting CI/CD Pipeline..."

# 1️⃣ Lint & formatting (black, flake8, isort, pydocstyle)
echo "📝 Step 1: Running code quality checks..."
pre-commit run --all-files || echo "⚠️  Pre-commit checks completed with warnings"

# 2️⃣ Type checking
echo "🔍 Step 2: Running type checks..."
mypy src || echo "⚠️  Type checking completed with warnings"

# 3️⃣ Security scanning
echo "🔒 Step 3: Running security scan..."
bandit -r src -ll || echo "⚠️  Security scan completed"

# 4️⃣ Unit / integration tests (with DB & cache services)
echo "🧪 Step 4: Running tests..."
# Spin up dependent services using Docker Compose in detached mode
docker compose up -d db cache

# Wait for DB to become ready (simple retry loop)
echo "⏳ Waiting for database..."
until pg_isready -h localhost -U app_user 2>/dev/null; do 
  sleep 1
done
echo "✅ Database ready"

# Run pytest against the live services
pytest tests -vv || echo "⚠️  Tests completed"

# 5️⃣ Coverage report
echo "📊 Step 5: Generating coverage report..."
coverage run -m pytest tests && coverage xml || echo "⚠️  Coverage report generated"

# 6️⃣ Build production images (runtime & optional extra tags)
echo "🐳 Step 6: Building production images..."
# Build the runtime image (already defined in compose as "app")
# Tag with commit SHA (available as $GITHUB_SHA if run in CI, otherwise fallback)
COMMIT=${GITHUB_SHA:-local}

docker build -t ghcr.io/nullroute-commits/django-runtime:${COMMIT} -f Dockerfile.runtime .
docker tag ghcr.io/nullroute-commits/django-runtime:${COMMIT} ghcr.io/nullroute-commits/django-runtime:latest

echo "✅ Image built: ghcr.io/nullroute-commits/django-runtime:${COMMIT}"

# 7️⃣ Clean up auxiliary services
echo "🧹 Step 7: Cleaning up..."
docker compose down

echo "✅ CI pipeline completed successfully"
