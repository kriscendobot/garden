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
title: §Tier-1 borrowing
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk
---

- §always-compiled-dormant-by-default (one binary; per-instance
  activation eliminates two-binary problem)
- §XML-pass-through (Rust as opaque byte ferry; preserve vendor
  protocol)
- §hot-attach-via-envelope (no restart required)
- §debugger-as-Endo-capability (CapTP-remotable; granted /
  delegated / revoked)
- §followBreaks-async-iterator (matches followMessages/
  followNameChanges pattern)
- §break-on-uncaught-via-firstJump-walk-before-fxJump (zero-cost
  decision at throw site)
- §exploit-the-pre-jump-window-as-the-decision-point
- §forward-compatible-protocol-extension (new pseudo-breakpoint
  path; old clients unaffected)
- §three-option-architectural-decision-table (alternatives-
  considered framing)
- §six-layer-strict-stratification (C → Rust → JS → SES → CapTP
  → UI; each layer talks only to neighbors)
- §thread-local-buffers-with-mutex (single-threaded inside, safe
  outside)
- §SAX-parser-in-Jessie-compatible-JS (hand-written state machine
  for simple XML subset)
- §honest-edge-case-table with §accepted-false-negative for v1
- §finally-without-catch-as-known-limitation
