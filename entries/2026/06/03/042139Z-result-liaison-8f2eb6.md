---
ts: 2026-06-03T04:21:39Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--8f2eb6
cycle: 139
---

# Cycle 139 — daemon-docker-selfhost.md (Kris Kowal, endo-but-for-bots) — fourth daemon-* after endopi closure

Ingested `designs/daemon-docker-selfhost.md` (236 lines, *Not
Started* status, created 2026-03-02) from
`endojs/endo-but-for-bots@ee535f59` (branch `origin/llm`).
**Thirty-first-comment-style design ingest.** One cohesion-honest
section:

- **docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-
  pipeline** — addresses the *always-on-server* deployment gap.
  Today the daemon runs only as a local process or via Familiar;
  this design adds a *Docker image and standard deployment
  patterns* for VPS-style 24/7 hosting.

## The single most structurally interesting move

§External TLS — *the daemon does not handle TLS itself. This
keeps the daemon simple and follows Docker conventions. Users
who want HTTPS use a reverse proxy, which also handles
certificate renewal*.

The §design-as-deferral pattern: rather than building TLS *into*
the daemon, the design *defers* TLS to the deployment pipeline.
*Avoids bundling certificate management* (Let's Encrypt renewal,
OCSP stapling, modern TLS suite selection — all non-trivial
moving targets).

## §Four-requirements frame

1. Container image (Node:22-slim + pre-built bundles)
2. State persistence (VOLUME /data/endo)
3. Network exposure (bind 0.0.0.0:8920 + external TLS via proxy)
4. Remote authentication (`ENDO_GATEWAY_REMOTE=true` →
   gateway-bearer-token-auth)

## §Docker Compose two-services-one-volume pattern

```yaml
services:
  endo: { image: endojs/daemon:latest, ports: ["8920:8920"], volumes: [endo-state:/data/endo], environment: [ENDO_GATEWAY_REMOTE=true] }
  caddy: { image: caddy:2, ports: ["443:443"], depends_on: [endo] }
volumes: { endo-state: }
```

`restart: unless-stopped` lets the daemon survive container
restarts (boot on host reboot).

## §URL-anchor-not-query-string for Chat auth

`https://my-daemon.example.com/#agent=<id>` — fragments are not
sent to the server. The auth token *never appears in server
logs or HTTP referer headers*.

## §Reuse-Familiar-bundle-script discipline

*No separate build system — ensures parity between desktop and
server deployments*. Single source of truth for bundles.

## §Minimal-daemon-side-change

Only **two** existing files modify: `daemon-node.js` adds
`--addr` flag; `gateway.js` supports `ENDO_GATEWAY_REMOTE` env
var. Most weight in *new infrastructure files* (Dockerfile,
entrypoint, compose).

## Deployment-shape picture now spans Familiar + Docker

Pairs with the Familiar cluster (cycles 109/111/113/114) to
complete the deployment picture:

| Cycle | Side | Audience |
|-------|------|----------|
| 109 | Familiar electron-shell | Desktop user |
| 111 | Familiar gateway-migration | Both |
| 113 | Familiar daemon-bundling | Desktop user |
| 114 | Familiar unified-weblet-server | Desktop user |
| **139** | **Docker self-host** | **Server / VPS user** |

## Rotation note

Cycle 139 was nominally **papers-lane** (cycle 138 was
comments). Papers-lane has been blocked for **33+ consecutive
cycles**. Cycle 139 pivoted to designs-lane. **Fourth daemon-*
design after endopi-* family closure** (cycles 133 + 135 + 137
+ 139).

## Counts

- 642 → **643** sections (+1).
- 183 → **184** source documents (+1).
- Topic pages updated: `daemon.md` (+1 row).
- Keywords index extended with ~33 docker-selfhost-specific
  keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 140 wakes in 1500s. Rotation lands on **chat-lane**
nominally (still exhausted at 20/20). Many candidate paths
remain.
