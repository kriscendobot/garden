---
title: Abstract
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

The §Status block (lines 10-94) documents *Partially implemented; design under revision* with substantial design-evolution content. The §**Key design revision (2026-04-17)** identifies the two-mode split: *Familiar weblets can use the unified server approach (Host-header routing on the gateway port, proxied via `localhttp://`). The Electron protocol handler provides origin isolation without needing separate ports*. *Chat weblets (standalone browser use without Electron) still need a separate HTTP port per isolated page, with the user choosing the port. Browsers cannot intercept and reroute by scheme like Electron can, so each weblet needs its own `http://` origin on a distinct port*. The §*deeper problem* (lines 35-55) names two architectural concerns the revision surfaces: (1) *hierarchical multiplexing* — *the gateway must route connections to the correct user, then to the correct persona/agent within that user's daemon, then to the correct weblet within that agent's scope*; (2) *session confidentiality* — *each CapTP session must be confidential even over plain local HTTP. Today the gateway trusts that `127.0.0.1` traffic is private, but multi-user scenarios or weblet isolation require per-session encryption or authentication*. The §problems point toward two dependency-added designs: `ocapn-network-transport-separation` (gateway needs network-level abstraction for session establishment and authentication) and `ocapn-noise-network` (Noise Protocol provides per-session confidentiality enabling secure multiplexing). The §*Implemented* enumeration (lines 66-77) names three shipped Familiar-side modules: `protocol-handler.js` (localhttp:// privileged scheme + CSP injection); `exfiltration-defense.js` (DNS-poisoning protection + request interception + permission handler); `navigation-guard.js` (`will-navigate` and `setWindowOpenHandler` interception). The §*Not implemented* enumeration (lines 78-86) names six daemon-side gaps: daemon-side unified web server; `makeWeblet`; virtual host routing; per-weblet CapTP sessions; per-port Chat weblets; Noise-based session confidentiality. The §*Previous status note* (lines 88-94) is structurally significant: *The previous status section claimed full implementation in `packages/daemon/src/web-server-node.js`. This appears to have been written prospectively or to describe work on a different branch. The file does not exist on `origin/llm` as of 2026-04-17*. The §opening Problem (lines 96-108) frames the gap: each weblet currently gets its own HTTP server on a dynamically-assigned port via `servePortHttp`; N weblets require N listening ports each with its own access token in the URL path. This doesn't work for the Familiar Electron application which proxies all weblet traffic through a single HTTP port using a custom protocol handler (`localhttp://uniqueidentifier/...`). The §Design (lines 110-214) decomposes into seven subsections. The §Single HTTP server for weblets replaces the per-weblet `servePortHttp` pattern with one server listening on the gateway port (from `familiar-gateway-migration`); routes HTTP requests by Host header; falls through to gateway WebSocket handler for unrelated requests. The §Virtual host routing uses `webletHandlers = new Map()` mapping hostname → `{ respond, connect }`; `registerWeblet(webletId, respond, connect)` creates the hostname as `${webletId.slice(0, 32)}.localhost` and registers; incoming requests demuxed by `req.headers.host`. The §Weblet location format changes from `http://127.0.0.1:<random-port>/<access-token>/` to `http://<weblet-id>.localhost:<gateway-port>/` (or `localhttp://<weblet-id>/` via Familiar). The §CapTP connection per weblet: each weblet still gets its own CapTP session over WebSocket; the unified server demuxes WebSocket upgrades by hostname and hands off to the weblet's `connect` handler. The §Backward compatibility standalone mode: `*.localhost` resolution via RFC 6761; alternatively retain per-weblet servers as fallback. The §`makeWeblet` signature change — receives server-registrar instead of port; registers handlers under virtual hostname; returns `Weblet` with `getLocation()` returning virtual host URL. The §Affected packages: `packages/daemon` (unified server + weblet registration); `packages/cli` (`endo install`/`endo open` URL format update). The §Dependency: `familiar-gateway-migration`. The §Security: virtual host routing prevents hostname spoofing (weblet identifier is unguessable 128-char hex); unified server enforces per-weblet WebSocket isolation; `*.localhost` subdomain origin isolation prevents cross-weblet cookies. The §Scaling: one listen socket instead of N; O(1) handler lookup; WebSocket connections long-lived. The §Test Plan: install two weblets verify both reachable on same port via different hostnames; per-weblet CapTP isolation; gateway WebSocket still works. The §Compatibility: URL format changes (stored/bookmarked URLs will break; acceptable since weblets are ephemeral); `*.localhost` modern-browser support is excellent. The §Upgrade: existing weblets need reinstallation; `@apps` builtin formula may need versioning.
