# syntax=docker/dockerfile:1   # modern parser, comments ok

### ── build ─────────────────────────────────────────────
FROM caddy:2.9.1-builder-alpine AS builder   # 2 .9 .1 is last plugin-compatible tag
RUN xcaddy build \
  --with github.com/corazawaf/coraza-caddy@v2.0.0   # correct module path & tag

### ── runtime ──────────────────────────────────────────
FROM caddy:2.9.1-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# config
COPY Caddyfile /etc/caddy/Caddyfile
COPY coraza /etc/coraza
USER 1000:1000              # non-root; UID/GID optional
ENV PORT=8080
EXPOSE 8080
CMD ["caddy","run","--config","/etc/caddy/Caddyfile","--adapter","caddyfile"]
