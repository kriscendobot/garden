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
---

# Admission control eliminates embargo, with budget-as-pre-payment, hard-limit-as-termination, and three-mode meter (Measurement / Quota / Rate-limited)

> §Designs-lane after cycle 183's chat-lane. §The-eighteenth-
> consecutive designs/chat alternation cycle (166-184). §Status:
> **Complete** — all seven phases implemented and tested.
> §This-ingest-completes-the-§xs-worker-capability-trio with
> cycle 178 (snapshot) + cycle 182 (debugger).

`daemon-xs-worker-metering.md` (829 lines, Created 2026-04-17,
Status **Complete**) designs measurement, quota enforcement,
and rate limiting for XS workers' computrons (the "computation
step" count XS already maintains via `meterIndex`).

§The-design-is-a §three-design-sibling-trio member:

| Cycle | Design | Status | Capability |
|-------|--------|--------|------------|
| 178 | daemon-xs-worker-snapshot | In Progress | suspend/resume |
| 182 | daemon-xs-worker-debugger | In Progress | inspect/control |
| **184** | **daemon-xs-worker-metering** | **Complete** | **measure/quota/rate-limit** |

§All-three-extend the cycle 176 endor Rust supervisor with
non-obvious worker-level capabilities; §all-three-use-the-
envelope-bus as the control plane. §The-metering-design is the
only one currently Complete.

§The-single-most-structurally-interesting-move is §admission-
control-eliminates-embargo combined with §budget-as-pre-
payment-not-post-payment. §The-architectural-insight: ensure
budget ≥ worst-case-cost before delivery, so the simpler
invariant ("no embargo needed") holds — any crank that
completes normally is fully paid for at delivery time.

## §The-§Key-Insight-section (the design names it explicitly)

§Lines-77-102-contain-a-named-§Key-Insight section:

> An earlier revision of this design proposed embargoing a
> worker's outbound messages during each crank and discarding
> them if the crank was aborted by quota exhaustion. This is
> complex: it requires buffering in the bridge layer, crank-
> boundary delimiters, and reasoning about partial effects.
>
> A simpler model avoids embargo entirely:
> - **Hard per-crank limit**: a safety net that terminates the
>   worker if a single crank exceeds a fixed step threshold.
> - **Admission control**: the supervisor only delivers a
>   message when the worker's remaining budget exceeds the
>   hard limit.
> - Since any crank that completes normally used fewer steps
>   than the limit, the budget is always sufficient to cover
>   the crank's cost.

§The-§Prompt-section-at-the-end (lines 802-829) preserves both
the original embargo-based formulation and the §design-
evolution-realization:

> It just occurred to me that there is a simpler way to do
> quota based metering, avoiding the need to embargo anything.
> We can instead set a hard limit on the number of steps a
> worker can take after a message is delivered, after which
> the worker is considered hung and simply terminated...

§Two-prompts-in-one-design-file. §The-design-records-its-own-
evolution. §Compare-to-cycle-178-daemon-xs-worker-snapshot's
§revised-scope-discussion-2026-04-15 and cycle 180-hex-package's
§design-phase-after-implementation-phase + cycle 183-init's
"Initialization is often awkward". §All-four-are §honest-
design-evolution-record patterns. §This-one-records-the
*earlier-rejected-approach* explicitly in the prompt block.

## §The-architectural-invariant (admission control)

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

## §Three-modes (the meter mode lattice)

| Mode | Behavior |
|------|----------|
| **Measurement** (default) | Steps counted per crank; no enforcement. Limit=0 means callback always returns true. |
| **Quota** | Fixed budget; messages buffered until budget ≥ hard_limit. Hard-limit-exceed = worker terminated. |
| **Rate-limited** | Quota plus automatic accumulation at `rate` computrons/sec, clamped at `burst`. |

§Three-modes-from-simplest-to-most-complex. §Measurement-as-
default — §zero-overhead-except-callback (interval=10000 means
one function call per ~10000 bytecode dispatches). §Rate-
limited-builds-on-quota by adding §lazy-refill.

