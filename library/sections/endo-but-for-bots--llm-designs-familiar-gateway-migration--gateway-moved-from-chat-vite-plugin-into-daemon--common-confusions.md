---
title: Common confusions
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

- **"`Implemented` Status with 5 facts is just a summary."** It's *file-level implementation tracking*. Each fact names a specific code path; a maintainer can `ls` the named files and verify. The §design-doc-as-implementation-tracker discipline.
- **"The gateway should be a separate process for isolation."** The §attack-surface argument goes the other way: *one fewer process with access to the Unix socket*. The gateway was a separate process pre-migration; the migration consolidated. The §discipline: *fewer processes with privileged-resource access reduces the compromise vector count*.
- **"Localhost-only restriction is too restrictive — what about remote browser clients?"** Remote browser clients should go through a *tunnel* (ssh, VPN) or a *named bearer-token gateway* (see `gateway-bearer-token-auth`). The §localhost-only gateway is the §security default; named-bearer-token gateways extend it for remote access.
- **"`fetch(token)` token-gate is just an authentication mechanism."** It's a *capability-grant* mechanism. The token is *derived from a formula identifier*; possession of the token gives access to the specific capability the formula identifies. Different from password-based auth: the token is unguessable + per-capability + non-revocable-by-changing-passwords.
- **"`gateway-server.js can be removed or retained` is wishy-washy."** The Status block confirms it *was* retained — *as a standalone server for Chat's Vite dev plugin*. The §honest-retention discipline names the trade-off; the implementation made the call.
- **"Moving the gateway into the daemon couples them."** They were *already coupled* — gateway-server.js was a Node-process that needed to know about daemon internals via the Unix socket. The §migration consolidates the coupling into a single process; it doesn't introduce new coupling.
- **"`E(gatewayBootstrap).fetch(token)` is just an indirection — why not direct connection?"** The indirection *is* the capability discipline. The gateway-bootstrap is a *handle*; the token resolves it to a *specific agent reference*. The §two-step pattern: handle → reference, with the token as the *who-the-client-is* identifier.
- **"Upgrade considerations are over-engineered — most users upgrade together."** Some don't. The §upgrade-path-with-fallback discipline is for the *mixed-version* case where the user has an old daemon running and installs a new CLI. The CLI detects the gateway-less daemon and handles it; the user isn't required to know about the migration.
- **"`endo gateway` CLI is trivial — just `echo $ENDO_ADDR`."** It's *trivial when the user knows the env var*. The CLI provides *discoverability* — a user who doesn't know about `ENDO_ADDR` can run `endo gateway` and get the URL. The §discipline: *expose discoverability commands for runtime configuration*.
- **"The single-port-dual-protocol design is an HTTP/WebSocket hack."** It's *standard*. WebSocket is defined as an HTTP upgrade; serving both on the same port is the canonical shape. The §rationale: clients don't need to know which protocol they want until after the HTTP handshake; serving both lets the client choose at runtime.
