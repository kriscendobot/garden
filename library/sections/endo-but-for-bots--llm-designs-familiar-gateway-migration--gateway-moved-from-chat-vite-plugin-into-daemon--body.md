---
title: Body
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

### §The Status block — five concrete shipped facts

The §Status block (lines 10-23) is structurally distinct from typical *Complete* status notes — it enumerates *five concrete shipped facts* with code references, not just a summary statement:

1. **`@apps` formula launches** — `packages/daemon/src/daemon-node.js` has an `@apps` formula that launches `web-server-node.js` as an unconfined guest with @endo powers. The §discipline: the gateway runs as a *guest* (not as a privileged part of the daemon kernel), confined by the @endo capability discipline.
2. **`ENDO_ADDR` default `127.0.0.1:8920`** — the gateway listens on a configurable address; the default is localhost-only on a well-known port.
3. **Dual-purpose listener** — serves *both* HTTP (weblet virtual hosts per sister design `familiar-unified-weblet-server`) *and* WebSocket (CapTP sessions). One listener, two protocols.
4. **`gateway-server.js` retained as standalone** — Chat's Vite dev plugin still has access to `packages/chat/scripts/gateway-server.js` for development workflows; it connects to the daemon over the Unix socket. The §migration didn't *delete* the old code; it *demoted* it to a development-only fallback.
5. **Familiar uses `ENDO_ADDR`** — the Familiar Electron app (cycle 109) spawns the daemon and reads `ENDO_ADDR` from env or defaults to `127.0.0.1:8920` to find the gateway.

The §file-level enumeration discipline (introduced in cycle 99's chat-reply-chain Phases ✅ and refined in cycle 109's familiar-electron-shell file-level enumeration) here documents *what shipped* with code-path references. A maintainer can verify each fact by reading the named file.

### §The daemon-must-own-this-concern rationale

The §lines 33-36:

> The gateway is the entry point for all browser-based CapTP connections. If it remains in Chat, then every application that wants to connect to the daemon from a browser must either depend on Chat or reimplement the gateway. The daemon should own this concern.

The §canonical *cross-cutting-service-belongs-in-the-shared-substrate* discipline:

- **The gateway is shared infrastructure** — every browser-CapTP application needs it.
- **Locating shared infrastructure in one application (Chat)** forces *all other applications* to depend on Chat or reimplement.
- **Locating it in the daemon** is the correct architectural placement: the daemon is the shared substrate; every app already connects to the daemon; sharing the gateway through the daemon is *no new dependency*.

The §discipline reusable for any *cross-cutting-service-in-the-wrong-process* situation. The §rule: *if multiple consumers need it, put it in the substrate they all already share*.

### §The gateway HTTP endpoint dual-purpose design

The §lines 51-61:

> The daemon's gateway listens on a configurable HTTP port (default: a well-known port like 8920, or 0 for OS-assigned). It serves:
>
> - **WebSocket connections** at `/` — CapTP sessions for browser clients. The existing gateway protocol is preserved: the client calls `E(gatewayBootstrap).fetch(token)` to obtain an agent reference.
> - **HTTP requests** — routed to weblet virtual hosts (see `familiar-unified-weblet-server` work item) or returned 404 if no weblet matches.

The §dual-purpose listener:

- **WebSocket at `/`** — protocol-upgrade from HTTP `/` to a WebSocket CapTP session. The browser client opens a WebSocket; the server upgrades; the CapTP protocol runs over the upgraded connection.
- **HTTP for everything else** — weblet virtual hosting. Each weblet has a hostname-based virtual-host route (`Host: <weblet-id>.localhost`); the gateway dispatches to the named weblet's handler.

The §`E(gatewayBootstrap).fetch(token)` capability handshake (preserved from the pre-migration design):

- Client opens WebSocket → server provides `gatewayBootstrap` capability.
- Client calls `E(gatewayBootstrap).fetch(token)` with a formula-identifier-derived token.
- Server returns the agent reference matching the token.
- Subsequent CapTP messages flow over the WebSocket.

The §protocol preservation invariant: *the wire protocol is unchanged*. Browser clients written for the pre-migration gateway work without modification.

### §The Bootstrap gateway capability via internal CapTP

The §lines 65-67:

> The daemon's `endoBootstrap` already exposes a `gateway()` method. The in-daemon gateway should use this same mechanism, connecting to itself via the internal CapTP rather than over the Unix socket.

The §self-connect-via-internal-CapTP discipline:

