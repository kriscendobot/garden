---
section: docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
source: endo-but-for-bots--llm-designs-daemon-docker-selfhost
topics: [daemon, agent-conventions]
status: current
title: §Files Modified — *minimal daemon-side changes*
parent: endo-but-for-bots--llm-designs-daemon-docker-selfhost--docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
---

The §Files Modified table:

| File | Change |
|------|--------|
| `docker/Dockerfile` | New |
| `docker/docker-entrypoint.sh` | New |
| `docker/docker-compose.yml` | New |
| `packages/daemon/src/daemon-node.js` | Add `--addr` flag for bind address override |
| `packages/daemon/src/gateway.js` | Support `ENDO_GATEWAY_REMOTE` for remote auth mode |

Only *two* existing files change: daemon-node.js (add
`--addr` flag) and gateway.js (support remote auth env var).
The §minimal-daemon-side-change discipline: most of the design's
weight is in the *new infrastructure files* (Dockerfile,
entrypoint, compose), not in the daemon itself. The daemon
becomes Docker-friendly through *additive* flags, not through
restructuring.
