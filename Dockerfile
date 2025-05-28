# --------------------------------------------------
# runtime image that already bundles Caddy + Coraza
# --------------------------------------------------
FROM openpanel/caddy-coraza:latest

# your Caddyfile goes into the standard location
COPY Caddyfile /etc/caddy/Caddyfile
# DO **NOT** set CMD or ENTRYPOINT – keep the image default
