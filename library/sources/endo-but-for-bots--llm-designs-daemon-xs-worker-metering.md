---
title: 'endo-but-for-bots designs/daemon-xs-worker-metering.md — Measurement, Quotas, Rate Limiting'
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_url: https://github.com/endojs/endo-but-for-bots/blob/llm/designs/daemon-xs-worker-metering.md
source_paths:
  - designs/daemon-xs-worker-metering.md
authors:
  - Kris Kowal (prompted)
created: 2026-04-17
updated: 2026-04-17
status_at_ingest: Complete
ingested: 2026-06-03
ingested_by: scholar
topics:
  - daemon
  - capability-security
sections:
  - endo-but-for-bots--llm-designs-daemon-xs-worker-metering--admission-control-eliminates-embargo-with-budget-as-pre-payment-and-three-mode-meter.md
genre: §endo-but-for-bots-design §sibling-design-trio
cycle: 184
lane: designs
---

# XS Worker Metering: Measurement, Quotas, and Rate Limiting (design)

## §Abstract

829-line **Complete** design (all seven phases tested) for
measurement, quota enforcement, and rate limiting of XS workers'
computation steps ("computrons"; XS already maintains
`meterIndex` for this).

§The-design-completes-the-§xs-worker-capability-trio with
cycle 178 (snapshot) and cycle 182 (debugger).

§The-key-insight: §admission-control-eliminates-embargo. An
earlier draft proposed buffering and rolling back outbound
messages if a crank aborted on quota exhaustion. The simpler
model: §only-deliver-a-message-when-budget-≥-hard-limit,
treating any hard-limit hit as a fatal worker-termination
(state after abort is unreliable; supervisor re-creates worker
from cycle 178 snapshot).

§Three-modes (Measurement default / Quota / Rate-limited). §All-
metering-is-always-on at the XS-machine level (limit=0 = no
enforcement). §Lazy-rate-limit-refill computed on demand (no
background timer); ready_time enables single tokio wake-up.

§Two-thread-architecture: supervisor (tokio) owns MeterState +
admission gate; XS thread owns meterIndex + CRANK_LIMIT thread-
local + safety-net callback. §Communication via envelope verbs
(meter-config once + meter-report per crank).

§Six-control-verbs (meter-query / meter-reset / meter-set-
quota / meter-set-rate / meter-refill / meter-config) + §one-
outbound (meter-report worker→supervisor).

§Snapshot-integration: MeterState round-trips through suspend/
resume; last_refill recomputed on resume to avoid crediting
idle time during suspension.

## §Files and identifiers

| File | Lines | Role |
|------|-------|------|
| `designs/daemon-xs-worker-metering.md` | 829 | The design being ingested |
| `rust/endo/xsnap/src/lib.rs` | — | Machine metering API (begin/end/current/set; reactive pump loop) |
| `rust/endo/xsnap/xsnap-platform.c` | — | Custom fxAbort + fxRunPromiseJobsMetered + getter/setter |
| `rust/endo/src/supervisor.rs` | — | MeterState + should_deliver admission gate |
| `rust/endo/src/types.rs` | — | RateLimit struct + lazy refill |
| `rust/endo/src/codec.rs` | — | meter-* envelope encode/decode |
| `rust/endo/src/endo.rs` | — | Routing + tokio sleep_until scheduling |
| `rust/endo/xsnap/src/daemon_bootstrap.js` | — | JS manager controlPowers extensions |

## §Dependencies and lineage

- §Sibling-design-pair (Dependencies table cites):
  - cycle 178 (`daemon-xs-worker-snapshot.md`) — "suspend/
    resume must preserve meter state" + the §re-create-from-
    snapshot path that makes hard-limit-termination acceptable.
  - cycle 176 (`daemon-endor-architecture.md`) — parent
    design defining worker platforms.
  - `daemon-rust-xs-performance.md` (un-ingested) — sibling
    "reactive pump loop integration."
- §The-xs-worker-capability-trio: snapshot + debugger + this
  metering, all sharing cycle 176 endor substrate.
- §Spec-source: XS engine internals (`fxBeginMetering`,
  `fxEndMetering`, `meterIndex`, `XS_BUILTIN_METERING`,
  `XS_TOO_MUCH_COMPUTATION_EXIT`).

## §Related sources in the library

- §Cycle 178 (`endo-but-for-bots--llm-designs-daemon-xs-
  worker-snapshot.md`) — §xs-worker-trio-sibling. Provides the
  re-creation path that makes §hard-limit-termination
  acceptable.
- §Cycle 182 (`endo-but-for-bots--llm-designs-daemon-xs-
  worker-debugger.md`) — §xs-worker-trio-sibling. Both
  exploit a §pre-condition to eliminate a mechanism:
  debugger exploits pre-jump-window to avoid backtracking;
  metering exploits pre-delivery budget-sufficient to avoid
  embargo.
- §Cycle 176 (`endo-but-for-bots--llm-designs-daemon-endor-
  architecture.md`) — parent substrate the trio shares.
- §Cycle 156 (`endo--packages-captp-src-finalize-js.md`) —
  §weak-value-map sibling. Cycle 184's §lazy-rate-limit-refill
  is the §third-flavor (compute-on-demand) between cycle 156's
  GC-driven and cycle 173's known-event-immediate.
- §Cycle 173 (`endo--packages-promise-kit-src-promise-
  executor-kit-js.md`) — §reference-release-on-settle
  immediate-release sibling.
- §Cycle 180 (`endo-but-for-bots--llm-designs-hex-package.md`)
  — §design-after-implementation-as-ratification sibling.
  Both record honest design evolution; cycle 184 preserves the
  evolution in the §Prompt-section directly.

## §Comment fragments worth preserving (from the design prose)

```
A simpler model avoids embargo entirely:
- Hard per-crank limit: a safety net that terminates the
  worker if a single crank exceeds a fixed step threshold...
- Admission control: the supervisor only delivers a message
  when the worker's remaining budget exceeds the hard limit.
- Since any crank that completes normally used fewer steps
  than the limit, the budget is always sufficient to cover
  the crank's cost.
```

§The-named-§Key-Insight section. §Three-bullets-that-make-the-
invariant-explicit.

```
Because messages are only delivered when the budget can cover
the worst case, a normally-completing crank never needs its
output rolled back.  The only case where output could be
partial is the hard-limit termination, which destroys the
worker anyway.
```

§The-§no-rollback-needed proof. §Pre-payment + hard-limit-
terminates = §the-only-partial-case-is-also-the-destructive-
case.

```
It just occurred to me that there is a simpler way to do quota
based metering, avoiding the need to embargo anything...
```

§The-§design-evolution-record in the §Prompt section. §Preserves-
both-the-rejected-approach (embargo) and the §realization (admission control).

```
The XS machine state after an abort is uncertain — promise
queues may be partially drained, shared closures may be in
inconsistent states.  Terminating is the only safe option.
```

§Decision-2-rationale-named-explicitly. §Why-pause-isn't-an-
option even though it might seem more humane.

```
This is the key simplification: because the worker always has
at least hard_limit steps of budget when a crank begins,
any crank that completes normally (under the hard limit) is
fully paid for.  No embargo, no rollback, no buffering of
outbound messages.
```

§The-§key-simplification declared-as-key. §Three-mechanisms-
eliminated (embargo / rollback / outbound-buffering) by the
admission-control invariant.
