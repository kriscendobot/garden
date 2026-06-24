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
title: §Cohesion notes
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk
---

- §Sibling-design-pair to cycle 178 daemon-xs-worker-snapshot.
  Both are In Progress, both extend xsnap engine exposure with
  envelope-bus-based control plane.
- §Stock-protocol-preserved (XML pass-through) — Option A's
  Rust-as-opaque-ferry minimizes xsDebug.c changes (Decision 7).
- §Always-compiled-dormant-by-default eliminates two-binary
  problem with §negligible-per-instruction-overhead.
- §Hot-attach via `debug-attach` envelope — no restart needed.
- §Debugger-as-Endo-capability is the §Endo-way-meta-discipline:
  everything is a capability; the debugger inherits ocap
  delegation / revocation properties.
- §The-deepest-architectural-move is §break-on-uncaught-via-
  firstJump-walk-before-fxJump: exploits the fact that
  `fxDebugThrow` runs at the throw site, not at the catch site.
  Zero-cost-if-the-answer-is-don't-break.
- §Forward-compatible-protocol-extension: new pseudo-breakpoint
  `"uncaughtExceptions"` does not affect older xsbug clients.
- §Four-edge-cases-named-and-defended including the §honest-
  finally-without-catch-false-negative.
- §Seven-Design-Decisions in the §canonical-Design-Decisions-
  format.
- §Six-phases scaling with the §six-layer-vertical-stack.
- §xs-worker-capability-trio (snapshot + debugger + metering)
  sharing cycle 176's endor substrate.
- §DebugSession-SAX-parser is a §state-machine-in-Jessie-
  compatible-JS; sibling to cycle 177-netstring/reader.js's
  §two-state-iterator and cycle 169-atomics.js' §async-generator-
  as-resumable-state-machine.
