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
title: Six-layer XML-pass-through architecture with dormant-by-default debug and break-on-uncaught-via-firstJump-walk-before-fxJump
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk
---

> §Designs-lane after cycle 181's chat-lane. §The-sixteenth-
> consecutive designs/chat alternation cycle (166-182). §Status:
> **In Progress** — Phases 1-5 done; Phase 6 (Chat panel UI
> shell) done, with `attachDebugger` CapTP exposure, `followBreaks`
> live notification, source-view, and profiling format
> remaining.

`daemon-xs-worker-debugger.md` (1211 lines, Created 2026-04-14,
Updated 2026-04-15) designs an interactive debugger for Endo's
Rust-supervised XS workers: breakpoints, stepping, frame
inspection, profiling, all driven over CapTP, hot-attachable to
any running worker.

§The-design-is-a §sibling-trio-with cycle 178 (daemon-xs-worker-
snapshot) and the un-ingested daemon-xs-worker-metering — three
worker-level capabilities sharing the §endor-Rust-supervisor
substrate (cycle 176). §All-three-extend-the-xsnap-engine-
exposure with non-obvious mechanisms while keeping the §three-
worker-platforms-with-byte-identical-CBOR-envelopes invariant.

§The-single-most-structurally-interesting-move is the §six-
layer-XML-pass-through-architecture combined with §break-on-
uncaught-via-firstJump-walk-before-fxJump:

- §Stock-xsbug-XML-protocol stays intact (XS engine upgrades get
  debug features for free).
- §Rust-supervisor-is-opaque-byte-ferry (no XML parsing in Rust).
- §JS-side-SAX-parser inside SES handles the protocol.
- §Debugger-exposed-as-CapTP-capability (`Debugger` exo).
- §Hot-attach-without-restart via dormant compile-time hooks.
- §Break-on-uncaught-exceptions uses XS's pre-jump throw hook to
  walk the active-handler linked list at throw time — §zero-
  cost-if-the-answer-is-don't-break.
