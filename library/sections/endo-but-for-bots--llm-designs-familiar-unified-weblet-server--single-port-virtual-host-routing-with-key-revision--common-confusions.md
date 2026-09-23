---
title: Common confusions
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
