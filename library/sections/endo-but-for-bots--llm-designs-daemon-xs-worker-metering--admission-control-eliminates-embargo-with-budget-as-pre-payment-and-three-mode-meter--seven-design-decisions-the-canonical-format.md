---
source: designs/daemon-xs-worker-metering.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-metering.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - capability-security
status_at_ingest: Complete
genre: §endo-but-for-bots-design §sibling-design-trio
cycle: 184
lane: designs
status: current
title: §Seven-Design-Decisions (the canonical format)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter
---

| # | Decision | Reason |
|---|----------|--------|
| 1 | Admission control instead of embargo | Eliminates the most complex part of earlier design |
| 2 | Hard limit as termination, not pause | XS state after metering abort is unreliable; worker can be re-created from snapshot |
| 3 | Lazy rate-limit refill | Avoids timer overhead; gives exact results; ready_time enables single wake-up |
| 4 | Burst ceiling prevents budget hoarding | Bounds the steady-state rate even after long idle |
| 5 | Budget as pre-payment, not post-payment | Worst-case-coverage at delivery time means no rollback |
| 6 | Measurement-only as default | Always-on with limit=0; negligible overhead |
| 7 | meter-config envelope for hard-limit, not per-crank | Hard limit rarely changes; admission gate lives in supervisor |

§Compare-to-cycle-180-hex-package's §eight + cycle 178's §six +
cycle 182's §seven. §Seven-Decisions matches cycle 182.
§The-§canonical-Design-Decisions-format honored throughout the
endo-but-for-bots design corpus.
