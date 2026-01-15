# Build stage using Mjolnir
FROM ghcr.io/inovacc/mjolnir:latest AS builder

WORKDIR /src
COPY requirements.txt .
RUN pip install --no-cache-dir --target=/deps -r requirements.txt

COPY main.py .

# Production stage
FROM python:3.13-slim

WORKDIR /app

# Copy dependencies and application
COPY --from=builder /deps /usr/local/lib/python3.13/site-packages
COPY --from=builder /src/main.py .

# Create non-root user
RUN useradd -r -u 1000 nonroot
USER nonroot

EXPOSE 8080

CMD ["python", "main.py"]
