# ---------- build stage ----------
FROM caddy:2.8-builder AS builder
RUN xcaddy build --with github.com/corazawaf/coraza-caddy/v2

# ---------- runtime ----------
FROM caddy:2.8-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY Caddyfile /etc/caddy/Caddyfile
CMD ["caddy","run","--config","/etc/caddy/Caddyfile","--adapter","caddyfile"]