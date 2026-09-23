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
title: §Hard-limit-as-termination-not-pause (Decision 2)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter
---

§When-the-metering-callback-fires, the crank exceeded the hard
limit. §The-design-treats-this-as-fatal: §destroy-the-worker.

```
Rationale:
- A crank that exceeds the hard limit is either an infinite
  loop or a computation so expensive it shouldn't run.
- The XS machine state after an abort is uncertain — promise
  queues may be partially drained, shared closures may be in
  inconsistent states.
- Terminating is the only safe option.  The supervisor can
  re-create the worker from its last snapshot if needed
  (suspend/resume infrastructure).
```

§Three-named-reasons. §The-third-cites cycle 178 (the
suspend/resume infrastructure). §The-trio-coheres: snapshot
provides the recovery path; metering depends on it for the
hard-limit-termination-is-acceptable invariant.

§Compare-to-cycle-182-debugger's §four-edge-cases-named-and-
defended including §finally-without-catch-as-known-limitation.
§Both-are-§rationale-table patterns — name the choice + name
the alternative + name the trade-off.

§The-worker-side-flow on hard-limit hit:

1. `XS_TOO_MUCH_COMPUTATION_EXIT` fires via `longjmp`.
2. The worker sends a final `meter-report` with
   `outcome: "terminated"`.
3. The worker exits its main loop.
4. The supervisor receives the report and cleans up.

§Cycle-178-snapshot's §callback-table-is-append-only and
§stable-indices-across-suspend-resume ensure the supervisor can
re-create the worker; §cycle-184-metering's §hard-limit-
termination depends on that re-creation path being available.
