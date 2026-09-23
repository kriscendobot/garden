---
title: Translation block (design idiom → contemporary practice)
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
