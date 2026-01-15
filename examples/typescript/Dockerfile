# Build stage using Mjolnir
FROM ghcr.io/inovacc/mjolnir:latest AS builder

WORKDIR /src
COPY package.json bun.lock* ./
RUN bun install --frozen-lockfile || bun install

COPY src ./src
RUN bun build src/index.ts --compile --outfile dist/server

# Production stage
FROM gcr.io/distroless/base-debian12:nonroot

COPY --from=builder /src/dist/server /app

USER nonroot:nonroot
EXPOSE 8080

ENTRYPOINT ["/app"]
