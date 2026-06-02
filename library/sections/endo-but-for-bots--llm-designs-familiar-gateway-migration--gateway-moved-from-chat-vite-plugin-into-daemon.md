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
---

## Abstract

The §Status block (lines 10-23) documents *Implemented* with five concrete shipped facts: (1) *the `@apps` formula in `packages/daemon/src/daemon-node.js` launches `web-server-node.js` as an unconfined guest with `@endo` powers*; (2) *the gateway listens on `ENDO_ADDR` (default `127.0.0.1:8920`)*; (3) *it serves both HTTP (weblet virtual hosts) and WebSocket (CapTP sessions)*; (4) *`packages/chat/scripts/gateway-server.js` is retained as a standalone server for Chat's Vite dev plugin, connecting to the daemon over the Unix socket*; (5) *the Familiar spawns the daemon directly (which hosts the gateway) and reads the gateway address from `ENDO_ADDR` or defaults to `127.0.0.1:8920`*. The §opening Problem block (lines 27-36) frames the gap: *the WebSocket gateway that bridges browser clients to the Endo daemon currently lives in `packages/chat/scripts/gateway-server.js` and is launched by the Vite development plugin (`packages/chat/vite-endo-plugin.js`). This was appropriate for development, but for the Familiar Electron application (and any production deployment), the gateway must be a first-class capability of the daemon itself*. The §canonical rationale: *the gateway is the entry point for all browser-based CapTP connections. If it remains in Chat, then every application that wants to connect to the daemon from a browser must either depend on Chat or reimplement the gateway. The daemon should own this concern*. The §Design (lines 38-94) decomposes into six subsections. The §*Move the gateway into the daemon* (lines 40-49) relocates the gateway server logic from `packages/chat/scripts/gateway-server.js` into the daemon, reusing the daemon's existing HTTP/WebSocket infrastructure (`web-server-node-powers.js` + `web-server-node.js`). The gateway becomes *a built-in service of the daemon, started alongside the Unix domain socket listener during daemon initialization (`packages/daemon/src/daemon-node.js`)*. The §Gateway HTTP endpoint (lines 51-61) dual-purpose listener: WebSocket at `/` for CapTP sessions (existing `E(gatewayBootstrap).fetch(token)` protocol preserved); HTTP requests routed to weblet virtual hosts (per `familiar-unified-weblet-server`) or 404. The §Bootstrap gateway capability (lines 63-67) reuses the daemon's existing `endoBootstrap.gateway()` method, *connecting to itself via the internal CapTP rather than over the Unix socket*. The §*Update Chat for gateway-less development* (lines 69-81): Vite plugin no longer spawns a separate gateway; queries the daemon for the gateway port (new CLI command or info endpoint); injects port + agent ID into the Vite env. *The `packages/chat/scripts/gateway-server.js` file can be removed or retained as a standalone debugging tool*. The §CLI additions (lines 83-87): `endo gateway` prints the WebSocket URL; `endo start --gateway-port <port>` configures the port at daemon startup. The §Affected packages: `packages/daemon` (add gateway HTTP/WebSocket server); `packages/chat` (remove gateway-server.js, update Vite plugin); `packages/cli` (add `endo gateway` command, gateway-port option on start). The §Security Considerations (lines 95-102): localhost-only connection restriction *preserved in the daemon implementation* (127.0.0.1, ::1); `fetch(token)` *gates access to agent capabilities. The token is derived from a formula identifier and is unguessable*; the §attack-surface observation: *Moving the gateway into the daemon reduces the attack surface: one fewer process with access to the Unix socket*. The §Scaling: gateway adds one HTTP listener to the daemon process (lightweight); multiple browser clients share the single gateway port. The §Test Plan: integration tests for daemon + gateway WebSocket + agent fetch + pet-name list; Chat dev-server connects to daemon-hosted gateway; regression that existing Chat functionality is unchanged. The §Compatibility: Chat dev-workflow changes (breaking change but simpler UX); WebSocket protocol unchanged so existing browser clients work without modification. The §Upgrade Considerations: *Daemons started before this change won't have a gateway. The CLI should detect this and either restart the daemon or fall back to the old gateway script*.

## Body

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

## Connection to the wider library

This section is the **canonical *gateway-moved-from-app-into-substrate* worked example**. Four threads:

1. **The daemon-must-own-cross-cutting-services discipline** — if multiple consumers need a service, put it in the substrate they all already share. Reusable for any *cross-cutting-service-in-the-wrong-process* situation.

2. **The dual-purpose listener (HTTP + WebSocket on one port)** — one listener, two protocols, virtual-host based dispatch. Reusable for any *multi-protocol-single-port* shape.

3. **The protocol-preservation-across-migration invariant** — the wire protocol unchanged so existing clients work without modification; only the hosting process moved. Reusable for any *function-migration-with-API-stability* shape.

4. **The attack-surface-quantified reduction** — *one fewer process with access to the Unix socket*. Reusable for any *security-improvement-with-named-metric* shape.

The §cycle 109's familiar-electron-shell named this design as one of its three required dependencies (along with `familiar-unified-weblet-server` and `familiar-daemon-bundling`). The §gateway-in-daemon is a precondition for the Familiar to spawn a daemon and have a gateway to connect to — without this migration, the Familiar would need to start the gateway separately, complicating the Electron-shell-as-just-another-client model.

## Translation block (design idiom → contemporary practice)

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

## See also

- [[daemon]] (topic) — the endo daemon architecture; the gateway becomes a daemon built-in.
- `endo-but-for-bots--llm-designs-familiar-electron-shell--*` (cycle 109) — names this design as a required dependency (*gateway must be in the daemon for the Familiar to connect to it*).
- `endo-but-for-bots--llm-designs-familiar-unified-weblet-server` (sister design; In Progress) — defines the weblet-virtual-host dispatch that the gateway's HTTP path uses.
- `endo-but-for-bots--llm-designs-familiar-daemon-bundling` (sister design; Complete) — bundles the daemon (with this gateway) into a single artifact for Electron packaging.
- `endo-but-for-bots--llm-designs-gateway-bearer-token-auth--*` (already ingested) — the bearer-token authentication mechanism the gateway uses.
- `endo-but-for-bots--llm-designs-daemon-commands-as-messages--*` (cycle 101) — commands flow over the gateway when issued from a browser-CapTP client.

## Common confusions

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
