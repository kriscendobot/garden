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
kind: index
section_count: 6
---

Sections:

- [Abstract](endo-but-for-bots--llm-designs-familiar-unified-weblet-server--single-port-virtual-host-routing-with-key-revision--abstract.md)
- [Body](endo-but-for-bots--llm-designs-familiar-unified-weblet-server--single-port-virtual-host-routing-with-key-revision--body.md)
- [Connection to the wider library](endo-but-for-bots--llm-designs-familiar-unified-weblet-server--single-port-virtual-host-routing-with-key-revision--connection-to-the-wider-library.md)
- [Translation block (design idiom → contemporary practice)](endo-but-for-bots--llm-designs-familiar-unified-weblet-server--single-port-virtual-host-routing-with-key-revision--translation-block-design-idiom-contemporary-practice.md)
- [See also](endo-but-for-bots--llm-designs-familiar-unified-weblet-server--single-port-virtual-host-routing-with-key-revision--see-also.md)
- [Common confusions](endo-but-for-bots--llm-designs-familiar-unified-weblet-server--single-port-virtual-host-routing-with-key-revision--common-confusions.md)
