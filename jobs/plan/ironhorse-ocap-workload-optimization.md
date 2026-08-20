---
gate: go-ahead
priority: normal
posted_by: producer
posted_at: 2026-08-17T21:30:40Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: designer
handler-timeout: 7200

Investigate optimizing ironhorse for OCAP WORKLOADS. Tracked at the maintainer's
request 2026-08-17; parked pending go-ahead, not to be run yet (see PRECONDITIONS).

## The thesis

Object-capability code has a characteristic allocation profile that a general
JavaScript engine is not tuned for. Facet-heavy, method-per-capability designs
allocate very many small closures, and SES-style code hardens nearly everything,
so frozen objects dominate the heap. Two consequences the maintainer wants
pursued:

1. **Closure allocation analogous to hidden classes.** Where hidden classes give
   objects a shared shape so field access is a fixed offset, do the equivalent for
   CLOSURES: allocate a fragment and MEMCOPY A TEMPLATE at construction time,
   rather than building each closure's environment record from scratch. The
   template is derived once per closure-creating site; construction becomes a
   copy.

2. **Exploit the immutability of frozen and hardened objects.** Once an object is
   frozen (and more so once hardened, transitively frozen), a large class of
   checks, barriers, and defensive copies become provably unnecessary, and
   representations that would be unsafe for mutable objects become available.
   Enumerate what immutability actually buys in this engine and take it.

## The methodology, which is the load-bearing part

This is a BENCHMARK-DRIVEN engagement: **hold the tests fixed and advance speed.**
Conformance is the invariant, not the goal. The test262 corpus is the guardrail;
every change must leave it unmoved, and the metric that moves is time. Any
optimization claim closes with a posted benchmark result or an explicit
"not pursuing" rationale, which is exactly the discipline the `benchmarker` juror
seat already enforces (`roles/jurors/benchmarker/AGENT.md`, a seat created because
"the agent proposed optimizations, the maintainer asked did you benchmark, the
result never came back").

This inverts ironhorse's current posture. Ironhorse to date has been
CORRECTNESS-driven: tests move, speed is incidental. Here tests must NOT move.
Say so explicitly in the design, because the two postures want different job
shapes, different definitions of done, and different failure signals.

## Grounding, verified 2026-08-17

- `rust/endo/benches/` exists on `llm` but contains only `codec.rs`. The
  Criterion-style harness convention is established; the ocap-workload benchmark
  corpus does NOT exist. Building it is therefore the FIRST milestone, not a
  precondition someone else supplies. A speed engagement without a trustworthy
  baseline measures nothing.
- ironhorse's engine is Moddable XS via the `xsnap` crate (`rust/endo/xsnap/`),
  pinned through the `c/moddable` submodule. Both optimizations are engine-level
  and therefore land in that surface, which has implications for the submodule pin
  and for how changes are carried.

## PRECONDITIONS, both real

1. **Ironhorse development is PAUSED** from 2026-08-16 to conserve budget (marker
   `jobs/plan/ironhorse-campaign-paused-20260816`; honest spend 3.3M against 2.08M
   approved). Do not promote this against the pause without the maintainer saying
   so.
2. **The test baseline is currently REGRESSED.** As of the pause, the accumulated
   branch sits BELOW its 08-08 baseline: 6 baseline-covered paths regressed and
   185 RegExp negative over-acceptances, which job
   `ironhorse-branch-regression-fixer` was promoted to repair. You cannot run a
   "hold the tests fixed" engagement while the tests are not fixed. That repair
   must land first, or this engagement has no stable baseline to hold and no
   trustworthy signal for whether an optimization broke something.

## Expected shape on promotion

Produce a DESIGN first, then decompose. Per the standing multi-part pattern
(kriskowal 2026-07-01), the follow-on work should be parked children plus ONE
orchestration job, not a loose pile. Candidate strands, for the design to confirm
or replace: the benchmark corpus, closure-template allocation, frozen-object
exploitation, and a per-milestone conformance gate. Also fit this to the pause's
MILESTONE-PR decision rather than the retired handler-per-cluster shape.

Open questions the design should answer rather than assume: what an "ocap
workload" benchmark actually contains and where representative code comes from;
whether the two optimizations are independent or share a representation change;
and what regression threshold counts as "tests unmoved" given known flakes.

<!-- garden-annotation: key=pr1040-comment-5362099915-hardened262 by=gardener at=2026-08-20T21:47:37Z -->

https://github.com/endojs/endo-but-for-bots/pull/1040 will make hardened262 available to this work after it merges. Use hardened262 to ratchet Iron Horse parity and test262 coverage more freely, and consolidate overlapping test suites where that preserves useful mode-specific coverage evidence.
