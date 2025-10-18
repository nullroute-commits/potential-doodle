# Configuration

## Environment Variables

### Database Configuration

Configure PostgreSQL connection:

- `POSTGRES_PASSWORD`: Database password (required)
- `POSTGRES_HOST`: Database host (default: `localhost`)
- `POSTGRES_PORT`: Database port (default: `5432`)

### Cache Configuration

Configure Redis/KeyDB connection:

- `REDIS_HOST`: Cache server host (default: `localhost`)
- `REDIS_PORT`: Cache server port (default: `6379`)

## Django Settings

### Database

The template uses PostgreSQL as the database backend. Configuration is in `src/app/settings.py`:

```python
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

### Cache

KeyDB (Redis-compatible) is used for caching:

```python
CACHES = {
    "default": {
        "BACKEND": "django.core.cache.backends.redis.RedisCache",
        "LOCATION": f"redis://{os.getenv('REDIS_HOST', 'localhost')}:{os.getenv('REDIS_PORT', '6379')}/1",
    }
}
```

## Docker Compose

The `docker-compose.yml` file orchestrates all services:

```yaml
services:
  db:        # PostgreSQL database
  cache:     # KeyDB cache
  web:       # Django application
```

## .env File

Create a `.env` file (not committed to version control) with your secrets:

```env
POSTGRES_PASSWORD=your_secure_password
POSTGRES_HOST=db
POSTGRES_PORT=5432
REDIS_HOST=cache
REDIS_PORT=6379
```
