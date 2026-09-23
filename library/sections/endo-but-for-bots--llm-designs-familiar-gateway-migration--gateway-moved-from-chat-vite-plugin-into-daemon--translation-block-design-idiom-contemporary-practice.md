---
title: Translation block (design idiom → contemporary practice)
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

| Design idiom | Contemporary practice |
| ------------ | --------------------- |
| `Implemented` Status block with 5 concrete shipped facts | The *design-doc-as-implementation-tracker* shape at file-level granularity. |
| `the gateway is the entry point for all browser-based CapTP connections` | The *single-entry-point* discipline; gateway concentrates browser-CapTP access. |
| `every application that wants to connect ... must either depend on Chat or reimplement the gateway` | The *cross-cutting-service-belongs-in-substrate* rationale. |
| `dual-purpose listener (HTTP + WebSocket)` | The *multi-protocol-single-port* idiom; virtual-host based dispatch. |
| `E(gatewayBootstrap).fetch(token)` capability handshake | The *token-as-capability-key* protocol; client exchanges unguessable token for agent reference. |
| `connecting to itself via the internal CapTP rather than over the Unix socket` | The *prefer-internal-self-connect* discipline; reuse existing CapTP for self-references. |
| `Moving the gateway into the daemon reduces the attack surface: one fewer process with access to the Unix socket` | The *consolidation-as-security-improvement* with named-metric. |
| `Daemons started before this change won't have a gateway. The CLI should detect this and either restart ... or fall back` | The *named-upgrade-path-with-detected-fallback* discipline. |
| `gateway-server.js can be removed or retained as a standalone debugging tool` | The *honest-retention* discipline; the file *could* be deleted but might still serve. |
