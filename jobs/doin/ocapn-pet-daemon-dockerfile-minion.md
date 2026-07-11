role: builder

# Reproducible Dockerfile for the full Endo Pet Daemon on minion.town (WS+Noise)

**Maintainer directive (2026-07-11):** bake the native-dependency build tooling into a
**Dockerfile** (a reproducible image) — do **not** mutate the minion.town host with
imperative `apt-get`. The current demo runs a *standalone* OCapN-Noise-WS service
(`endo-ocapn-daemon.service`, `demo/minion-town/ocapn-ws-server.mjs`) that avoids
`better-sqlite3`; this job graduates it to the **full Pet Daemon** (`@endo/daemon` with
`@nets/ocapn` installed), which needs the native SQLite dep.

## Base

`endojs/endo-but-for-bots @ claude/endo-daemon-ocapn-ws-FkmHO` (the WS-transport branch,
PR #684 / stacked on #340). The daemon's OCapN-Noise WS netlayer is
`packages/daemon/src/networks/ocapn.js` + `setup-ocapn.js` (installs `@nets/ocapn`).

## Task

1. **Write a Dockerfile** (under `packages/daemon/` or a `deploy/` dir) that builds an
   image for the Endo Pet Daemon: a node-22 aarch64-compatible base, the build toolchain
   for native deps (`build-essential python3` so `better-sqlite3` compiles, or a pinned
   prebuilt), `corepack yarn install` for the daemon package, and an entrypoint that boots
   the daemon with **`@nets/ocapn` enabled on a WebSocket listen address** (loopback WS
   port, mirroring the standalone demo's `127.0.0.1:8930`). Keep it self-contained and
   reproducible; the Noise WASM ships in-tree (no Rust build).
2. **Deploy it on minion.town** (EC2 `i-0380cd68b90020fad`, aarch64, SSM-only; garden AWS
   creds; `skills/aws-administration/SKILL.md`). If Docker/Podman isn't present, install a
   container runtime (that's the point of containerizing — the host stays clean). Run the
   image; publish the Pet Daemon's OCapN-Noise WS listener on a loopback port.
3. **Expose via Caddy.** Reuse the existing ungated `wss://minion.town/ocapn` route
   (`/etc/caddy/conf.d/minion-town.caddy`, `handle /ocapn*`) — repoint it to the full
   daemon's port, or add `wss://minion.town/ocapn-daemon` for the real Pet Daemon while
   leaving the standalone demo in place. `caddy validate` before `systemctl reload caddy`.
4. **Prove a local peer connects** to the real Pet Daemon's `@nets/ocapn` bootstrap over
   `wss://` and reaches its bootstrap capability (the `EndoOcapnBootstrap` at swissnum
   `endo-bootstrap`). Capture a transcript.

**Prefer tentative progress over delay:** pick the smallest reasonable default (base image,
runtime, storage path) and document it. Land the Dockerfile + deploy scripts + README +
transcript on the WS branch (or a stacked branch → draft PR). No upstream ferry.

## Done

A committed Dockerfile + deploy script that reproducibly stands up the **full** Endo Pet
Daemon on minion.town serving OCapN over WS+Noise (via `@nets/ocapn`), with a captured
transcript of a local peer reaching its bootstrap over `wss://minion.town/…`. Report the
image, the runtime, the Caddy route, and every tentative choice.

<!-- garden-deadline-overrun: 1 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  claimed_at: 2026-07-11T08:38:25Z
