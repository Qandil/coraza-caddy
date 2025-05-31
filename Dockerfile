############ 1. BUILD STAGE  ############
FROM caddy:2.10-builder AS builder

RUN xcaddy build \
    --with github.com/kirsch33/realip@v1.6.1 \
    --with github.com/corazawaf/coraza-caddy/v2@v2.0.0 \
    --with github.com/corazawaf/coraza-coreruleset/v4@v4.14.0 \
    --with github.com/mholt/caddy-ratelimit

############ 2. RUNTIME STAGE ############
FROM caddy:2.10-alpine

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY Caddyfile /etc/caddy/Caddyfile

ENV PORT 8080
EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --retries=3 CMD \
	curl -f http://localhost:${PORT}/health || exit 1

ENTRYPOINT ["caddy","run","--config","/etc/caddy/Caddyfile","--adapter","caddyfile"]
