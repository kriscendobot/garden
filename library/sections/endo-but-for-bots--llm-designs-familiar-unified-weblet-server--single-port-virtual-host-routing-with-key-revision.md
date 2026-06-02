---
title: The §Status block documenting *Partially implemented; design under revision* + the §**Key design revision (2026-04-17)** that splits the unified-server approach into *two modes* — Familiar weblets can use Host-header routing on the gateway port proxied via `localhttp://` (Electron's protocol handler provides origin isolation without separate ports) vs Chat weblets (standalone browser use without Electron) still need a *separate HTTP port per isolated page* with user-chosen port (browsers can't intercept and reroute by scheme like Electron can); the §*deeper problem* identified by the revision — *hierarchical multiplexing* (gateway must route connections to correct user → correct persona/agent → correct weblet) and *session confidentiality* (each CapTP session must be confidential even over plain local HTTP; today the gateway trusts that `127.0.0.1` traffic is private, but multi-user scenarios or weblet isolation require per-session encryption or authentication); the §*Dependencies added* — `ocapn-network-transport-separation` (gateway needs network-level abstraction for session establishment and authentication, not bare WebSocket) + `ocapn-noise-network` (Noise Protocol provides per-session confidentiality over shared gateway port, enabling secure multiplexing); the §*Implemented* enumeration (`localhttp://` protocol handler + Exfiltration defense + Navigation guard, all in `packages/familiar/`); the §*Not implemented* enumeration (daemon-side unified web server; `makeWeblet`; virtual host routing; per-weblet CapTP sessions; per-port Chat weblets; Noise-based session confidentiality); the §*Previous status note* explicitly correcting an earlier section that *claimed full implementation in `packages/daemon/src/web-server-node.js`... This appears to have been written prospectively or to describe work on a different branch. The file does not exist on origin/llm as of 2026-04-17* — the §honest-design-correction discipline; the §problem framing — each weblet currently gets its own dynamically-assigned HTTP port via `servePortHttp`, requiring N listen-ports for N weblets; this doesn't work for the Familiar Electron app which proxies all weblet traffic through one HTTP port via `localhttp://` custom protocol; the §single HTTP server design replaces per-weblet `servePortHttp` with one gateway-port server using Host header routing; the §`webletHandlers = new Map()` hostname → `{ respond, connect }` registration map; the §virtual host format `<weblet-id>.localhost`; the §weblet location format change from `http://127.0.0.1:<random-port>/<access-token>/` to `http://<weblet-id>.localhost:<gateway-port>/` (or `localhttp://<weblet-id>/` via Familiar); the §CapTP per-weblet WebSocket demuxed by hostname; the §backward-compat standalone-mode discipline (RFC 6761 `*.localhost` browser resolution); the §`makeWeblet` signature change (receives server-registrar instead of port; returns `Weblet` with `getLocation()` returning virtual host URL)
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
---

## Abstract

