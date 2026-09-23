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
title: §Burst-ceiling-prevents-budget-hoarding (Decision 4)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter
---

```rust
self.budget = (self.budget + earned).min(rl.burst);
```

§The-`.min(burst)` clamp. §A-worker-idle-for-an-hour-gets-at-
most-`burst`-steps, not `rate * 3600`.

§Compare-to-cycle-167-where/index.js' §ENDO_SOCK-override-as-
last-resort: both are §bounded-by-design patterns. §Cycle-167
bounds the path-resolution surface; cycle 184 bounds the
budget-accumulation surface.

§Why-bound: "ensures that even after a long idle period, the
worker can only process a bounded burst of messages before
returning to the steady-state rate." §Compare-to-cycle-170-
daemon-capability-filesystem's §absence-is-structural-not-
policy — both are §structural-bounds-not-runtime-decisions.
