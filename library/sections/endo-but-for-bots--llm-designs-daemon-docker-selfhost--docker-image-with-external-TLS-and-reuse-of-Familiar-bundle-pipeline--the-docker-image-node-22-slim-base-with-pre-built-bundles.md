---
section: docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
source: endo-but-for-bots--llm-designs-daemon-docker-selfhost
topics: [daemon, agent-conventions]
status: current
title: "The §Docker image — Node:22-slim base with pre-built bundles"
parent: endo-but-for-bots--llm-designs-daemon-docker-selfhost--docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
---

The §Dockerfile shape:

```dockerfile
FROM node:22-slim

WORKDIR /opt/endo
COPY bundles/ ./bundles/
COPY docker-entrypoint.sh ./

VOLUME /data/endo
EXPOSE 8920

ENV ENDO_STATE=/data/endo
ENV ENDO_ADDR=0.0.0.0:8920

ENTRYPOINT ["./docker-entrypoint.sh"]
```

Three structurally interesting moves:

1. **§Pre-built bundles, not source** — the image contains
   *pre-built daemon bundle, worker bundle, and CLI bundle —
   the same artifacts the Familiar ships*. No yarn install, no
   `node_modules` directory. The §reuse-Familiar-bundles
   discipline.

2. **§State directory as volume** — `VOLUME /data/endo`
   declares the persistence boundary. Users mount a named
   volume or host directory.

3. **§Default bind to `0.0.0.0:8920`** — overrides the local
   daemon's `127.0.0.1:8920` default. Inside Docker, *binding
   to localhost makes the gateway unreachable from outside the
   container*.

The §entrypoint script:

```bash
#!/bin/bash
set -eu

# Initialize state directory if needed
if [ ! -d "$ENDO_STATE/state" ]; then
  node bundles/endo-cli.cjs init --state "$ENDO_STATE"
fi

exec node bundles/endo-daemon.cjs \
  --state "$ENDO_STATE" \
  --addr "$ENDO_ADDR"
```

The §lazy-init-on-first-start pattern: if the state directory
doesn't have a `state/` subdirectory, run `endo init`; then exec
the daemon. The §replaceable-volume discipline: a fresh volume
gets initialized; an existing volume is kept as-is. The §exec-
into-daemon ensures the daemon process becomes PID 1 in the
container (so Docker signals reach it directly).