§Compare-to-cycle-167-where/index.js's §four-state-domains
(durable / ephemeral / sock / cache). §Cycle-184-has §three-
modes; cycle 167 had §four-state-domains. §The-pattern-is
§named-modes-as-discriminated-union — make the dimensions of
the problem space explicit.

§Compare-to-cycle-180-hex-package's §three-way-classification-
of-sites (migration / boundary / non-byte-array). §Three-way-
classification is the canonical-Design-Decisions count.

## §Layered-architecture (the two-thread spine)

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

## §Budget-as-pre-payment-not-post-payment (Decision 5)

```
budget represents *available* steps, not a credit limit.
Steps are subtracted after each crank.
Messages are only delivered when the budget can cover
the worst case (hard limit).
```

§Pre-payment = §spend-from-budget-after-the-fact-but-only-
commit-when-budget-can-cover-worst-case.

§The-result: §actual-crank-cost-may-be-much-less-than-hard_
limit, §leaving-budget-for-the-next-crank. §A-budget-of
10×hard_limit doesn't mean 10 cranks — it means "at least 10
cranks, often more if cranks complete cheaply".

§Compare-to-the-rejected-embargo-model: that model would have
required §post-payment via outbound-buffering, where if the
crank aborted, the buffered outputs are discarded. §Pre-payment-
admission-control-eliminates-the-need.

§Compare-to-cycle-181-base64's §native-error-fallback-via-
polyfill-rerun: that pays §two-decode-runs-on-the-error-path
for §best-possible-diagnostic. §Both-are-§trade-off-named-
explicitly patterns; the cost is paid on a specific path so
the happy-path is clean.

## §Hard-limit-as-termination-not-pause (Decision 2)

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

## §Lazy-rate-limit-refill (Decision 3)

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

## §Burst-ceiling-prevents-budget-hoarding (Decision 4)

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

## §meter-config-once-not-per-crank (Decision 7)

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

## §Seven-Design-Decisions (the canonical format)

| # | Decision | Reason |
|---|----------|--------|
| 1 | Admission control instead of embargo | Eliminates the most complex part of earlier design |
| 2 | Hard limit as termination, not pause | XS state after metering abort is unreliable; worker can be re-created from snapshot |
| 3 | Lazy rate-limit refill | Avoids timer overhead; gives exact results; ready_time enables single wake-up |
| 4 | Burst ceiling prevents budget hoarding | Bounds the steady-state rate even after long idle |
| 5 | Budget as pre-payment, not post-payment | Worst-case-coverage at delivery time means no rollback |
| 6 | Measurement-only as default | Always-on with limit=0; negligible overhead |
| 7 | meter-config envelope for hard-limit, not per-crank | Hard limit rarely changes; admission gate lives in supervisor |

§Compare-to-cycle-180-hex-package's §eight + cycle 178's §six +
cycle 182's §seven. §Seven-Decisions matches cycle 182.
§The-§canonical-Design-Decisions-format honored throughout the
endo-but-for-bots design corpus.

## §Five-control-verbs + §meter-report (the verb taxonomy)

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

## §Snapshot-integration (Phase 6, the trio cohesion)

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

## §Seven-phases-all-Complete

| Phase | What | Status |
|-------|------|--------|
| 1 | Machine metering API + 9 unit tests | Complete |
| 2 | Crank-level metering in reactive pump loop | Complete |
| 3 | Supervisor MeterState + 11 codec round-trip tests | Complete |
| 4 | Admission gate (route_message check + pending_delivery buffer) | Complete |
| 5 | Rate limiting (lazy refill + ready_time scheduling) | Complete |
| 6 | Snapshot integration (SuspendedWorker.meter) | Complete |
| 7 | JS manager integration (controlPowers extensions) | Complete |

§Status-Complete with the Status section enumerating each
phase + file paths + test counts (9 metering + 11 codec round-
trip = 20+ tests).

