############ 1. BUILD STAGE ############
#  ▸ Pull the official “builder” flavour of Caddy 2.10 (includes xcaddy)
#    Tag list: hub.docker.com/_/caddy → 2.10.0-builder-alpine :contentReference[oaicite:0]{index=0}
FROM caddy:2.10.0-builder-alpine AS builder

#  ▸ Compile Caddy with the Coraza WAF plugin + Core Rule Set wrapper
#    Plugin repo & tag: github.com/corazawaf/coraza-caddy/v2@v2.0.0-rc.3 :contentReference[oaicite:1]{index=1}
RUN xcaddy build \
    --with github.com/corazawaf/coraza-caddy/v2@v2.0.0-rc.3 \
    --with github.com/corazawaf/coraza-coreruleset@v0.4.5

############ 2. RUNTIME STAGE ############
#  ▸ Use the slim Alpine runtime image
FROM caddy:2.10.0-alpine

#  ▸ Copy the custom Caddy binary we just built
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

#  ▸ Copy our Caddyfile (lives next to this Dockerfile in git)
COPY Caddyfile /etc/caddy/Caddyfile

#  ▸ Standard Railway convention: expose a single dynamic port
ENV PORT 8080
EXPOSE 8080

#  ▸ Simple liveness endpoint so Railway’s health-check passes
HEALTHCHECK --interval=30s --timeout=3s CMD \
  wget -qO- http://localhost:${PORT}/health || exit 1

ENTRYPOINT ["caddy","run","--config","/etc/caddy/Caddyfile","--adapter","caddyfile"]
