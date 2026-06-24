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
title: §meter-config-once-not-per-crank (Decision 7)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter
---

```
verb: "meter-config"
payload: { "hard_limit": <u64> }
```

§The-supervisor-sends-this-once-at-worker-startup-or-when-the-
limit-changes. §The-worker-stores-it-in-a-thread-local and
uses it as `CRANK_LIMIT` for every crank.

§Why-not-per-crank: §admission-gate-lives-in-supervisor; the
worker only needs the hard limit for its safety-net callback.
§Per-crank-budget-envelope would be overhead with no
correctness benefit.

§Compare-to-cycle-182-debugger's §thread-local-buffers-with-
mutex. §This-design has §thread-local-CRANK_LIMIT (no mutex
needed — only the worker thread reads/writes it).