The §Status block (lines 10-94) documents *Partially implemented; design under revision* with substantial design-evolution content. The §**Key design revision (2026-04-17)** identifies the two-mode split: *Familiar weblets can use the unified server approach (Host-header routing on the gateway port, proxied via `localhttp://`). The Electron protocol handler provides origin isolation without needing separate ports*. *Chat weblets (standalone browser use without Electron) still need a separate HTTP port per isolated page, with the user choosing the port. Browsers cannot intercept and reroute by scheme like Electron can, so each weblet needs its own `http://` origin on a distinct port*. The §*deeper problem* (lines 35-55) names two architectural concerns the revision surfaces: (1) *hierarchical multiplexing* — *the gateway must route connections to the correct user, then to the correct persona/agent within that user's daemon, then to the correct weblet within that agent's scope*; (2) *session confidentiality* — *each CapTP session must be confidential even over plain local HTTP. Today the gateway trusts that `127.0.0.1` traffic is private, but multi-user scenarios or weblet isolation require per-session encryption or authentication*. The §problems point toward two dependency-added designs: `ocapn-network-transport-separation` (gateway needs network-level abstraction for session establishment and authentication) and `ocapn-noise-network` (Noise Protocol provides per-session confidentiality enabling secure multiplexing). The §*Implemented* enumeration (lines 66-77) names three shipped Familiar-side modules: `protocol-handler.js` (localhttp:// privileged scheme + CSP injection); `exfiltration-defense.js` (DNS-poisoning protection + request interception + permission handler); `navigation-guard.js` (`will-navigate` and `setWindowOpenHandler` interception). The §*Not implemented* enumeration (lines 78-86) names six daemon-side gaps: daemon-side unified web server; `makeWeblet`; virtual host routing; per-weblet CapTP sessions; per-port Chat weblets; Noise-based session confidentiality. The §*Previous status note* (lines 88-94) is structurally significant: *The previous status section claimed full implementation in `packages/daemon/src/web-server-node.js`. This appears to have been written prospectively or to describe work on a different branch. The file does not exist on `origin/llm` as of 2026-04-17*. The §opening Problem (lines 96-108) frames the gap: each weblet currently gets its own HTTP server on a dynamically-assigned port via `servePortHttp`; N weblets require N listening ports each with its own access token in the URL path. This doesn't work for the Familiar Electron application which proxies all weblet traffic through a single HTTP port using a custom protocol handler (`localhttp://uniqueidentifier/...`). The §Design (lines 110-214) decomposes into seven subsections. The §Single HTTP server for weblets replaces the per-weblet `servePortHttp` pattern with one server listening on the gateway port (from `familiar-gateway-migration`); routes HTTP requests by Host header; falls through to gateway WebSocket handler for unrelated requests. The §Virtual host routing uses `webletHandlers = new Map()` mapping hostname → `{ respond, connect }`; `registerWeblet(webletId, respond, connect)` creates the hostname as `${webletId.slice(0, 32)}.localhost` and registers; incoming requests demuxed by `req.headers.host`. The §Weblet location format changes from `http://127.0.0.1:<random-port>/<access-token>/` to `http://<weblet-id>.localhost:<gateway-port>/` (or `localhttp://<weblet-id>/` via Familiar). The §CapTP connection per weblet: each weblet still gets its own CapTP session over WebSocket; the unified server demuxes WebSocket upgrades by hostname and hands off to the weblet's `connect` handler. The §Backward compatibility standalone mode: `*.localhost` resolution via RFC 6761; alternatively retain per-weblet servers as fallback. The §`makeWeblet` signature change — receives server-registrar instead of port; registers handlers under virtual hostname; returns `Weblet` with `getLocation()` returning virtual host URL. The §Affected packages: `packages/daemon` (unified server + weblet registration); `packages/cli` (`endo install`/`endo open` URL format update). The §Dependency: `familiar-gateway-migration`. The §Security: virtual host routing prevents hostname spoofing (weblet identifier is unguessable 128-char hex); unified server enforces per-weblet WebSocket isolation; `*.localhost` subdomain origin isolation prevents cross-weblet cookies. The §Scaling: one listen socket instead of N; O(1) handler lookup; WebSocket connections long-lived. The §Test Plan: install two weblets verify both reachable on same port via different hostnames; per-weblet CapTP isolation; gateway WebSocket still works. The §Compatibility: URL format changes (stored/bookmarked URLs will break; acceptable since weblets are ephemeral); `*.localhost` modern-browser support is excellent. The §Upgrade: existing weblets need reinstallation; `@apps` builtin formula may need versioning.

## Body

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

## Connection to the wider library

This section is the **canonical *two-environment-different-mechanisms* worked example**. Five threads:

1. **The Key-design-revision-with-two-mode-split** — original assumption was wrong; the revision identifies *Familiar* (Electron protocol-handler intercepts) and *Chat* (browser cannot intercept) as needing *different* mechanisms for the same goal. Reusable for any *one-design-multiple-environments* situation.

2. **The deeper-problem identification + dependency-addition discipline** — when a design can't cleanly solve a problem, name the dependency that would. This design *added* `ocapn-network-transport-separation` + `ocapn-noise-network` as new dependencies during the revision.

3. **The honest-implementation-tracking + previous-status-correction** discipline — *Implemented* + *Not implemented* explicit lists; *Previous status note* explicitly corrects an earlier prospective claim that didn't match reality.

4. **The single-port-with-hostname-demultiplexing pattern** — `Map<hostname, {respond, connect}>` + Host-header routing + fall-through to default. Reusable for any *multi-tenant single-port* situation.

5. **The RFC-6761-`*.localhost`-resolution discipline** — exploit the RFC where supported; per-weblet servers as fallback. The §pattern is *use-the-standard-where-it-works-fallback-where-it-doesn't*.

The §Familiar dependency triangle is **now complete**:

- **Cycle 111** `familiar-gateway-migration` (Complete) — gateway in-daemon. ✓
- **Cycle 113** `familiar-daemon-bundling` (Complete) — daemon as Electron-packageable artifact. ✓
- **Cycle 114** `familiar-unified-weblet-server` (this ingest, In Progress) — single-port weblet serving with virtual host routing. ✓

Together cycles 109 + 111 + 113 + 114 describe the *full Familiar Electron Shell architecture*: the Familiar (cycle 109) consumes the gateway-in-daemon (cycle 111), the bundled daemon artifact (cycle 113), and the unified weblet server (cycle 114).

## Translation block (design idiom → contemporary practice)

| Design idiom | Contemporary practice |
| ------------ | --------------------- |
| `Partially implemented; design under revision` Status | The *honest-mixed-state-status* discipline. |
| `Key design revision (2026-04-17)` two-mode split | The *cross-environment-design-with-environment-specific-mechanism* discipline. |
| `Electron protocol handler provides origin isolation without needing separate ports` | The *Electron-protocol-handler-intercepts* affordance. |
| `Browsers cannot intercept and reroute by scheme like Electron can` | The *browser-can't-intercept-scheme* constraint. |
| `Hierarchical multiplexing` + `Session confidentiality` deeper problems | The *name-the-architectural-gap-not-the-workaround* discipline. |
| `Dependencies added` section | The *add-dependencies-when-revision-introduces-them* discipline. |
| *Previous status note* explicit correction | The *honest-design-correction-inline* discipline; the doc reflects reality. |
| `Implemented` + `Not implemented` enumeration | The *current-state-inventory* shape. |
| `webletHandlers = new Map()` hostname → `{ respond, connect }` | The *Map-keyed-by-virtual-hostname* registration pattern. |
| `<weblet-id>.localhost` + RFC 6761 | The *exploit-RFC-where-supported* discipline; modern browsers handle this without DNS. |
| `webletId.slice(0, 32)` hash-prefix-as-hostname | The *truncated-hash-for-hostname-length-limit* idiom. |
| `getLocation()` returns virtual host URL | The *opaque-location-from-far-reference* pattern. |
| `endo install` + `endo open` URL format change | The *URL-format-evolution-with-acceptable-breakage* discipline (weblets ephemeral). |

## See also

- [[daemon]] (topic) — the endo daemon architecture; this design's unified server lives in the daemon.
- `endo-but-for-bots--llm-designs-familiar-electron-shell--*` (cycle 109) — names this design as one of three required dependencies. The Familiar Electron Shell *consumes* the unified weblet server.
- `endo-but-for-bots--llm-designs-familiar-gateway-migration--*` (cycle 111) — the *first* of cycle 109's three named dependencies; this design's unified server is *co-located with or replaces the gateway HTTP listener*.
- `endo-but-for-bots--llm-designs-familiar-daemon-bundling--*` (cycle 113) — the *second* of cycle 109's three named dependencies; the bundled daemon contains the unified server.
- `endo-but-for-bots--llm-designs-ocapn-network-transport-separation` — newly-added dependency in the 2026-04-17 revision; addresses the hierarchical-multiplexing problem.
- `endo-but-for-bots--llm-designs-ocapn-noise-network` — newly-added dependency in the 2026-04-17 revision; addresses the session-confidentiality problem.

## Common confusions

- **"`Partially implemented; design under revision` means the design is being abandoned."** It means *the Familiar-side is shipped; the daemon-side is paused for revision*. The §Status block explicitly enumerates what's *Implemented* (3 modules) and *Not implemented* (6 gaps). The design is *active*, not abandoned.
- **"The two-mode split (Familiar vs Chat) means two separate designs."** It means *one design's mechanism varies by environment*. Familiar uses Host-header routing because Electron's protocol-handler intercepts; Chat uses per-port because browsers can't intercept. Same goal (per-weblet origin isolation), different mechanism.
- **"The Previous status note is just wrong-doc-correction."** It's *honest-design-correction-inline*. The doc preserves the correction so reviewers can see what changed. Silent rewriting would lose the audit trail.
- **"`<weblet-id>.localhost` requires DNS configuration."** It doesn't — *modern browsers resolve `*.localhost` to 127.0.0.1 per RFC 6761*. No `/etc/hosts` editing; no DNS lookup; the browser short-circuits the resolution.
- **"`webletId.slice(0, 32)` loses entropy."** It does — *intentionally*. The full 128-char hex is overkill for hostname-uniqueness within one user's daemon. 32 hex chars = 128 bits of entropy = ~2^128 possible hostnames; collision-free for any realistic weblet count.
- **"The hierarchical-multiplexing problem isn't solved by this design."** It isn't — *and the design acknowledges this*. The §deeper problem section names hierarchical-multiplexing and session-confidentiality as unsolved-without-OCapN-networking. The §Dependencies-added section names the future-work designs that would resolve them.
- **"The `localhttp://` scheme is Familiar-specific — Chat needs separate ports anyway."** Yes — *and that's what the revision documents*. The §two-mode split is exactly this distinction. The §Chat-weblets approach is *Not implemented* because *requires user-configurable ports* + needs a separate design.
- **"`getLocation()` returning a virtual-host URL breaks bookmarks."** Yes — *and the design accepts this*. The §Compatibility section names *Any stored/bookmarked weblet URLs will break. Since weblets are ephemeral (created per-install), this is acceptable*. The weblet-lifetime model makes URL-stability a non-requirement.
- **"OCapN-Noise-Network is overkill for local browser traffic."** The §deeper problem argues otherwise: *multi-user scenarios or weblet isolation require per-session encryption or authentication*. Bare `127.0.0.1` trust breaks in shared-machine scenarios. Noise provides the per-session confidentiality that the gateway currently lacks.
- **"`fall through to gateway or 404` is ambiguous — which is it?"** The §default depends on the request type. WebSocket upgrade requests *not* matching a weblet hostname fall through to the gateway's CapTP handler. HTTP requests *not* matching a weblet hostname return 404. The §exact implementation details depend on what the gateway WebSocket handler accepts.
