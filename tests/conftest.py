"""Pytest configuration and fixtures."""
import pytest


@pytest.fixture
def example_fixture():
    """Example fixture."""
    return "test_data"
