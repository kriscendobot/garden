---
title: See also
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

- [[daemon]] (topic) — the endo daemon architecture; the gateway becomes a daemon built-in.
- `endo-but-for-bots--llm-designs-familiar-electron-shell--*` (cycle 109) — names this design as a required dependency (*gateway must be in the daemon for the Familiar to connect to it*).
- `endo-but-for-bots--llm-designs-familiar-unified-weblet-server` (sister design; In Progress) — defines the weblet-virtual-host dispatch that the gateway's HTTP path uses.
- `endo-but-for-bots--llm-designs-familiar-daemon-bundling` (sister design; Complete) — bundles the daemon (with this gateway) into a single artifact for Electron packaging.
- `endo-but-for-bots--llm-designs-gateway-bearer-token-auth--*` (already ingested) — the bearer-token authentication mechanism the gateway uses.
- `endo-but-for-bots--llm-designs-daemon-commands-as-messages--*` (cycle 101) — commands flow over the gateway when issued from a browser-CapTP client.
