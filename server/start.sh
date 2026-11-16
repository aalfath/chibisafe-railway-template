#!/bin/sh
# Starts the Chibisafe backend and Caddy, and exits if either of them stops,
# so Railway's restart policy brings the service back.
set -eu

mkdir -p /data/database /data/uploads /data/logs

if [ -z "${FRONTEND_HOST:-}" ]; then
  echo "FRONTEND_HOST is not set: point it at the Frontend service's private domain." >&2
  exit 1
fi
if [ -z "${ADMIN_PASSWORD:-}" ]; then
  echo "ADMIN_PASSWORD is not set: refusing to create the admin user with the default password." >&2
  exit 1
fi

# Caddy listens on the public port; the backend stays on 8000 (dual-stack so the
# Frontend can reach it over Railway's private network).
export CADDY_PORT="${PORT:-8080}"
export FRONTEND_URL="http://${FRONTEND_HOST}:${FRONTEND_PORT:-8001}"
cd /app

PORT=8000 HOST="${BACKEND_HOST:-::}" yarn workspace @chibisafe/backend start &
BACKEND=$!

caddy run --config /etc/caddy/Caddyfile --adapter caddyfile &
CADDY=$!

stop() {
  kill -TERM "$BACKEND" "$CADDY" 2>/dev/null || true
  wait || true
  exit 0
}
trap stop TERM INT

while kill -0 "$BACKEND" 2>/dev/null && kill -0 "$CADDY" 2>/dev/null; do
  sleep 2
done

echo "Chibisafe backend or Caddy stopped; exiting." >&2
kill -TERM "$BACKEND" "$CADDY" 2>/dev/null || true
wait || true
exit 1
