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
title: §XML-pass-through Rust as opaque byte ferry (Layer 2)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk
---

§The-Rust-supervisor-does-not-parse-XML. §Two-new-envelope-verbs:

| Verb | Direction | Payload | Nonce |
|------|-----------|---------|-------|
| `"debug"` | daemon → worker | Raw xsbug XML bytes (command) | 0 |
| `"debug"` | worker → daemon | Raw xsbug XML bytes (response) | 0 |

§Same-verb-both-directions; handle rewriting distinguishes
sender. §Matches-the-pattern-of-`deliver` for CapTP traffic.

§No-new-supervisor-code-beyond recognizing `"debug"` as a
pass-through verb. §The-existing-handle-rewrite-logic suffices.

§Compare-to-cycle-176-daemon-endor-architecture's §three-worker-
platforms-with-byte-identical-CBOR-envelopes — this design lands
within that framework: §the-`debug`-verb-is-byte-identical-
across-all-three-platforms (separate XS / shared XS / Node.js
worker).
