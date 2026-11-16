# Chibisafe backend (Fastify API + SQLite) with Caddy in front of it.
# Caddy serves the uploaded files from the volume, proxies /api and /docs to the
# backend on 127.0.0.1:8000, and everything else to the Frontend service.
FROM caddy:2.11.9-alpine@sha256:003a97808e781aa9f7e75cc2f43d34d461099031faf5e20faefb9f61126836f0 AS caddy

FROM chibisafe/chibisafe-server:v6.7.0@sha256:db8a632617e0c2e668f8302dac1dcebf2a169d1347b126ddf0ceb3ce03f69f32

COPY --from=caddy /usr/bin/caddy /usr/bin/caddy
COPY Caddyfile /etc/caddy/Caddyfile
COPY start.sh /usr/local/bin/chibisafe-start

# All state (SQLite database, uploads, logs) lives on one Railway volume at /data.
RUN chmod +x /usr/local/bin/chibisafe-start \
 && rm -rf /app/database /app/uploads /app/logs \
 && ln -s /data/database /app/database \
 && ln -s /data/uploads /app/uploads \
 && ln -s /data/logs /app/logs

ENV NODE_ENV=production
EXPOSE 8080

CMD ["/usr/local/bin/chibisafe-start"]
