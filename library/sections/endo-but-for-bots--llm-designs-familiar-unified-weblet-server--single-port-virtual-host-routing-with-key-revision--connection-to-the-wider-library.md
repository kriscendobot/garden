---
title: Connection to the wider library
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
