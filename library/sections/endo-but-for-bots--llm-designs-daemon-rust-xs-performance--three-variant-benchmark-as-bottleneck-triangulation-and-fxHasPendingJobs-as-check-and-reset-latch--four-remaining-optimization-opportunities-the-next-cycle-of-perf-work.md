---
source: designs/daemon-rust-xs-performance.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-rust-xs-performance.md
section_kind: design
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - daemon
  - tooling
status_at_ingest: Active
genre: §endo-but-for-bots-design §performance-investigation
cycle: 188
lane: designs
status: current
title: §Four-remaining-optimization-opportunities (the §next-cycle of perf work)
parent: endo-but-for-bots--llm-designs-daemon-rust-xs-performance--three-variant-benchmark-as-bottleneck-triangulation-and-fxHasPendingJobs-as-check-and-reset-latch
---

```
1. JSON encode/decode in CapTP payload
2. Channel bridge scheduling latency
3. Worker spawn latency
4. String info cache
```

§Each-opportunity-is-named-with-an-attribution to a specific
mechanism. §`JSON encode/decode` lives in `connection.js`;
§`channel bridge` lives in the supervisor↔manager interface;
§`worker spawn latency` lives in `provideWorker`; §`string info
cache` lives in `build.rs:147`.

§Compare-to-cycle-180-hex-package's §five-known-gaps and cycle
178-snapshot's §revised-scope-discussion. §This-design-names-
known-future-work-with-attribution rather than open-ended
TODOs.
