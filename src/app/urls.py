"""
URL configuration for app project.
"""

from django.contrib import admin
from django.http import HttpResponse
from django.urls import path


def health_check(request):
    """Health check endpoint."""
    return HttpResponse("OK")


urlpatterns = [
    path("admin/", admin.site.urls),
    path("health/", health_check, name="health"),
]
