# Chibisafe web UI (Next.js). Reached only through the Chibisafe service's Caddy.
FROM chibisafe/chibisafe:v6.7.0@sha256:6a970d9d88647171e212e355bf3efd16909cbb31db133ef111684c2b1a0259a3

# Listen on port 8001 on IPv4 and IPv6, so the Chibisafe service can reach it over
# Railway's private network. BASE_API_URL comes from the template variables.
CMD ["sh", "-c", "PORT=8001 HOSTNAME=:: exec node --dns-result-order=ipv4first server.js"]
