# Changelog

## 6.7.0-1 (2026-11-16)

- README: Deploy on Railway button for the published template (chibisafe-1). No change to the services.

## 6.7.0 (2026-11-16)

- First version of the template: Chibisafe v6.7.0 (backend with Caddy, and the Next.js frontend), official images pinned by digest.
- One volume at `/data` for the SQLite database, uploads and logs.
- The admin password comes from a generated `ADMIN_PASSWORD`; the service refuses to start without it.
