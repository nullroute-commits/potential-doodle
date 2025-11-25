"""Test configuration for pytest."""
import os

import django
from django.conf import settings

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "app.settings")


def pytest_configure() -> None:
    """Configure Django for pytest."""
    settings.DEBUG = False
    django.setup()
