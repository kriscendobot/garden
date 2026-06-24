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
title: §Lazy-rate-limit-refill (Decision 3)
parent: endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter
---

```rust
fn refill(&mut self) {
    if let Some(ref mut rl) = self.rate_limit {
        let now = Instant::now();
        let elapsed = now.duration_since(rl.last_refill);
        let earned = (elapsed.as_secs_f64() * rl.rate as f64) as u64;
        self.budget = (self.budget + earned).min(rl.burst);
        rl.last_refill = now;
    }
}
```

§Lazy = §compute-on-demand-not-by-background-timer. §The-
budget-is-recomputed-when:

- §A-new-message-arrives for the worker.
- §A-`meter-query`-verb is received.
- §The-routing-loop-polls the worker's readiness.

§The-design-names-the-trade-off explicitly: "This avoids timer
overhead for idle workers and gives exact results."

§Compare-to-cycle-156-finalize.js' §weak-value-map pattern
(reclaim-when-GC-runs); cycle 173 promise-executor-kit's
§reference-release-on-settle (immediate-release on known
event). §Cycle-184-rate-refill-is §compute-when-asked which is
the §third-flavor: §not-immediate-not-deferred-but-on-demand.

§The-§ready_time-computation lets the supervisor schedule a
single tokio wake-up rather than polling:

```rust
fn ready_time(&self) -> Option<Instant> {
    match self.mode {
        MeterMode::Measurement => None,
        MeterMode::Quota => {
            if self.budget >= self.hard_limit { None }
            else { None }  // never, until explicit refill
        }
        MeterMode::RateLimited => {
            if self.budget >= self.hard_limit { return None; }
            let deficit = self.hard_limit - self.budget;
            let seconds = deficit as f64 / rl.rate as f64;
            Some(rl.last_refill + Duration::from_secs_f64(seconds))
        }
    }
}
```

§Three-mode-branching: Measurement always ready; Quota waits
for explicit refill; Rate-limited can compute a specific wake-
up time. §The-tokio-supervisor-uses-`sleep_until(ready_time)`
to wake when budget is sufficient.
