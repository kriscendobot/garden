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
title: §Three-option-architectural-decision (Option A chosen; B and C rejected)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk
---

§The-design-enumerates-three-options-and-defends-the-choice:

| Option | What | Verdict | Reason |
|--------|------|---------|--------|
| A | XML pass-through (Rust ferries opaque bytes; JS parses) | **Chosen** | Stock xsbug protocol; zero xsDebug.c changes; future XS upgrades free; small Rust surface |
| B | Host-function translation (Rust functions call xsDebug.c internals) | Rejected | Internals not public API; loses profiling/instrument-sampling; larger Rust surface with no benefit |
| C | Replace XML with JSON in xsDebug.c | Rejected | Massive fork divergence from upstream Moddable; same information, different syntax |

§Compare-to-cycle-178-daemon-xs-worker-snapshot's §six-Design-
Decisions and cycle 180-hex-package's §eight-Design-Decisions
— this design's §three-option-table is a different framing
(alternatives-considered rather than decisions-recorded). §Both-
are-valid §honest-design-discipline.

§Option-A-wins-because-it §preserves-the-XS-vendor-protocol.
§Cycle-128's §spec-driven-implementation-discipline applies:
when an external spec already defines the data shape, don't
reinvent.

§The-XML-protocol-is-the-de-facto-API — `xsbug-node/xsbug-
machine.js` is the reference implementation. §Reusing-it-keeps-
Endo-aligned-with-Moddable-upstream.
