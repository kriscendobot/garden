---
title: Abstract
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

The §Status block (lines 10-23) documents *Implemented* with five concrete shipped facts: (1) *the `@apps` formula in `packages/daemon/src/daemon-node.js` launches `web-server-node.js` as an unconfined guest with `@endo` powers*; (2) *the gateway listens on `ENDO_ADDR` (default `127.0.0.1:8920`)*; (3) *it serves both HTTP (weblet virtual hosts) and WebSocket (CapTP sessions)*; (4) *`packages/chat/scripts/gateway-server.js` is retained as a standalone server for Chat's Vite dev plugin, connecting to the daemon over the Unix socket*; (5) *the Familiar spawns the daemon directly (which hosts the gateway) and reads the gateway address from `ENDO_ADDR` or defaults to `127.0.0.1:8920`*. The §opening Problem block (lines 27-36) frames the gap: *the WebSocket gateway that bridges browser clients to the Endo daemon currently lives in `packages/chat/scripts/gateway-server.js` and is launched by the Vite development plugin (`packages/chat/vite-endo-plugin.js`). This was appropriate for development, but for the Familiar Electron application (and any production deployment), the gateway must be a first-class capability of the daemon itself*. The §canonical rationale: *the gateway is the entry point for all browser-based CapTP connections. If it remains in Chat, then every application that wants to connect to the daemon from a browser must either depend on Chat or reimplement the gateway. The daemon should own this concern*. The §Design (lines 38-94) decomposes into six subsections. The §*Move the gateway into the daemon* (lines 40-49) relocates the gateway server logic from `packages/chat/scripts/gateway-server.js` into the daemon, reusing the daemon's existing HTTP/WebSocket infrastructure (`web-server-node-powers.js` + `web-server-node.js`). The gateway becomes *a built-in service of the daemon, started alongside the Unix domain socket listener during daemon initialization (`packages/daemon/src/daemon-node.js`)*. The §Gateway HTTP endpoint (lines 51-61) dual-purpose listener: WebSocket at `/` for CapTP sessions (existing `E(gatewayBootstrap).fetch(token)` protocol preserved); HTTP requests routed to weblet virtual hosts (per `familiar-unified-weblet-server`) or 404. The §Bootstrap gateway capability (lines 63-67) reuses the daemon's existing `endoBootstrap.gateway()` method, *connecting to itself via the internal CapTP rather than over the Unix socket*. The §*Update Chat for gateway-less development* (lines 69-81): Vite plugin no longer spawns a separate gateway; queries the daemon for the gateway port (new CLI command or info endpoint); injects port + agent ID into the Vite env. *The `packages/chat/scripts/gateway-server.js` file can be removed or retained as a standalone debugging tool*. The §CLI additions (lines 83-87): `endo gateway` prints the WebSocket URL; `endo start --gateway-port <port>` configures the port at daemon startup. The §Affected packages: `packages/daemon` (add gateway HTTP/WebSocket server); `packages/chat` (remove gateway-server.js, update Vite plugin); `packages/cli` (add `endo gateway` command, gateway-port option on start). The §Security Considerations (lines 95-102): localhost-only connection restriction *preserved in the daemon implementation* (127.0.0.1, ::1); `fetch(token)` *gates access to agent capabilities. The token is derived from a formula identifier and is unguessable*; the §attack-surface observation: *Moving the gateway into the daemon reduces the attack surface: one fewer process with access to the Unix socket*. The §Scaling: gateway adds one HTTP listener to the daemon process (lightweight); multiple browser clients share the single gateway port. The §Test Plan: integration tests for daemon + gateway WebSocket + agent fetch + pet-name list; Chat dev-server connects to daemon-hosted gateway; regression that existing Chat functionality is unchanged. The §Compatibility: Chat dev-workflow changes (breaking change but simpler UX); WebSocket protocol unchanged so existing browser clients work without modification. The §Upgrade Considerations: *Daemons started before this change won't have a gateway. The CLI should detect this and either restart the daemon or fall back to the old gateway script*.
