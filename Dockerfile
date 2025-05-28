# ---------- build stage ----------
FROM caddy:2.10-builder-alpine AS builder   # latest stable Caddy 2.10
RUN xcaddy build \
	--with github.com/corazawaf/coraza-caddy/v3@v3.0.0

# ---------- runtime ----------
FROM caddy:2.10-alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# config
COPY Caddyfile /etc/caddy/Caddyfile
COPY coraza /etc/coraza

# drop root
RUN addgroup -S caddy && adduser -S -G caddy caddy
USER caddy

# Railway gives PORT; default 8080 for local runs
ENV PORT=8080
EXPOSE 8080

CMD ["caddy","run","--config","/etc/caddy/Caddyfile","--adapter","caddyfile"]
