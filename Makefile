# ------------------------------------------------------------
# Orchestrates the same steps as the containerized pipeline but
# can be invoked locally (outside of Docker) for quick iteration.
# ------------------------------------------------------------

.PHONY: all lint typecheck security test coverage build-runtime publish

all: lint typecheck security test coverage build-runtime

lint:
	pre-commit run --all-files

typecheck:
	mypy src

security:
	bandit -r src -ll

test:
	# Bring up DB & cache for integration tests
	docker compose up -d db cache
	@echo "Waiting for database to be ready..."
	@until docker compose exec -T db pg_isready -U app_user; do sleep 1; done
	pytest tests -vv
	docker compose down

coverage:
	coverage run -m pytest tests && coverage xml

build-runtime:
	docker build -t ghcr.io/nullroute-commits/django-runtime:$$(git rev-parse --short HEAD 2>/dev/null || echo "local") -f Dockerfile.runtime .

publish:
	./scripts/publish_images.sh
