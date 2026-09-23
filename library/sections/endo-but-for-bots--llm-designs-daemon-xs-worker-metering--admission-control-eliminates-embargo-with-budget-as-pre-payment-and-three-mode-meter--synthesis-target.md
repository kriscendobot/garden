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
title: §Synthesis-target
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter
---

The §slot-machine-library's worker-layer-quota-and-rate-
limiting (if it has any) can §borrow-the-three-mode-meter +
§admission-control-pre-payment + §lazy-rate-limit-refill +
§burst-ceiling-prevents-hoarding patterns directly. §The-
admission-control-pattern is the §key-takeaway: enforce
worst-case-coverage at delivery time to eliminate rollback
machinery.

§The-§xs-worker-capability-trio-architecture (snapshot +
debugger + metering as three sibling capabilities sharing
endor substrate) is a §borrowable-architectural-pattern
wherever §multiple-worker-level-capabilities-share-a-
supervisor-bus.
