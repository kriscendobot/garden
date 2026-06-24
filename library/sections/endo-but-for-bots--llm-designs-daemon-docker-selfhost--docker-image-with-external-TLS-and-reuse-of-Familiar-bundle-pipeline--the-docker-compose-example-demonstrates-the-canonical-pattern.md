---
section: docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
source: endo-but-for-bots--llm-designs-daemon-docker-selfhost
topics: [daemon, agent-conventions]
status: current
title: The §Docker Compose example demonstrates the canonical pattern
parent: endo-but-for-bots--llm-designs-daemon-docker-selfhost--docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
---

The §Docker Compose example shows the *daemon + caddy* shape:

```yaml
services:
  endo:
    image: endojs/daemon:latest
    ports:
      - "8920:8920"
    volumes:
      - endo-state:/data/endo
    environment:
      - ENDO_GATEWAY_REMOTE=true
    restart: unless-stopped

  caddy:
    image: caddy:2
    ports:
      - "443:443"
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile
    depends_on:
      - endo
```

The §two-services-one-volume pattern: endo handles agent state;
caddy handles TLS; the `endo-state` volume persists the daemon
data. The §`restart: unless-stopped` policy makes the daemon
survive container restarts (boots on host reboot).

The §`ENDO_GATEWAY_REMOTE=true` env-var flag enables remote
authentication (delegated to cycle 109's
`gateway-bearer-token-auth` design).
