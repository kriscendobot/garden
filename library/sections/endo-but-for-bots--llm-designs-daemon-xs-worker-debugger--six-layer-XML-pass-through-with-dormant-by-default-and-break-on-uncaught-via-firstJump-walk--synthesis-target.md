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
title: §Synthesis-target
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk
---

The §slot-machine-library's worker layer can §borrow-the-six-
layer-stratification when adding non-obvious worker capabilities
(snapshot / debugger / metering equivalents). §The-protocol-
preservation-discipline (Option A) is especially valuable: when
delegating to an external vendor's substrate (XS / DOM / WASM),
treat the vendor protocol as opaque bytes and parse in your own
layer.

§The-§exploit-the-pre-jump-window-pattern is borrowable wherever
a §decision-must-be-made-before-an-irreversible-action: the
firstJump walk happens before the longjmp; the §uncaughtExceptions-
breakpoint pseudo-path is the protocol's window into that
decision.