- The daemon's bootstrap already exposes a `gateway()` method (designed for external clients that need a gateway reference).
- The new in-daemon gateway *consumes the same API*, but connects via the internal CapTP loop (no Unix-socket round-trip).
- The §benefit: *one interface, two consumers* — external CLI clients and the in-daemon gateway both use `endoBootstrap.gateway()`.

The §discipline: *prefer reusing internal capability protocols for self-references over building parallel internal APIs*. The internal CapTP is already there; using it for self-connect avoids a duplicate-implementation hazard.

### §The Chat-dev-workflow update

The §lines 71-81:

> With the gateway in the daemon, Chat's Vite plugin (`packages/chat/vite-endo-plugin.js`) no longer needs to spawn a separate gateway process. Instead, it:
>
> 1. Ensures the daemon is running (as it does today).
> 2. Queries the daemon for the gateway port (new CLI command or daemon info endpoint).
> 3. Injects the port and agent ID into the Vite environment.
>
> The `packages/chat/scripts/gateway-server.js` file can be removed or retained as a standalone debugging tool.

The §Vite-plugin simplification: before — *spawn a gateway process* + *connect to it* + *inject its port*. After — *query the daemon for the port already running there* + *inject*. One fewer process to manage.

The §discipline: *eliminate the process when the function has moved*. The Vite plugin used to be responsible for the gateway lifecycle; now the daemon owns the lifecycle; the Vite plugin just *observes* it.

The §`gateway-server.js can be removed or retained as a standalone debugging tool* — the §honest-retention discipline. The file *could* be deleted (the function is gone), but it might still serve as a *standalone debugging tool*. The Status block confirms it *was* retained.

### §The CLI additions

The §lines 85-87:

> - `endo gateway` — print the gateway WebSocket URL.
> - `endo start --gateway-port <port>` — configure the gateway port at daemon startup.

The §two CLI additions:

- **`endo gateway`** — discoverability. A user (or shell script) can ask the daemon *what's your gateway URL?* without knowing the port. Useful when the port is OS-assigned (port 0).
- **`endo start --gateway-port <port>`** — configurability. The daemon-startup command accepts a port for the gateway listener.

The §discipline: *every new daemon-side feature gets a CLI surface for users to discover and configure*. The §pattern reusable for any *daemon-built-in-service-needs-cli-surface* shape.

### §The Security Considerations — three preservations + one improvement

The §lines 97-102:

> - The gateway currently restricts connections to localhost (127.0.0.1, ::1). This restriction must be preserved in the daemon implementation.
> - The `fetch(token)` mechanism gates access to agent capabilities. The token is derived from a formula identifier and is unguessable.
> - Moving the gateway into the daemon reduces the attack surface: one fewer process with access to the Unix socket.

The §three security disciplines:

- **Localhost-only restriction preserved** — IPv4 `127.0.0.1` + IPv6 `::1`. The §rationale: the gateway exposes browser-CapTP access to the daemon's capability graph; allowing remote access would expose every capability. Localhost-only is the §necessary minimum.
- **`fetch(token)` token-gate** — the agent-capability-grant requires a *formula-identifier-derived* token. The §unguessable-token property: tokens are derived from formula identifiers (which include high-entropy hashes); without a token, no capability access.
- **Attack-surface reduction** — *one fewer process with access to the Unix socket*. The §before: gateway-server.js was a separate Node process that opened the Unix socket. The §after: gateway is in the daemon process itself; the Unix socket is opened only by the daemon. Fewer processes with socket access means fewer compromise vectors.

The §discipline: *security improvements are quantitative*. The §move reduces the *number of processes with Unix-socket access* by 1. The metric is named explicitly; the improvement is not just qualitative.

### §The Compatibility + Upgrade considerations

The §Compatibility (lines 118-121):

> Chat's development workflow changes (no separate gateway process). This is a breaking change to the Chat dev setup, but the user experience is simpler.
> The WebSocket protocol is unchanged. Existing browser clients work without modification.

The §two-statement: *dev-workflow breaks (acknowledged) but wire-protocol preserves (so end-users see no difference)*. The §discipline: name *which audiences are affected* in compat notes — developers (Chat dev setup) vs end-users (browser-CapTP clients).

The §Upgrade (lines 125-127):

> Daemons started before this change won't have a gateway. The CLI should detect this and either restart the daemon or fall back to the old gateway script.

The §backward-compatibility-with-old-daemons discipline: pre-migration daemons exist (they were started before the migration shipped). The CLI must *detect* the gateway-less daemon and either *restart with the new daemon* or *fall back* to the old `gateway-server.js`. The §discipline: *named upgrade path with detected-and-handled fallback*.
