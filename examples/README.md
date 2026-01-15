# ⚡ Mjolnir Examples

Example projects demonstrating how to use Mjolnir for building production-grade applications.

## Available Examples

| Language | Description | Path |
|----------|-------------|------|
| **Go** | Web API with GoReleaser + Distroless | [examples/go](./go/) |
| **Rust** | Web API with Actix-web + Distroless | [examples/rust](./rust/) |
| **TypeScript** | Web API with Bun + Distroless | [examples/typescript](./typescript/) |
| **Python** | Web API with FastAPI + Slim | [examples/python](./python/) |

## Quick Start

### Go Example

```bash
cd examples/go

# Run locally
task run

# Build Docker image
task docker:build

# Run container
task docker:run
```

## Using Mjolnir in GitHub Actions

```yaml
jobs:
  build:
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/inovacc/mjolnir:latest
    steps:
      - uses: actions/checkout@v4
      - run: task build:prod
```

## Contributing Examples

Want to add an example for another language? Create a new directory under `examples/` with:

1. A working build configuration
2. Dockerfile using Mjolnir as builder
3. README with setup instructions
4. Taskfile for common operations
