"""Basic tests for the Django application."""

import pytest
from django.test import Client


@pytest.mark.django_db
def test_health_check() -> None:
    """Test that the health check endpoint works."""
    client = Client()
    response = client.get("/health/")
    assert response.status_code == 200
    assert response.content == b"OK"


def test_basic_import() -> None:
    """Test that basic Django imports work."""
    from django.conf import settings

    assert settings.DATABASES is not None
