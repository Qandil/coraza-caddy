# syntax=docker/dockerfile:1
# 1. Use the official Caddy image that already bundles the Coraza WAF module
FROM ghcr.io/coreruleset/coraza-caddy:2.10.0

# 2. Copy in our Caddyfile
COPY Caddyfile /etc/caddy/Caddyfile

# 3. Expose the port Railway will assign (8080 is conventional)
ENV PORT=8080
EXPOSE 8080

# 4. Health-check for Railway’s deployment UI
HEALTHCHECK --interval=30s --timeout=3s CMD \
  wget -qO- http://localhost:${PORT}/health || exit 1

# 5. Start Caddy
ENTRYPOINT [ "caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile" ]
