# ---------- runtime ----------
FROM caddy:2.8-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# NEW – grab the wrapper from the repo’s current location
ADD https://raw.githubusercontent.com/corazawaf/coraza-caddy/main/docker/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

COPY Caddyfile /etc/caddy/Caddyfile
ENTRYPOINT ["/docker-entrypoint.sh"]
