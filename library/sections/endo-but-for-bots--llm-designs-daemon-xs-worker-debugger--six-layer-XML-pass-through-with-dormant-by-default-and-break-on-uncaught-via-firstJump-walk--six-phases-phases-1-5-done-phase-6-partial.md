---
source: designs/daemon-xs-worker-debugger.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-debugger.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
  - hardened-javascript
status_at_ingest: In Progress
genre: §endo-but-for-bots-design §sibling-design-trio
cycle: 182
lane: designs
status: current
title: §Six-phases (Phases 1-5 done; Phase 6 partial)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk
---

| Phase | What | Status |
|-------|------|--------|
| 1 | Compile-time debug support (cargo feature + xsnap-platform.c hooks + powers/debug.rs) | done |
| 2 | Bus protocol integration (envelope verb routing + worker event loop) | done |
| 3 | DebugSession JS client (SAX parser + structured API) | done |
| 4 | Hot-attach + daemon integration (debug-attach/detach envelopes + bus handler + CESU-8 codec) | done |
| 5 | Debugger exo + CapTP integration (makeExo + M.interface + 16 CapTP tests) | done |
| 6 | Chat debugger panel (UI shell + /debug command + ~460 lines of CSS) | done (UI shell); §remaining: attachDebugger CapTP exposure + followBreaks live notification + source-view + profiling format |

§Compare-to-cycle-178-daemon-xs-worker-snapshot's three-phase
plan; §this-design-has-six-phases. §The-phase-count-scales-with-
the-vertical-stack: more layers means more landable chunks.

§The-§remaining-work named in Phase 6 includes §`attachDebugger`-
CapTP-exposure — the most important remaining gap. §Once-that-
lands, the debugger is reachable from Chat / Familiar / any
peer.
