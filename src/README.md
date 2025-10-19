# Django Application Structure

This directory will contain the Django application source code.

## Setup

To create a new Django project:

```bash
# Activate virtual environment
poetry shell

# Create Django project
django-admin startproject app .
```

## Database Configuration

The Django settings should be configured to use PostgreSQL and Redis:

```python
# In app/settings.py

import os

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'app_db',
        'USER': 'app_user',
        'PASSWORD': os.getenv('POSTGRES_PASSWORD', 'secret'),
        'HOST': os.getenv('POSTGRES_HOST', 'localhost'),
        'PORT': os.getenv('POSTGRES_PORT', '5432'),
    }
}

CACHES = {
    'default': {
        'BACKEND': 'django.core.cache.backends.redis.RedisCache',
        'LOCATION': f"redis://{os.getenv('REDIS_HOST', 'localhost')}:{os.getenv('REDIS_PORT', '6379')}/1",
    }
}
```

## Running the Application

```bash
# Run migrations
python manage.py migrate

# Create superuser
python manage.py createsuperuser

# Run development server
python manage.py runserver

# Or use docker-compose
docker compose up app
```
