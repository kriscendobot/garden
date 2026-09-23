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
title: §Layered-architecture (the two-thread spine)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter
---

```
┌─────────────────────────────────────────────────────┐
│  Supervisor  (tokio)                                │
│  ┌───────────────────────────────────────────────┐  │
│  │  Per-worker MeterState                        │  │
│  │  accumulated: u64        (lifetime total)     │  │
│  │  budget: u64             (current balance)    │  │
│  │  hard_limit: u64         (per-crank ceiling)  │  │
│  │  rate: Option<RateLimit> (refill policy)      │  │
│  └───────────────────────────────────────────────┘  │
│       ▲ meter-report  │ admission gate              │
│       │               ▼                             │
│   [only deliver when budget >= hard_limit]          │
│                                                     │
├─────────────────────────────────────────────────────┤
│  XS Machine Thread                                  │
│  ┌───────────────────────────────────────────────┐  │
│  │  fxBeginMetering(callback, interval)          │  │
│  │  meterIndex  (raw step counter)               │  │
│  │  Metering callback → terminate on hard limit  │  │
│  └───────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────┘
```

§Two-thread-architecture: supervisor (tokio) owns MeterState;
worker (XS thread) owns meterIndex + CRANK_LIMIT thread-local.

§Cycle-182-debugger had §six-layer-strict-stratification (C
hooks → Rust callbacks → bus → SAX → exo → UI). §This-design
has §two-layers; the simpler problem needs less stratification.

§The-supervisor-owns-budget-and-accounting; §the-worker-owns-
the-step-counter-and-safety-net-abort. §Communication-via-
envelope-verbs (meter-config + meter-report).
