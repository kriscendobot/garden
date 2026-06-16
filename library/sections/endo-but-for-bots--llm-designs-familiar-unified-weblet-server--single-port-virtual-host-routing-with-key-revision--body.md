---
title: Body
source: designs/familiar-unified-weblet-server.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: HEAD (origin/llm, fetched 2026-06-02)
source_date: 2026-05-06
source_authors: [Kris Kowal (prompted)]
source_lines: "1-260 (full file)"
topics: [daemon]
status: current
notes: |
  Thirtieth endo-but-for-bots design ingest. **Status: In Progress**
  (*Partially implemented; design under revision*). The 259-line
  design is the **third and final of cycle 109's three named
  dependencies for the Familiar Electron Shell** — completing the
  Familiar dependency triangle (cycle 111 familiar-gateway-migration
  + cycle 113 familiar-daemon-bundling + cycle 114 this ingest).
  
  Four structurally interesting moves: (1) the **Key design
  revision (2026-04-17)** — the original design assumed *a single
  unified HTTP server with Host-header-based virtual host routing
  for all weblets*; the revision identified that *Familiar
  weblets* (Electron protocol handler intercepts) and *Chat
  weblets* (browsers can't intercept scheme) need *different*
  approaches; the §two-mode split discipline names both modes
  with rationale; (2) the §*deeper problem* enumeration —
  hierarchical multiplexing + session confidentiality — point
  toward OCapN Network/Transport separation and Noise Protocol
  Network as the structural answer; (3) the *Implemented* + *Not
  implemented* + *Previous status note* discipline — an honest
  current-state inventory + explicit correction of an earlier
  prospective-status section that claimed implementation that
  doesn't exist on `origin/llm` (*This appears to have been
  written prospectively or to describe work on a different
  branch. The file does not exist on origin/llm as of 2026-04-17*);
  (4) the *RFC-6761-`*.localhost`-resolution* discipline — modern
  browsers resolve `*.localhost` to 127.0.0.1 per the RFC, so no
  DNS configuration is needed for standalone-browser-mode access.
  
  Single-section cohesion-honest ingest. Cycle 114 pivoted from
  papers-lane (tenth consecutive block) to familiar-design-lane
  to complete the Familiar dependency triangle.
parent: endo-but-for-bots--llm-designs-familiar-unified-weblet-server--single-port-virtual-host-routing-with-key-revision
---

### §The Key design revision (2026-04-17) — two-mode split

The §lines 19-33:

> The original design assumed a single unified HTTP server with Host-header-based virtual host routing for all weblets. This assumption must be revised:
>
> - **Familiar weblets** can use the unified server approach (Host-header routing on the gateway port, proxied via `localhttp://`). The Electron protocol handler provides origin isolation without needing separate ports.
> - **Chat weblets** (standalone browser use without Electron) still need a **separate HTTP port per isolated page**, with the user choosing the port. Browsers cannot intercept and reroute by scheme like Electron can, so each weblet needs its own `http://` origin on a distinct port.

The §canonical *two-environment-different-mechanisms* discipline:

- **Familiar (Electron)** — Electron's `protocol.handle('localhttp', ...)` can intercept *any* URL scheme before DNS resolution. The unified-server approach works because the protocol handler provides the origin isolation.
- **Chat (standalone browser)** — Browsers can't intercept arbitrary schemes. The only way to give two webpages *separate origins* is to put them on *different ports* (or different domains, but domains require DNS).

The §design pattern: *the same architectural goal (per-weblet origin isolation) requires different mechanisms depending on the runtime environment*. Reusable for any *cross-environment design with environment-specific implementations* situation.

The §lesson: the original design assumed Electron-style protocol-handler universality. The 2026-04-17 revision *honestly corrected* the assumption — Chat (browser) doesn't have this affordance.

### §The deeper problem — hierarchical multiplexing + session confidentiality

The §lines 35-55:

> The gateway currently listens on a single port for HTTP and WebSocket CapTP. It acts as a proxy for all users on the system and all personas within a single user's daemon. This creates a problem of:
>
> 1. **Hierarchical multiplexing**: the gateway must route connections to the correct user, then to the correct persona/agent within that user's daemon, then to the correct weblet within that agent's scope.
> 2. **Session confidentiality**: each CapTP session must be confidential even over plain local HTTP. Today the gateway trusts that `127.0.0.1` traffic is private, but multi-user scenarios or weblet isolation require per-session encryption or authentication.

The §two structural problems:

