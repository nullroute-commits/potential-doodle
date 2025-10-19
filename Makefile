.PHONY: help setup deps lint typecheck security test coverage build-docker run-docker clean all

help:
	@echo "Available targets:"
	@echo "  setup       - Setup Python environment with Poetry"
	@echo "  deps        - Install project dependencies"
	@echo "  lint        - Run code formatters and linters"
	@echo "  typecheck   - Run mypy type checking"
	@echo "  security    - Run bandit security scanning"
	@echo "  test        - Run test suite with pytest"
	@echo "  coverage    - Generate coverage reports"
	@echo "  build-docker - Build Docker images"
	@echo "  run-docker  - Start all services with Docker Compose"
	@echo "  clean       - Remove temporary files and caches"
	@echo "  all         - Run complete CI/CD pipeline"

setup:
	@echo "Setting up Python environment..."
	python3.11 -m venv .venv || python3 -m venv .venv
	.venv/bin/pip install --upgrade pip
	.venv/bin/pip install poetry==1.5.1

deps: setup
	@echo "Installing dependencies..."
	poetry install --no-interaction

lint:
	@echo "Running linters..."
	black --check src tests
	isort --check src tests
	flake8 src tests
	pylint src tests || true
	pydocstyle src || true

typecheck:
	@echo "Running type checks..."
	mypy src

security:
	@echo "Running security scan..."
	bandit -r src -ll

test:
	@echo "Running tests..."
	pytest tests -vv

coverage:
	@echo "Generating coverage report..."
	coverage run -m pytest tests
	coverage report
	coverage html
	coverage xml

build-docker:
	@echo "Building Docker images..."
	docker compose build

run-docker:
	@echo "Starting services..."
	docker compose up

clean:
	@echo "Cleaning up..."
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete
	find . -type d -name "*.egg-info" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".pytest_cache" -exec rm -rf {} + 2>/dev/null || true
	find . -type d -name ".mypy_cache" -exec rm -rf {} + 2>/dev/null || true
	rm -rf htmlcov .coverage coverage.xml

all: lint typecheck security test coverage
	@echo "✅ All checks passed!"
