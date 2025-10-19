# Tests

This directory contains the test suite for the Django application.

## Running Tests

```bash
# Run all tests
make test

# Run with coverage
make coverage

# Run specific test file
pytest tests/test_example.py

# Run with verbose output
pytest tests -vv
```

## Test Structure

- `test_*.py` - Test files
- `conftest.py` - Shared fixtures and configuration

## Writing Tests

Use pytest and pytest-django for testing:

```python
import pytest
from django.test import Client


def test_example():
    """Example test case."""
    assert True


@pytest.mark.django_db
def test_with_database():
    """Test that requires database access."""
    # Your test code here
    pass
```

## Coverage

Coverage reports are generated in:
- Terminal output
- `htmlcov/index.html` (HTML report)
- `coverage.xml` (XML report for CI)

Target: Maintain >80% test coverage
