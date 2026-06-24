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
title: §Snapshot-integration (Phase 6, the trio cohesion)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter
---

```
SuspendedWorker.meter field preserves MeterState across
suspend/resume.  restore_meter on resume.
```

§The-§MeterState-survives-suspend-resume. §On-resume,
`last_refill` is recomputed to "now" to §avoid-crediting-
idle-time-during-suspension. §Otherwise-a-rate-limited-worker
that was suspended for a day would resume with `rate * 86400`
of accumulated budget (clamped by burst, but still
significant).

§This-is-§sibling-design-coherence: cycle 178 snapshot defines
the suspend/resume mechanism; cycle 184 metering integrates by
declaring "MeterState must round-trip through the snapshot."
§The-design-cites-cycle-178-explicitly in the Dependencies
table.

§Compare-to-cycle-182-debugger's §sibling-design-pair with
178. §All-three-form-a §xs-worker-capability-trio where each
member explicitly cites the others.
