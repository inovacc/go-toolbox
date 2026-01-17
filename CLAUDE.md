# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Mjolnir** - "The hammer for every build"

A multi-language CI container image for building production-grade applications. Provides Go, Rust, Node.js, Python, and essential build tools in a single image.

Repository: `ghcr.io/inovacc/mjolnir`

## Image Variants

| Variant | Base | Use Case |
|---------|------|----------|
| **Debian** (default) | `golang:1.25` | Full-featured, wider compatibility |
| **Alpine** | `golang:1.25-alpine` | Smaller image, musl libc |

## Tagging Scheme

```
ghcr.io/inovacc/mjolnir:1.6.8          # Default (Debian)
ghcr.io/inovacc/mjolnir:1.6.8-debian   # Explicit Debian
ghcr.io/inovacc/mjolnir:1.6.8-alpine   # Alpine variant
ghcr.io/inovacc/mjolnir:latest         # Latest Debian
ghcr.io/inovacc/mjolnir:latest-alpine  # Latest Alpine
```

## Included Tools

### Languages & Runtimes
| Tool | Description |
|------|-------------|
| Go 1.25 | Go compiler and tools |
| Rust (stable) | rustc, cargo |
| Node.js | Node.js runtime |
| Python 3 | Python interpreter |
| Bun | Fast JavaScript runtime |

### Package Managers
| Tool | Description |
|------|-------------|
| npm | Node.js package manager |
| npx | npm package runner |
| pnpm | Fast, disk space efficient package manager |
| pip3 | Python package manager |
| cargo | Rust package manager |

### Build Tools
| Tool | Description |
|------|-------------|
| Task | Task runner (Taskfile.yml) |
| Make | Build automation |
| GCC | C compiler |
| GoReleaser | Go release automation |
| tsc | TypeScript compiler |

### Code Generation
| Tool | Description |
|------|-------------|
| sqlc | Type-safe SQL code generator |
| protoc | Protocol Buffer compiler |
| protoc-gen-go | Go protobuf generator |
| protoc-gen-go-grpc | Go gRPC generator |

### Containers & Linting
| Tool | Description |
|------|-------------|
| Docker CLI | Docker command-line tool |
| hadolint | Dockerfile linter |

### Data Processing
| Tool | Description |
|------|-------------|
| jq | JSON processor |
| yq | YAML processor |

### Utilities
| Tool | Description |
|------|-------------|
| git | Version control |
| curl | HTTP client |
| unzip | Archive extraction |
| bash | Shell |

## Build Metadata

Each image generates mythology-themed build metadata at `/etc/mjolnir/`:

```
/etc/mjolnir/BUILD_TAG      # e.g., "1.25D-thor-asgard"
/etc/mjolnir/BUILD_NAME     # e.g., "thor-asgard"
/etc/mjolnir/GO_VERSION     # e.g., "1.25"
/etc/mjolnir/BUILD_VERSION  # e.g., "1.6.8"
```

## CI/CD Pipeline

### Workflow Files
- `.github/workflows/ci.yml` - Main CI (lint → build → security → release)
- `.github/workflows/scheduled-build.yml` - Bi-weekly rebuilds

### CI Flow
```
lint → build-debian ─┬─→ security → release
    └→ build-alpine ─┘
```

### Triggers
- **Tags (`v*`)**: Full pipeline with release to GHCR
- **Pull Requests**: Lint, build, security scan (no push)
- **Scheduled**: Bi-weekly rebuilds (1st and 15th)

## Example Projects

Located in `examples/` directory:

| Language | Framework | Path |
|----------|-----------|------|
| Go | GoReleaser + Cobra | `examples/go/` |
| Rust | Actix-web | `examples/rust/` |
| TypeScript | Bun | `examples/typescript/` |
| Python | FastAPI | `examples/python/` |

## Usage in GitHub Actions

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

## Key Files

| File | Purpose |
|------|---------|
| `Dockerfile.debian` | Debian-based image |
| `Dockerfile.alpine` | Alpine-based image |
| `scripts/taggen.sh` | Local tag generation script |
| `Taskfile.yml` | Local build tasks |

## Release Process

```bash
git tag v1.6.9
git push origin v1.6.9
```

This triggers the CI workflow which:
1. Lints Dockerfiles
2. Builds both Debian and Alpine images
3. Runs security scan (Trivy)
4. Pushes to GHCR with version tags
