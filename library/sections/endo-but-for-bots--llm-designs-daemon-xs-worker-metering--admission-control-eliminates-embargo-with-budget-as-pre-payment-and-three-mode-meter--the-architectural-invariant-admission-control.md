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
title: §The-architectural-invariant (admission control)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter
---

```rust
fn should_deliver(&self, meter: &MeterState) -> bool {
    match meter.mode {
        MeterMode::Measurement => true,  // always deliver
        MeterMode::Quota | MeterMode::RateLimited => {
            meter.budget >= meter.hard_limit
        }
    }
}
```

§The-invariant: `budget >= hard_limit` at delivery time.
§Consequence: §any-crank-that-completes-normally-uses-fewer-
than-hard_limit-steps so §the-budget-is-always-sufficient-to-
cover-the-crank's-cost.

§The-only-partial-effect-case is hard-limit-hit, which
§terminates-the-worker-anyway (XS state after a metering abort
is unreliable: partially-drained promise queues, inconsistent
closures). §No-output-rollback-needed because the only path
to incomplete output is the path that destroys the worker.

§Compare-to-cycle-182-debugger's §exploit-the-pre-jump-window-
as-the-decision-point. §Both-are-§exploit-a-pre-condition-to-
eliminate-a-mechanism. §Debugger-exploits-fxDebugThrow-before-
fxJump to avoid backtracking; §metering-exploits-budget-
sufficient-at-delivery to avoid embargo.
