---
title: §Single-server-four-roles architecture
source-slug: endo-but-for-bots--llm-designs-daemon-web-gateway
section-id: single-server-four-roles-and-bearer-token-as-formula-ID-and-per-IP-rate-limiter-and-virtual-host-dispatch-with-caveat-emptor
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-web-gateway.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/daemon-web-gateway.md
total-lines: 185
status: Complete (2026-03-11)
ingest-cycle: 224
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-daemon-web-gateway--single-server-four-roles-and-bearer-token-as-formula-ID-and-per-IP-rate-limiter-and-virtual-host-dispatch-with-caveat-emptor
---

The gateway listens on `ENDO_ADDR` (default `127.0.0.1:8920`) and serves §four-named-roles:

1. **§CapTP-bridge-for-Chat** — WebSocket connections from Chat UI.
2. **§Alternative-to-UNIX-socket-for-Familiar** — same path for Electron renderer.
3. **§Designated-port-weblet-hosting-for-browsers** — per-weblet HTTP servers on dedicated ports.
4. **§Virtual-host-weblet-hosting-for-Familiar** — all weblets share gateway port, routed by `Host` header.

§Borrowable-pattern: §one-port-multiplexing-multiple-protocols-with-named-roles. §Different-from-classical-microservice-decomposition (one role per port); §this-is-the-other-direction (one port + N protocols dispatched by request shape).

§Sibling to cycle 184 familiar-unified-weblet-server's §unified-weblet-server (cycle 220 mentions this as a dependency). §Cycle-224-is-the-supergraph that names how all four roles live on one port.
