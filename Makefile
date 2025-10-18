# ------------------------------------------------------------
# Project-wide Makefile – orchestrates all tasks for the agentic bot
# ------------------------------------------------------------

.PHONY: all setup deps lint typecheck security test coverage build-docker build-podman build-lxc docs clean release

# Default target
all: setup deps lint typecheck security test build-docker build-podman docs

# -----------------------------------------------------------------
# Environment preparation
# -----------------------------------------------------------------
setup:
	@echo "🔧 Setting up Python virtual environment…"
	python3.11 -m venv .venv
	. .venv/bin/activate && pip install --upgrade pip
	. .venv/bin/activate && pip install poetry==1.5.1 pip-tools==7.3.0

deps: ## Install runtime & dev dependencies via Poetry
	@echo "📦 Installing dependencies…"
	. .venv/bin/activate && poetry install

# -----------------------------------------------------------------
# Code quality
# -----------------------------------------------------------------
lint:
	@echo "🧹 Running formatters & linters…"
	. .venv/bin/activate && pre-commit run --all-files

typecheck:
	@echo "🔎 Running mypy type checks…"
	. .venv/bin/activate && mypy src

security:
	@echo "🔐 Scanning for security issues…"
	. .venv/bin/activate && bandit -r src -ll

# -----------------------------------------------------------------
# Tests
# -----------------------------------------------------------------
test:
	@echo "✅ Executing test suite…"
	. .venv/bin/activate && pytest tests -vv

coverage:
	@echo "📈 Generating coverage report…"
	. .venv/bin/activate && coverage run -m pytest tests && coverage html

# -----------------------------------------------------------------
# Container builds (Alpine based)
# -----------------------------------------------------------------
build-docker:
	@echo "🐳 Building Docker image (Alpine)…"
	docker build -t ghcr.io/<ORG>/django-template:$(shell git rev-parse --short HEAD) -f containers/Dockerfile .

build-podman:
	@echo "🚢 Building Podman image (Alpine)…"
	podman build -t ghcr.io/<ORG>/django-template:$(shell git rev-parse --short HEAD)-podman -f containers/Podmanfile .

build-lxc:
	@echo "🖥️ Creating LXC container from Alpine image…"
	lxc launch images:alpine/3.18 django-template-lxc -c security.nesting=true

# -----------------------------------------------------------------
# Documentation
# -----------------------------------------------------------------
docs:
	@echo "📚 Building Sphinx documentation…"
	. .venv/bin/activate && sphinx-build -b html docs docs/_build/html

# -----------------------------------------------------------------
# Cleanup
# -----------------------------------------------------------------
clean:
	@echo "🧽 Cleaning temporary artifacts…"
	rm -rf .venv *.egg-info build dist htmlcov .coverage
	rm -rf docs/_build

# -----------------------------------------------------------------
# Release
# -----------------------------------------------------------------
release:
	@echo "🚀 Tagging and publishing release…"
	git tag -a v1.0.0 -m "Initial release"
	git push origin v1.0.0
	# Push Docker image
	docker push ghcr.io/<ORG>/django-template:$(shell git rev-parse --short HEAD)
	# Push Podman image (same registry works for both)
	podman push ghcr.io/<ORG>/django-template:$(shell git rev-parse --short HEAD)-podman
