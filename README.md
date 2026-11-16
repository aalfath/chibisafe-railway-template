# Chibisafe on Railway

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/chibisafe-1?utm_medium=integration&utm_source=button&utm_campaign=chibisafe)

One-click Railway template for [Chibisafe](https://github.com/chibisafe/chibisafe), a self-hosted file uploader and sharing service with albums, share links, tags, an admin panel and a ShareX/API key workflow.

**Version:** Chibisafe v6.7.0, built from the official images pinned by digest:

| Service | Folder | Base image |
|---|---|---|
| `Chibisafe` (public) | [`server/`](server) | `chibisafe/chibisafe-server:v6.7.0@sha256:db8a632617e0c2e668f8302dac1dcebf2a169d1347b126ddf0ceb3ce03f69f32` plus the `caddy` binary from `caddy:2.11.9-alpine@sha256:003a97808e781aa9f7e75cc2f43d34d461099031faf5e20faefb9f61126836f0` |
| `Frontend` (private) | [`frontend/`](frontend) | `chibisafe/chibisafe:v6.7.0@sha256:6a970d9d88647171e212e355bf3efd16909cbb31db133ef111684c2b1a0259a3` |

## What the template deploys

- **Chibisafe**: the Fastify API with its SQLite database, and Caddy in front of it, as in the upstream Docker setup. Caddy listens on port 8080 (the public domain), serves uploaded files straight from the volume with a sandboxing Content-Security-Policy, sends `/api` and `/docs` to the API on `127.0.0.1:8000`, and everything else to the Frontend service over Railway's private network. Health check: `/api/health`.
- **Frontend**: the Next.js web UI on port 8001, reachable only through Chibisafe.
- **Volume** `/data` on Chibisafe: `database/` (SQLite), `uploads/` and `logs/`. Everything you upload and every setting survives redeploys.

## Variables

| Service | Variable | Default | Notes |
|---|---|---|---|
| Chibisafe | `ADMIN_PASSWORD` | `${{secret(24)}}` | Password of the `admin` user created on first start. Read it in the service's Variables tab. Changing it later does nothing: change the password in the UI instead. The start script refuses to run without it, so the upstream default `admin` is never used. |
| Chibisafe | `FRONTEND_HOST` | `${{Frontend.RAILWAY_PRIVATE_DOMAIN}}` | Where Caddy finds the web UI. |
| Chibisafe | `PORT` | `8080` | Caddy's port; the public domain points at it. |
| Frontend | `BASE_API_URL` | `http://${{Chibisafe.RAILWAY_PRIVATE_DOMAIN}}:8000` | Where the web UI's server side reaches the API. |

Note: the backend's start-up log always prints "Created admin user with password: admin". That line is hard-coded upstream: the real password is `ADMIN_PASSWORD`, and `admin`/`admin` is refused.

After the first login, open **Dashboard → Settings** to set the service name, the maximum upload size, public mode (anonymous uploads) and user sign-ups. Optional S3 storage is configured there too.

## Updates

This repo's `main` branch is what deployers build. When a new Chibisafe release comes out, the image pins in `server/Dockerfile` and `frontend/Dockerfile` are bumped together and the change is listed in [CHANGELOG.md](CHANGELOG.md). Railway then shows an "update available" notice on your project; read the changelog and apply it when it suits you. The database is migrated automatically at start-up. Back up the `/data` volume before a major version change.

## Local test

```sh
docker compose -f compose.local.yml up --build
# http://localhost:42295, user admin, password from compose.local.yml
```

## License

The wrapper files in this repo are MIT. Chibisafe itself is MIT-licensed by its authors.
