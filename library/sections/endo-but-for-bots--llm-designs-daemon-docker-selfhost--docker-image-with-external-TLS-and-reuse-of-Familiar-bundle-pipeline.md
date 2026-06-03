---
section: docker-image-with-external-TLS-and-reuse-of-Familiar-bundle-pipeline
source: endo-but-for-bots--llm-designs-daemon-docker-selfhost
topics: [daemon, agent-conventions]
status: current
---

# Docker image with external TLS and reuse of Familiar bundle pipeline

> *The daemon does not handle TLS itself. This keeps the daemon
> simple and follows Docker conventions. Users who want HTTPS
> use a reverse proxy, which also handles certificate renewal.*
>
> — `designs/daemon-docker-selfhost.md` §Design Decisions

`daemon-docker-selfhost.md` (236 lines, *Not Started* status,
created 2026-03-02) addresses the *always-on-server* deployment
gap. Today the Endo daemon runs only as a local process managed
by the Familiar (Electron shell) or manually via the CLI. *There
is no supported way to run a daemon as an always-on server — the
kind of setup where someone rents a VPS, deploys a container, and
has their daemon available 24/7 for remote control.*

## The §four-requirements frame

The §What is the Problem Being Solved section names four
requirements for self-hosting:

1. **A container image** bundling daemon + worker + CLI with
   appropriate defaults for headless operation.
2. **State persistence** — the daemon's state directory must
   survive container restarts.
3. **Network exposure** — the gateway's HTTP/WebSocket endpoint
   must be reachable from outside the container, with TLS
   termination handled either by the daemon or a reverse proxy.
4. **Remote authentication** — the gateway currently rejects
   non-localhost connections; a self-hosted daemon must accept
   authenticated remote connections (gated through
   `gateway-bearer-token-auth`).

The four-axis decomposition. Each axis gets its own subsection
in the §Design section.

## The §Docker image — Node:22-slim base with pre-built bundles

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

## The single most structurally interesting move — §external TLS

The §External TLS discipline is the design's load-bearing
choice:

> *TLS termination is handled externally. The daemon speaks
> plain HTTP/WebSocket inside the container. Users place a
> reverse proxy (nginx, Caddy, Traefik, cloud load balancer) in
> front for TLS. This is the standard Docker pattern and avoids
> bundling certificate management into the daemon.*

Three claims compose:

1. **The standard Docker pattern** — TLS is a *proxy concern*,
   not an *application concern*. Caddy, nginx, Traefik, and
   cloud LBs all do this; the daemon shouldn't.
2. **Avoids bundling certificate management** — Let's Encrypt
   renewal, OCSP stapling, modern TLS suite selection, etc.
   are *non-trivial* and *moving targets*. Outsourcing to a
   reverse proxy keeps the daemon out of that scope.
3. **A future enhancement could add `--tls-cert` and `--tls-key`
   flags** — but *not required for the initial Docker image*.
   The §don't-build-it-now-could-build-it-later discipline.

The §design-as-deferral pattern: rather than building TLS
*into* the daemon, the design *defers* TLS to the deployment
pipeline. The §each-layer-handles-its-concern discipline.

## The §Docker Compose example demonstrates the canonical pattern

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

## The §state-directory layout

The §State persistence section names the three subdirectories:

- **`state/`** — formula store (formula graphs, pet names,
  message logs)
- **`keys/`** — agent keypairs (256-bit identifiers; cycle 60's
  daemon-256-bit-identifiers)
- **`worker/`** — worker process logs

The §single-volume-three-subdirectories discipline lets one
mount handle the persistence. Users can `docker exec` into the
container to inspect; or use `docker cp` to backup; or bind-
mount the host directory for direct access.

## The §bundled-agents optional add-on

The §Bundled agents (optional) section names the *future
enhancement* that adds Lal/Fae bundles to the same image:

```dockerfile
COPY bundles/endo-lal.cjs ./bundles/
COPY bundles/endo-fae.cjs ./bundles/

ENV ENDO_LAL_PATH=/opt/endo/bundles/endo-lal.cjs
ENV ENDO_FAE_PATH=/opt/endo/bundles/endo-fae.cjs
```

The §optional-AI-agents-via-env-paths discipline: same image
serves users *with* or *without* AI agents; presence is
controlled by environment variables. The §parity-with-Familiar
benefit: *self-hosted users get the same out-of-the-box AI agent
experience as Familiar users*.

