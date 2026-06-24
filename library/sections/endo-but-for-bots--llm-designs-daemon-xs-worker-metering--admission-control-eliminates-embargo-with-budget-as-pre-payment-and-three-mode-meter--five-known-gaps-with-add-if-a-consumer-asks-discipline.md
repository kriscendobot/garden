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
title: §Five-known-gaps-with-§add-if-a-consumer-asks-discipline
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter
---

```
- [ ] Determine the right default metering interval for
      measurement-only mode (1 vs 1000 vs 10000).
- [ ] Memory metering: XS tracks allocatedSpace and
      currentHeapCount — these could be included in
      meter reports and optionally enforced.
- [ ] Nested calls: if worker A calls worker B via CapTP
      sync call, A's meter is paused while waiting...
- [ ] What hard_limit value is appropriate?
- [ ] Should the supervisor attempt to snapshot a worker
      before terminating it on hard-limit violation?
- [ ] Rate-limit time source: Instant::now() is monotonic
      but not preserved across daemon restarts.
```

§Six-known-gaps-as-checkbox-list. §Each-gap-names-the-question
and §when-relevant the §trade-off (e.g., "Too low: legitimate
expensive cranks get killed. Too high: infinite loops take a
long time to detect.").

§Compare-to-cycle-180-hex-package's §five-known-gaps + cycle
178's §revised-scope-discussion + cycle 174-gateway-package's
§seven-open-questions. §All-four-are-§honest-known-gap-
disclosure patterns.

§The-§snapshot-before-termination-gap (gap 5) is interesting
— it sketches a future where a worker that hits hard-limit gets
snapshotted-for-forensics before being terminated. §This-
links-back-to-cycle-178-snapshot's-§transparent-resume — but
adds a §post-mortem-snapshot dimension.
