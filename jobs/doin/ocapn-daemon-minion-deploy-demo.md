---
role: builder
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-07-11T04:01:11Z -->

role: builder

# Deploy an OCapN-Noise Pet Daemon on minion.town and connect a local peer (M3+M4)

**Goal:** a **working demonstration** — an Endo Pet Daemon running on **minion.town**
serving OCapN over **WebSocket+Noise**, with a **local peer** connecting to it and a
capability round-tripping. Capture a repeatable script + transcript.

**Prefer tentative progress over delay.** Where a question is open, pick the
smallest reasonable default, proceed, and document the assumption in your report.

## Inputs / dependencies

- **Daemon WS wiring:** the branch produced by job
  `build-endo-daemon-ocapn-ws-transport` (stacked on PR #340
  `claude/endo-daemon-ocapn-FkmHO`), which adds the WebSocket transport to
  `packages/daemon/src/networks/ocapn.js` (`ocapn+noise+ws` address,
  `{'ws:url':…}` hints, injected `WebSocketServer` powers). If that branch has
  landed, build on it. If it is not ready yet, either wait briefly or wire the WS
  transport yourself on `claude/endo-daemon-ocapn-FkmHO` — do not block the demo on
  it indefinitely.
- **Maintainer intent:** kriskowal intends to run the daemon on minion.town **via
  systemd** (possibly a separate board job). If such a job/deployment exists,
  coordinate and build on it; otherwise deploy it yourself.
- **Host access:** minion.town is EC2 `i-0380cd68b90020fad` (us-west-1, **aarch64**,
  node v22, SSH closed → **SSM only**). The container has AWS CLI + `garden-fleet`
  creds (`~/.aws`); drive the host with `aws ssm send-command` (see
  `skills/aws-administration/SKILL.md`). Security group allows **inbound 80/443
  only** — so the daemon's WS listener binds a **loopback** port and is exposed via
  Caddy on 443. Raw TCP from off-host is NOT reachable.

## Steps

1. **Get an OCapN-Noise-WS-capable daemon build for aarch64.** Check out the WS
   branch; the Noise WASM ships in-tree (portable). Install/build for the host arch
   (or build a self-contained bundle and copy via SSM/S3). Document how you got the
   daemon onto the host.
2. **Run it under systemd** as a dedicated unit (e.g. `endo-ocapn-daemon.service`),
   listening on a **loopback** WS port (e.g. `127.0.0.1:8930`), with `@nets/ocapn`
   enabled and a Greeter-style capability (or the daemon's own bootstrap) reachable.
   Do not disturb `caddy`, `oauth2-proxy`, or `minion-mcp`.
3. **Add a Caddy route** (authorized by the maintainer). Root
   `/etc/caddy/Caddyfile` does `import conf.d/*.caddy` (one file per site). Add a
   route exposing the daemon's WS as `wss://minion.town/ocapn` → the loopback port,
   **NOT** behind oauth2-proxy `forward_auth` (OCapN-over-Noise self-authenticates).
   A drafted file is at `scratch/ocapn-demo.caddy.draft` in the garden root.
   **ALWAYS** `sudo caddy validate --config /etc/caddy/Caddyfile` before
   `sudo systemctl reload caddy`; rollback = remove the file + reload. For a durable
   route, land it in the `kriscendobot/minion.town` repo's `conf.d/` +
   `deploy/aws/scripts/deploy-caddy.sh`; a box-local file is fine for the demo.
4. **Connect a local peer** from the container over `wss://minion.town/ocapn`
   (reuse the demo `client.mjs` pattern / the daemon CLI), and round-trip a
   capability. Capture the transcript.

## Done

A repeatable script + transcript showing a local peer connecting to the minion.town
daemon over OCapN-Noise-WS and invoking a capability. Report: how the daemon was
built/deployed, the systemd unit, the exact Caddy route, the wss URL, and every
tentative choice + any spec/code gap you routed around. This is a demonstration, not
necessarily a PR (though daemon fixes you make should land on the WS branch).

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 8
  claimed_at: 2026-07-11T05:03:13Z
