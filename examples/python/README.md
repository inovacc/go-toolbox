# Mjolnir Example API - Python

A minimal Python web API using FastAPI, demonstrating how to use [Mjolnir](https://github.com/inovacc/mjolnir) for building production-grade Docker images.

## Project Structure

```
python/
├── main.py              # Application entrypoint
├── requirements.txt     # Dependencies
├── Dockerfile           # Multi-stage build (Mjolnir + slim)
├── Taskfile.yml         # Build automation
└── README.md
```

## API Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | `/` | Root endpoint |
| GET | `/health` | Health check with version info |
| GET | `/api/hello` | Hello World |
| GET | `/api/hello/{name}` | Personalized greeting |
| GET | `/docs` | OpenAPI documentation |

## Quick Start

### Run Locally

```bash
# Install dependencies
task install

# Run with auto-reload
task dev

# Or run directly
task run
```

### Build with Docker

```bash
# Build image
task docker:build

# Run container
task docker:run

# Test endpoints
curl http://localhost:8080/health
curl http://localhost:8080/api/hello/World
```

## Using in GitHub Actions

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/inovacc/mjolnir:latest
    steps:
      - uses: actions/checkout@v4
      - run: pip install -r requirements.txt
      - run: python -m pytest
```

## Docker Image Details

The Dockerfile uses a multi-stage build:

1. **Builder stage**: Uses `ghcr.io/inovacc/mjolnir` with Python to install deps
2. **Production stage**: Uses `python:3.13-slim`

Final image size: ~150MB

## Why FastAPI?

- **Fast**: High performance, on par with NodeJS and Go
- **Easy**: Designed to be easy to use and learn
- **OpenAPI**: Automatic API documentation
- **Type hints**: Built-in validation with Pydantic