This depends on the (still-unindexed) `familiar-bundled-agents`
design.

## The §Chat-UI-hosting integration

The §Chat UI hosting section names how the Chat UI is served:

> *A self-hosted daemon should also serve the Chat UI. The
> gateway already serves static files; the Docker image includes
> the Chat bundle.*

The §`https://my-daemon.example.com/` access pattern: navigate to
the daemon URL → gateway serves the Chat UI static files → user
appends `#agent=<id>` URL anchor → authenticates against the
agent via `gateway-bearer-token-auth`.

The §URL-anchor-for-authentication idiom uses the *fragment*
(after `#`) for the auth token because *fragments are not sent
to the server* — the token never appears in server logs or
HTTP referer headers. The §browser-only-state discipline for
the auth credential.

## §The build pipeline

The §Build pipeline section names the §reuse-Familiar-bundle-
script discipline:

```bash
cd packages/familiar && yarn bundle
mkdir -p docker/bundles
cp bundles/*.cjs docker/bundles/
cp -r ../chat/dist docker/bundles/endo-chat
docker build -t endojs/daemon:latest docker/
```

The §three-step shape: run Familiar's bundler → copy bundles
into Docker build context → docker build. *No separate build
system*. The §no-separate-build-system discipline:

> *The Docker image reuses the Familiar's bundle pipeline. No
> separate build system. This ensures parity between the desktop
> and server deployments.*

The §single-source-of-truth-for-bundles. If the Familiar's
bundles work, the Docker image's bundles work. Bug fixes
propagate automatically.

## §Files Modified — *minimal daemon-side changes*

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

## §Four design decisions codify the choices

The §Design Decisions section names four:

1. **External TLS** — the load-bearing choice (above).
2. **Same bundles as Familiar** — *No separate build system.*
3. **Volume for state** — *Docker volumes are the standard
   persistence mechanism. Named volumes survive container
   recreation; bind mounts give users direct access for backup.*
4. **`0.0.0.0` binding** — the default-bind override.

The §codification-as-Design-Decisions discipline: each
non-obvious choice is *named* and *justified*. Future PRs that
want to deviate must explicitly argue against the recorded
rationale.

## How this design relates to the cycle 109/111 Familiar cluster

Cycle 109's `familiar-electron-shell` (the Electron desktop
shell) and cycle 111's `familiar-gateway-migration` (the
gateway moved from Chat-Vite-plugin into the daemon) are the
*Familiar* side of the deployment story. This cycle is the
*server* side:

| Cycle | Side | Audience |
|-------|------|----------|
| 109 | Familiar (Electron) | Desktop user |
| 111 | Gateway-in-daemon | Both |
| 113 | Familiar daemon bundling | Desktop user |
| 114 | Familiar unified weblet server | Desktop user |
| 139 (this) | Docker self-host | Server / VPS user |

The §gateway-in-daemon (cycle 111) was the *prerequisite* for
this design — *the gateway must own this concern* because *if it
remains in Chat, then every application that wants to connect
to the daemon from a browser must either depend on Chat or
reimplement the gateway*. With the gateway in the daemon, this
cycle's Docker image just *runs the daemon and gets the gateway
for free*.

## Related sections

- cycle 109
  [[endo-but-for-bots--llm-designs-familiar-electron-shell--electron-shell-with-daemon-outlives-app-and-localhttp-protocol]]
  — the Familiar shell whose §daemon-outlives-the-Familiar
  discipline produces the *daemon as long-lived service*
  shape this design relies on for the server case.
- cycle 111
  [[endo-but-for-bots--llm-designs-familiar-gateway-migration--gateway-moved-from-chat-vite-plugin-into-daemon]]
  — the *gateway-in-daemon* migration that's a prerequisite for
  this design (daemon now owns the HTTP/WebSocket endpoint).
- cycle 113
  [[endo-but-for-bots--llm-designs-familiar-daemon-bundling--esbuild-single-file-bundle-with-side-effect-mitigations]]
  — the *Familiar bundle pipeline* this design §reuses; same
  CJS bundles ship in both Electron and Docker.
- cycle 60 (§d256-per-agent-keypairs)
  [[endo-but-for-bots--llm-designs-d256--per-agent-keypairs]]
  — the 256-bit identifier substrate whose `keys/` subdirectory
  this design's §state-directory layout includes.
