# ============================================
# Stage 1: Builder - compile all Go tools
# ============================================
FROM golang:1.25 AS builder

ARG HTTP_PROXY=
ARG HTTPS_PROXY=
ENV http_proxy=${HTTP_PROXY}
ENV https_proxy=${HTTPS_PROXY}

# ---- pin versions ----
ARG SQLC_VERSION=1.27.0
ARG TASK_VERSION=3.39.2
ARG GORELEASER_VERSION=2.6.1
ARG PROTOC_VERSION=33.4
ARG PROTOC_GEN_GO_VERSION=1.28.0
ARG PROTOC_GEN_GO_GRPC_VERSION=1.2.0

# Copy and build taggen
COPY scripts/taggen /tmp/taggen
WORKDIR /tmp/taggen
RUN go build -o /usr/local/bin/taggen .

# Install Go tools
WORKDIR /go

RUN go install github.com/sqlc-dev/sqlc/cmd/sqlc@v${SQLC_VERSION} \
 && go install github.com/go-task/task/v3/cmd/task@v${TASK_VERSION} \
 && go install github.com/goreleaser/goreleaser/v2@v${GORELEASER_VERSION} \
 && go install google.golang.org/protobuf/cmd/protoc-gen-go@v${PROTOC_GEN_GO_VERSION} \
 && go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v${PROTOC_GEN_GO_GRPC_VERSION}

# Download and extract protoc
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends curl unzip \
 && PROTOC_ZIP="protoc-${PROTOC_VERSION}-linux-x86_64.zip" \
 && curl -fL -o "${PROTOC_ZIP}" "https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/${PROTOC_ZIP}" \
 && unzip -o "${PROTOC_ZIP}" -d /usr/local bin/protoc \
 && unzip -o "${PROTOC_ZIP}" -d /usr/local 'include/*' \
 && rm -f "${PROTOC_ZIP}" \
 && rm -rf /var/lib/apt/lists/*

# Generate tag metadata
RUN taggen > /tmp/BUILD_TAG \
 && taggen --version > /tmp/GO_VERSION \
 && taggen --name > /tmp/BUILD_NAME

# ============================================
# Stage 2: Final - minimal runtime image
# ============================================
FROM golang:1.25

ARG HTTP_PROXY=
ARG HTTPS_PROXY=
ENV http_proxy=${HTTP_PROXY}
ENV https_proxy=${HTTPS_PROXY}

WORKDIR /workspace

# Install only runtime dependencies
# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates bash make \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /var/cache/apt/*

# Copy compiled tools from builder
COPY --from=builder /go/bin/* /go/bin/
COPY --from=builder /usr/local/bin/protoc /usr/local/bin/protoc
COPY --from=builder /usr/local/include/google /usr/local/include/google

# Copy build metadata
COPY --from=builder /tmp/BUILD_TAG /etc/go-toolbox/BUILD_TAG
COPY --from=builder /tmp/GO_VERSION /etc/go-toolbox/GO_VERSION
COPY --from=builder /tmp/BUILD_NAME /etc/go-toolbox/BUILD_NAME

ENV PATH="/go/bin:${PATH}"

# Labels with build metadata
LABEL org.opencontainers.image.title="go-toolbox" \
      org.opencontainers.image.description="GitHub Actions job-container for building Go binaries" \
      org.opencontainers.image.source="https://github.com/inovacc/go-toolbox" \
      org.opencontainers.image.vendor="inovacc"

# Verify tools
CMD ["bash", "-c", "echo \"Build: $(cat /etc/go-toolbox/BUILD_TAG)\" && go version && task --version && sqlc version && goreleaser --version && protoc --version && protoc-gen-go --version && protoc-gen-go-grpc --version"]
