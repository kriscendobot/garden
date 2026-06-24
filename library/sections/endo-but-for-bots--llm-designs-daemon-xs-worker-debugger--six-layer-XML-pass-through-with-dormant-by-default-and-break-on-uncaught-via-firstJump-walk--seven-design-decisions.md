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
title: §Seven-Design-Decisions
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-debugger--six-layer-XML-pass-through-with-dormant-by-default-and-break-on-uncaught-via-firstJump-walk
---

| # | Decision | Reason |
|---|----------|--------|
| 1 | Always compiled, dormant by default | Eliminates two-binary problem; per-worker hot-attach via envelope |
| 2 | XML pass-through, not translation | Stock protocol; zero xsDebug.c changes; future XS upgrades free |
| 3 | Thread-local buffers with mutex | XS single-threaded per worker; mutex uncontended in practice |
| 4 | `"debug"` verb on existing bus | No new transport / pipes / sockets |
| 5 | Debugger as Endo capability | The Endo way; granted/delegated/revoked like any cap |
| 6 | `followBreaks` as async iterator | Matches `followMessages` / `followNameChanges` |
| 7 | No changes to xsDebug.c | Platform layer is our custom code; engine is upstream |

§Compare-to-cycle-180-hex-package's §eight-Design-Decisions and
cycle 178's §six. §This-design-has §seven — the §canonical-
Design-Decisions-format is honored without rigid count.

§Decision-7 is the §spec-driven-discipline named: the entire
debug subsystem is stock Moddable XS; only the platform layer is
custom.