§The-§C-helpers section names §custom-fxAbort (longjmp for
recoverable aborts instead of `exit()`) — §a-non-obvious-C-
contribution required to make the §hard-limit-termination
recoverable-at-the-supervisor-level.

§Compare-to-cycle-180-hex-package's §design-phase-after-
implementation-phase. §This-design-shipped-with-Status-Complete-
and-named-phase-completions-with-file-paths-in-the-Status-
section. §The-design-document-is-the-archive-of-validated-
disciplines.

## §Five-known-gaps-with-§add-if-a-consumer-asks-discipline

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

## §Cohesion notes

- §Sibling-design-pair with cycle 178 (worker-snapshot) +
  cycle 182 (worker-debugger). §The-trio-is-complete; this
  design cites both siblings in its Dependencies table.
- §Admission-control-eliminates-embargo is the §key-insight
  the design names explicitly — a §design-evolution-record in
  the Prompt section.
- §Budget-as-pre-payment-not-post-payment with §worst-case-
  coverage at delivery time = §no-rollback-needed.
- §Hard-limit-as-termination-not-pause depends on cycle 178's
  snapshot infrastructure for re-creation; the trio coheres.
- §Lazy-rate-limit-refill (on-demand vs background-timer) is
  the §third-flavor between cycle 156's GC-driven and cycle
  173's known-event-immediate.
- §Burst-ceiling-prevents-budget-hoarding is a §structural-
  bound-not-runtime-decision.
- §Three-modes (Measurement / Quota / RateLimited) with
  Measurement-as-default = §named-modes-as-discriminated-union.
- §Two-thread-architecture (supervisor tokio + XS thread)
  simpler than cycle 182's §six-layer-stack because the
  problem is simpler.
- §Seven-Design-Decisions in the §canonical-format.
- §Five-control-verbs + meter-report + meter-config = seven
  envelope verbs in the meter taxonomy.
- §Seven-phases-all-Complete with file paths + test counts
  in the Status section.
- §Six-known-gaps-honestly-disclosed.
- §custom-fxAbort C helper (longjmp instead of exit) is the
  §non-obvious-C-contribution making hard-limit-termination
  recoverable.

## §Tier-1 borrowing

- §admission-control-eliminates-embargo (worst-case-coverage at
  delivery eliminates the need for output buffering)
- §exploit-a-pre-condition-to-eliminate-a-mechanism (sibling
  to cycle 182's §exploit-the-pre-jump-window)
- §budget-as-pre-payment-not-post-payment (actual cost may be
  much less than guaranteed cost; leaves budget for next)
- §hard-limit-as-termination-not-pause (XS state after abort
  unreliable; snapshot infrastructure provides re-creation)
- §three-mode-meter (Measurement default / Quota / Rate-limited)
- §named-modes-as-discriminated-union
- §lazy-rate-limit-refill (compute-on-demand; no background
  timer)
- §ready_time-as-tokio-scheduling-hint (single wake-up rather
  than polling)
- §burst-ceiling-prevents-budget-hoarding (structural bound)
- §meter-config-once-not-per-crank (admission gate lives in
  supervisor)
- §custom-fxAbort-via-longjmp (recoverable abort instead of
  process exit)
- §design-evolution-record-in-prompt-section (preserves both
  earlier-rejected-approach and the realization)

## §Synthesis-target

The §slot-machine-library's worker-layer-quota-and-rate-
limiting (if it has any) can §borrow-the-three-mode-meter +
§admission-control-pre-payment + §lazy-rate-limit-refill +
§burst-ceiling-prevents-hoarding patterns directly. §The-
admission-control-pattern is the §key-takeaway: enforce
worst-case-coverage at delivery time to eliminate rollback
machinery.

§The-§xs-worker-capability-trio-architecture (snapshot +
debugger + metering as three sibling capabilities sharing
endor substrate) is a §borrowable-architectural-pattern
wherever §multiple-worker-level-capabilities-share-a-
supervisor-bus.
