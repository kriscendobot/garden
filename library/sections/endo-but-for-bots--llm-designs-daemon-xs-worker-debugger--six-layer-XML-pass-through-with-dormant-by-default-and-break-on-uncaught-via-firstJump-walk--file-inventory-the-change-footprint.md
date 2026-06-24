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
title: §File-inventory (the change footprint)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk
---

§Seven-new-files + §eighteen-modified-files = §twenty-five-file
footprint.

§New-files split across three boundaries:

| Boundary | Files |
|----------|-------|
| Rust supervisor | `powers/debug.rs` + `cesu8.rs` + `debug_protocol_tests.rs` |
| Daemon JS | `debug-session.js` + `debugger.js` + `debugger-captp.test.js` |
| Chat UI | `chat/debugger-panel.js` |

§The-CESU-8-codec is a §supporting-infrastructure that emerged
from this work — XS strings use CESU-8 surrogate-pair encoding
(see cycle 176 daemon-endor-architecture's §CESU-8-surrogate-
pair-encoding-XS-string-quirk).

§Modified-files include 11 Rust files + 6 JS files + 1 CSS. §The-
modification-spread-tells-the-story: every layer touched, no
layer "owns" the change.
