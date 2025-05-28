# ---------- build stage ----------
FROM caddy:2.8-builder AS builder
RUN xcaddy build --with github.com/corazawaf/coraza-caddy/v2

# ---------- runtime ----------
FROM caddy:2.8-alpine

# Copy the freshly-built Caddy binary
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# Copy the Coraza bootstrap script from source (saves you from pulling the image)
ADD https://raw.githubusercontent.com/corazawaf/coraza-caddy/v2/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Your Caddyfile
COPY Caddyfile /etc/caddy/Caddyfile

ENTRYPOINT ["/docker-entrypoint.sh"]
