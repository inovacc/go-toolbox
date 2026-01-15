# Mjolnir Example API - TypeScript

A minimal TypeScript web API using Bun, demonstrating how to use [Mjolnir](https://github.com/inovacc/mjolnir) for building production-grade Docker images.

## Project Structure

```
typescript/
├── src/index.ts         # Application entrypoint
├── package.json         # Dependencies
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
# Install dependencies
task install

# Run with hot reload
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

### Build Standalone Binary

```bash
task build
# Output: dist/server
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
      - run: bun install
      - run: bun build src/index.ts --compile --outfile dist/server
```

## Docker Image Details

The Dockerfile uses a multi-stage build:

1. **Builder stage**: Uses `ghcr.io/inovacc/mjolnir` with Bun
2. **Production stage**: Uses `gcr.io/distroless/base-debian12:nonroot`

Final image size: ~50MB (Bun compiled binary)

## Why Bun?

- **Fast**: Bun is significantly faster than Node.js
- **Built-in TypeScript**: No transpilation needed
- **Single binary**: `bun build --compile` creates standalone executable
- **Included in Mjolnir**: No additional setup required
