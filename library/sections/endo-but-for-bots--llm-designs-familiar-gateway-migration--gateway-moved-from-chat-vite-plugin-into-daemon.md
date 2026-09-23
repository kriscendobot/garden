---
title: The §Status block documenting *Implemented* with five concrete shipped facts (`@apps` formula in `daemon-node.js` launches `web-server-node.js` as unconfined guest with @endo powers; gateway listens on `ENDO_ADDR` default `127.0.0.1:8920`; serves both HTTP for weblet virtual hosts AND WebSocket for CapTP sessions; `packages/chat/scripts/gateway-server.js` retained as standalone for Vite dev plugin connecting via Unix socket; Familiar reads `ENDO_ADDR` or defaults to `127.0.0.1:8920`); the §problem framing — *the WebSocket gateway that bridges browser clients to the Endo daemon currently lives in `packages/chat/scripts/gateway-server.js`* and is launched by Chat's Vite dev plugin; the §gateway-must-belong-to-the-daemon rationale — *the gateway is the entry point for all browser-based CapTP connections; if it remains in Chat, then every application that wants to connect to the daemon from a browser must either depend on Chat or reimplement the gateway. The daemon should own this concern*; the §move-the-gateway-into-the-daemon step — relocate from `packages/chat/scripts/gateway-server.js` into the daemon, reusing the daemon's existing HTTP/WebSocket infrastructure (`web-server-node-powers.js` + `web-server-node.js`); the §gateway HTTP endpoint dual-purpose listener — WebSocket at `/` for CapTP sessions (existing `E(gatewayBootstrap).fetch(token)` protocol preserved) + HTTP requests routed to weblet virtual hosts (per `familiar-unified-weblet-server` sister design) or 404; the §Bootstrap gateway capability — daemon's `endoBootstrap.gateway()` reused, *connecting to itself via the internal CapTP rather than over the Unix socket*; the §Update-Chat-for-gateway-less-development — Vite plugin no longer spawns a separate gateway process; queries the daemon for gateway port via new CLI command or info endpoint; injects port + agent ID into Vite env; the §CLI additions (`endo gateway` prints WebSocket URL; `endo start --gateway-port <port>` configures); the §Security: localhost-restriction preserved (127.0.0.1, ::1); `fetch(token)` gates agent capabilities; *Moving the gateway into the daemon reduces the attack surface: one fewer process with access to the Unix socket*; the §Compatibility: WebSocket protocol unchanged so existing browser clients work without modification; Chat dev-workflow simpler but breaking change to old dev setup; the §Upgrade: pre-migration daemons don't have a gateway, CLI detects and restarts or falls back
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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-familiar-gateway-migration--gateway-moved-from-chat-vite-plugin-into-daemon--abstract.md)
- [Body](endo-but-for-bots--llm-designs-familiar-gateway-migration--gateway-moved-from-chat-vite-plugin-into-daemon--body.md)
- [Connection to the wider library](endo-but-for-bots--llm-designs-familiar-gateway-migration--gateway-moved-from-chat-vite-plugin-into-daemon--connection-to-the-wider-library.md)
- [Translation block (design idiom → contemporary practice)](endo-but-for-bots--llm-designs-familiar-gateway-migration--gateway-moved-from-chat-vite-plugin-into-daemon--translation-block-design-idiom-contemporary-practice.md)
- [See also](endo-but-for-bots--llm-designs-familiar-gateway-migration--gateway-moved-from-chat-vite-plugin-into-daemon--see-also.md)
- [Common confusions](endo-but-for-bots--llm-designs-familiar-gateway-migration--gateway-moved-from-chat-vite-plugin-into-daemon--common-confusions.md)
