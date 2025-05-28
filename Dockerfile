# syntax=docker/dockerfile:1       # optional, enables modern parser

# ---------- build stage ----------
FROM caddy:2.10-builder-alpine AS builder
RUN xcaddy build \
    --with github.com/corazawaf/coraza-caddy/v3@v3.0.0

# ---------- runtime ----------
FROM caddy:2.10-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
