---
title: Connection to the wider library
source: designs/familiar-gateway-migration.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-02-26
source_authors: [Kris Kowal (prompted)]
source_lines: "1-128 (full file)"
topics: [daemon]
status: current
notes: |
  Twenty-seventh endo-but-for-bots design ingest. **Status:
  Complete** (*Implemented*). The 127-line design documents the
  *gateway move* — the WebSocket gateway that bridges browser
  clients to the Endo daemon was originally in `packages/chat/
  scripts/gateway-server.js` (launched by Chat's Vite dev plugin);
  now relocated to the daemon as a built-in service that serves
  both HTTP (weblet virtual hosts) and WebSocket (CapTP sessions)
  on `ENDO_ADDR` (default `127.0.0.1:8920`).
  
  Cycle 111 ingests this design as the *first* of cycle 109's
  three named dependencies. Three structurally interesting moves:
  (1) the *daemon-must-own-this-concern* rationale — *if [the
  gateway] remains in Chat, then every application that wants to
  connect to the daemon from a browser must either depend on Chat
  or reimplement the gateway* — the canonical *cross-cutting-
  service-belongs-in-the-shared-substrate* discipline; (2) the
  *attack-surface-reduction* observation — *Moving the gateway
  into the daemon reduces the attack surface: one fewer process
  with access to the Unix socket* — the §consolidation-as-
  security-improvement argument; (3) the *preserve-the-WebSocket-
  protocol* compatibility discipline — existing browser clients
  work without modification because the wire protocol is unchanged;
  only the *hosting process* moved.
  
  Pairs structurally with cycle 109's familiar-electron-shell
  (which names this design as a required dependency — *gateway
  must be in the daemon for the Familiar to connect to it*).
  Single-section cohesion-honest ingest.
parent: endo-but-for-bots--llm-designs-familiar-gateway-migration--gateway-moved-from-chat-vite-plugin-into-daemon
---

This section is the **canonical *gateway-moved-from-app-into-substrate* worked example**. Four threads:

1. **The daemon-must-own-cross-cutting-services discipline** — if multiple consumers need a service, put it in the substrate they all already share. Reusable for any *cross-cutting-service-in-the-wrong-process* situation.

2. **The dual-purpose listener (HTTP + WebSocket on one port)** — one listener, two protocols, virtual-host based dispatch. Reusable for any *multi-protocol-single-port* shape.

3. **The protocol-preservation-across-migration invariant** — the wire protocol unchanged so existing clients work without modification; only the hosting process moved. Reusable for any *function-migration-with-API-stability* shape.

4. **The attack-surface-quantified reduction** — *one fewer process with access to the Unix socket*. Reusable for any *security-improvement-with-named-metric* shape.

The §cycle 109's familiar-electron-shell named this design as one of its three required dependencies (along with `familiar-unified-weblet-server` and `familiar-daemon-bundling`). The §gateway-in-daemon is a precondition for the Familiar to spawn a daemon and have a gateway to connect to — without this migration, the Familiar would need to start the gateway separately, complicating the Electron-shell-as-just-another-client model.
