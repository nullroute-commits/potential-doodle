"""Basic tests for Django application."""
import pytest
from django.test import Client


@pytest.fixture
def client() -> Client:
    """Return a Django test client."""
    return Client()


def test_health_check(client: Client) -> None:
    """Test the health check endpoint."""
    response = client.get("/health/")
    assert response.status_code == 200
    assert response.content == b"OK"


def test_admin_accessible(client: Client) -> None:
    """Test that admin page is accessible."""
    response = client.get("/admin/")
    assert response.status_code in (200, 302)  # 302 for redirect to login