- **Hierarchical multiplexing** — three-level routing: user → persona/agent → weblet. The gateway port is shared across all three levels; each connection must reach the correct endpoint.
- **Session confidentiality** — `127.0.0.1` is *trusted-by-default*, but that trust breaks in multi-user systems (multiple users on a shared machine sharing the loopback interface) and in weblet-isolation scenarios (one weblet should not be able to eavesdrop on another's CapTP session).

The §honest-architectural-gap-naming: *the gateway lacks per-session encryption and authentication*. The §rationale: *Today the gateway trusts that `127.0.0.1` traffic is private*. This *was* sufficient when the gateway only served the local user's own browser; it isn't sufficient for multi-tenant or per-weblet-isolated scenarios.

The §pointed-to-solutions (added Dependencies):

- **`ocapn-network-transport-separation`** — gateway needs a *network-level abstraction* for session establishment and authentication. Not bare WebSocket; something that allows session-level context.
- **`ocapn-noise-network`** — Noise Protocol provides *per-session confidentiality and mutual authentication* over the shared gateway port. Multiple sessions on one port; each independently encrypted.

The §discipline: *when a design encounters a problem it cannot cleanly solve, name the dependency that would resolve it*. The §revision *added* dependencies rather than *invented* in-design solutions.

### §The Implemented + Not-implemented + Previous-status discipline

The §*Implemented* (lines 66-77):

> - **`localhttp://` protocol handler** (`packages/familiar/src/protocol-handler.js`): registers a privileged scheme, proxies `localhttp://<weblet-id>/` requests to `http://127.0.0.1:{gatewayPort}` with `Host: {accessToken}`, injects CSP headers on every response.
> - **Exfiltration defense** (`packages/familiar/src/exfiltration-defense.js`): DNS poisoning protection, request interception, permission handler.
> - **Navigation guard** (`packages/familiar/src/navigation-guard.js`): `will-navigate` and `setWindowOpenHandler` interception.

The §*Not implemented* (lines 78-86):

> - **Daemon-side unified web server:** No weblet HTTP routing or `webletHandlers` map exists in the daemon.
> - **`makeWeblet` function:** No weblet creation or registration mechanism.
> - **Virtual host routing:** The gateway does not demultiplex by `Host` header.
> - **Per-weblet CapTP sessions:** No weblet-specific WebSocket handler isolation.
> - **Per-port Chat weblets:** Not designed yet; requires user-configurable ports.
> - **Noise-based session confidentiality:** Depends on OCapN networking milestones.

The §honest-implementation-tracking discipline: *Familiar-side is done; daemon-side is not*. The Familiar protocol-handler proxies requests; the daemon-side handlers that would receive those requests don't exist. The §design names the gap explicitly.

The §*Previous status note* (lines 88-94):

> The previous status section claimed full implementation in `packages/daemon/src/web-server-node.js`. This appears to have been written prospectively or to describe work on a different branch. The file does not exist on `origin/llm` as of 2026-04-17.

The §canonical *honest-design-correction* discipline. The previous status was *wrong*; the maintainer corrects it inline. The §rationale: *prospective-status* (writing as-if implemented when it's actually planned) is *a known design-doc-failure-mode*. The correction preserves trust in the rest of the doc.

The §lesson: *if you discover a section is wrong, correct it explicitly rather than silently rewriting*. Reviewers can see what changed.

### §The single-HTTP-server design

The §lines 112-123:

> Replace the per-weblet `servePortHttp` pattern with a single HTTP server managed by the daemon (or co-located with the gateway from `familiar-gateway-migration`). This server:
>
> - Listens on the gateway port (from `familiar-gateway-migration`).
> - Uses the **Host header** to route HTTP requests to the correct weblet. Each weblet is identified by a unique virtual hostname: `<weblet-identifier>.localhost` or `<weblet-identifier>.endo.local`.
> - Falls through to the gateway WebSocket handler for WebSocket upgrade requests that don't match a weblet.

The §three-layered server:

1. **One port** (the gateway port from cycle 111's `familiar-gateway-migration`).
2. **HTTP requests routed by Host header** — `<weblet-id>.localhost` selects the weblet's handler.
3. **Fall through for non-weblet WebSocket upgrades** — gateway CapTP at `/` still works.

The §discipline: *one listener serves many roles*. The gateway WebSocket at `/` is the CapTP entry; the HTTP virtual hosts are the weblet entries; both share the same TCP socket.

### §The virtual host routing implementation

The §lines 132-155:

```js
// In the unified server
const webletHandlers = new Map(); // hostname -> { respond, connect }

const registerWeblet = (webletId, respond, connect) => {
  const hostname = `${webletId.slice(0, 32)}.localhost`;
  webletHandlers.set(hostname, { respond, connect });
  return hostname;
};

server.on('request', (req, res) => {
  const host = req.headers.host?.split(':')[0]; // strip port
  const handler = webletHandlers.get(host);
  if (handler) {
    handler.respond(req, res);
  } else {
    // Default: gateway or 404
  }
});
```

The §implementation pattern:

- **`Map<hostname, {respond, connect}>`** — the lookup structure. Hostname-keyed; per-weblet response and WebSocket-connect handlers.
- **`webletId.slice(0, 32)`** — truncate the 128-char-hex weblet ID to 32 chars for the hostname (DNS hostname length limit is 63 chars per label; the truncated form fits comfortably).
- **`.localhost` suffix** — RFC 6761 reserves `.localhost` to resolve to 127.0.0.1; modern browsers honor this.
- **Strip port from Host header** — `req.headers.host?.split(':')[0]` removes the optional `:port` suffix.
- **Fall through to gateway or 404** — when no weblet matches, the request goes to the gateway's default handler.

The §discipline: *hash-prefix-as-hostname is sufficient for collision-resistance*. The 128-bit truncation is still well above birthday-paradox collision thresholds for the expected weblet count.

### §The weblet location format change

The §lines 159-171:

```
http://127.0.0.1:<random-port>/<access-token>/
```

to:

```
http://<weblet-id>.localhost:<gateway-port>/
```

Or, when accessed through Familiar's custom protocol:

```
localhttp://<weblet-id>/
```

The §three URL forms:

1. **Old format** — per-weblet random port + access-token in path. *N weblets = N ports*.
2. **New format (standalone)** — single gateway port + `<weblet-id>.localhost` subdomain. *N weblets = 1 port + N subdomains*.
3. **Familiar format** — `localhttp://` scheme + weblet-id as host. *Electron protocol handler intercepts; no port needed at all*.

The §benefit: *fewer listening sockets* + *cleaner URL structure* + *origin isolation via subdomain rather than port*.

### §The backward-compat standalone-mode (RFC 6761)

The §lines 179-184:

> For development without Familiar (e.g., `endo install` + `endo open`), the unified server can still be reached directly at `http://<weblet-id>.localhost:<port>/`. Modern browsers resolve `*.localhost` to 127.0.0.1 per RFC 6761, so no DNS configuration is needed.

The §RFC-6761-discipline:

- **RFC 6761** reserves `.localhost` for loopback. *Specifically, this means that browsers and other clients can resolve `<anything>.localhost` to 127.0.0.1 without DNS lookup*.
- **Modern browsers** (Chrome, Firefox, Safari) all implement this.
- **Standalone-mode access** works without `/etc/hosts` configuration.

The §discipline: *exploit the RFC where supported, with fallback for legacy*. The §alternative-mentioned: *retain the ability to spawn per-weblet servers as a fallback when the unified server is not available* — for environments where `*.localhost` resolution isn't reliable.

### §The makeWeblet signature change

The §lines 191-202:

> The `makeWeblet` function in `packages/daemon/src/web-server-node.js` currently:
> 1. Receives a bundle, powers, and port.
> 2. Creates HTTP + WebSocket handlers.
> 3. Calls `servePortHttp` to bind a port.
> 4. Returns a `Weblet` far reference with `getLocation()`.
>
> After this change:
> 1. Receives a bundle, powers, and a **server registrar** (instead of a port).
> 2. Creates HTTP + WebSocket handlers (same as today).
> 3. Registers handlers with the unified server under a virtual hostname.
> 4. Returns a `Weblet` far reference with `getLocation()` returning the virtual host URL.

The §signature evolution: *port → server-registrar*. The §discipline: *the consumer no longer needs to know about ports*; it gets a registrar that exposes the right registration interface.

The §before-vs-after with the same step-numbering shows what changed (step 1 input, step 3 registration mechanism, step 4 URL format) and what stayed the same (step 2 handler creation).

### §The Security considerations

The §lines 218-226:

> - Virtual host routing must prevent hostname spoofing. The weblet identifier in the hostname is derived from a formula identifier (128-char hex) and is unguessable.
> - The unified server must enforce that WebSocket connections to a weblet hostname can only access that weblet's powers, not another weblet's or the host agent's.
> - Cookies set by one weblet must not be readable by another. The `*.localhost` domain isolation in browsers provides this (each subdomain is a separate origin).

The §three security disciplines:

- **Anti-spoofing** — unguessable weblet identifiers (128-char hex = ~512 bits of entropy → infeasible to guess).
- **Per-weblet WebSocket isolation** — the unified server checks the Host header and routes to the correct weblet; cross-weblet WebSocket-injection is prevented at routing time.
- **Cookie/storage isolation** — browser same-origin policy on `*.localhost` subdomains.

The §discipline: *security via three orthogonal mechanisms* (unguessable IDs + routing isolation + browser SOP).
