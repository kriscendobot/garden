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
title: §Five-control-verbs + §meter-report (the verb taxonomy)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter
---

| Verb | Direction | Purpose |
|------|-----------|---------|
| `meter-query` | daemon → supervisor | Request current MeterState |
| `meter-reset` | daemon → supervisor | Reset accumulated counter to 0 |
| `meter-set-quota` | daemon → supervisor | Enable Quota mode with hard_limit + budget |
| `meter-set-rate` | daemon → supervisor | Enable RateLimited mode with hard_limit + rate + burst |
| `meter-refill` | daemon → supervisor | One-time budget top-up |
| `meter-config` | supervisor → worker | One-shot hard_limit communication |
| `meter-report` | worker → supervisor | Per-crank `{steps, outcome}` report |

§Seven-verbs-total. §Six-control-verbs (five daemon→supervisor
+ one supervisor→worker) + §one-outbound (worker→supervisor).
§All-payloads-CBOR-maps; §all-target-handle-0-for-supervisor-
control.

§Compare-to-cycle-178-snapshot's §four-control-verbs (suspend/
suspended/suspend-error/restore) and cycle 182's §three-debug-
verbs (debug + debug-attach + debug-detach). §Each-worker-
capability-layer adds its own envelope vocabulary; §all-three
fit cycle 176's §byte-identical-CBOR-envelope discipline.
