# Mjolnir Example API - Rust

A minimal Rust web API demonstrating how to use [Mjolnir](https://github.com/inovacc/mjolnir) for building production-grade Docker images.

## Project Structure

```
rust/
├── src/main.rs          # Application entrypoint
├── Cargo.toml           # Rust dependencies
├── Dockerfile           # Multi-stage build (Mjolnir + distroless)
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

## Quick Start

### Run Locally

```bash
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

### Build Binary Only

```bash
task build
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
      - run: cargo build --release
```

## Docker Image Details

The Dockerfile uses a multi-stage build:

1. **Builder stage**: Uses `ghcr.io/inovacc/mjolnir` with Rust toolchain
2. **Production stage**: Uses `gcr.io/distroless/cc-debian12:nonroot`

Final image size: ~15MB
