# Source Code Directory

This directory contains the Django application source code.

## Creating the Django Project

To create a new Django project, run:

```bash
. .venv/bin/activate
poetry run django-admin startproject app src
```

This will create the following structure:

```
src/
├── __init__.py
├── app/
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   ├── wsgi.py
│   └── asgi.py
└── manage.py
```

## Configuring Database and Cache

After creating the project, you'll need to modify `src/app/settings.py` to configure PostgreSQL and Redis/KeyDB.

### Database Configuration

Replace the DATABASES section with:

```python
import os

DATABASES = {
    "default": {
        "ENGINE": "django.db.backends.postgresql",
        "NAME": "app_db",
        "USER": "app_user",
        "PASSWORD": os.getenv("POSTGRES_PASSWORD"),
        "HOST": os.getenv("POSTGRES_HOST", "localhost"),
        "PORT": os.getenv("POSTGRES_PORT", "5432"),
    }
}
```

### Cache Configuration

Add the following CACHES configuration:

```python
CACHES = {
    "default": {
        "BACKEND": "django.core.cache.backends.redis.RedisCache",
        "LOCATION": f"redis://{os.getenv('REDIS_HOST', 'localhost')}:{os.getenv('REDIS_PORT', '6379')}/1",
    }
}
```

## Running Migrations

After configuration, run:

```bash
python src/manage.py migrate
```

## Creating a Superuser

```bash
python src/manage.py createsuperuser
```

## Running the Development Server

```bash
python src/manage.py runserver
```
