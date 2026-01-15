# Build stage using Mjolnir
FROM ghcr.io/inovacc/mjolnir:latest AS builder

WORKDIR /src
COPY Cargo.toml Cargo.lock* ./
COPY src ./src

RUN cargo build --release

# Production stage using distroless
FROM gcr.io/distroless/cc-debian12:nonroot

COPY --from=builder /src/target/release/mjolnir-example /app

USER nonroot:nonroot
EXPOSE 8080

ENTRYPOINT ["/app"]
