---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-16T23:38:11Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# builder: implement the Ironhorse computron benchmark-baseline regime after approval

Successor to `ironhorse-computron-benchmark-baseline-build-exec`. Implement steps
2-8 of `designs/ironhorse-computron-benchmark-baseline.md` from
endojs/endo-but-for-bots#1283 against `llm`, as directed by
https://github.com/endojs/endo-but-for-bots/pull/1282#issuecomment-5692322970.

## Promotion gate

Do not promote or begin until a trusted maintainer has:

1. explicitly lifted the standing Ironhorse pause for this scoped work;
2. answered the design's Open questions, especially the authoritative seed roster
   and tolerance bands, or directed use of the recommended defaults; and
3. approved endojs/endo-but-for-bots#1283, or explicitly directed the build to
   proceed before design approval.

The implementation also requires a controlled, host-suitable benchmark environment
for release wall-clock measurements. The linuxkit garden container is not suitable
for committing representative medians.

## Work owned by this successor

- Define the committed baseline record and growth-class bands.
- Build deterministic exact-pin and growth-envelope gates plus the baseline recorder.
- Build the nightly wall-clock class/fidelity gate.
- Seed the approved roster, including every unconstrained load found by the predecessor
  audit: async-generator await, suspend-in-try, promise-combinator boundaries, and
  representative regexp matching.
- Wire deterministic gates into ordinary Rust CI and wall-clock checks into the
  nightly benchmarks job.
- Reconcile the metering rule and merge ordering with endojs/endo-but-for-bots#1282.
- Record controlled-host release medians and full nightly-lane evidence.
- Open one draft PR through `scripts/jobs/gardening/ensure-pr.sh` against `llm`,
  carrying the predecessor's step-1 audit in its body.

Use the isolated project worktree helper with this successor's job basename. If the
approved design still decomposes into multiple ordered builds, post parked child jobs
and a serial orchestration rather than loose follow-ups.

<!-- garden-annotation: key=maintainer-withholding-20260916 by=liaison at=2026-09-16T23:29:09Z -->

## Maintainer withholding — authority WITHHELD (kriskowal, liaison muster 2026-09-16)

Recorded from a maintainer directive that was addressed to the completed
predecessor `ironhorse-computron-benchmark-baseline-build-exec` and dead-lettered
to `deadmail-20260916T232300Z-07f109`. Authority is WITHHELD on both promotion
counts. This job STAYS PARKED.

- **Promotion gate (1) — Ironhorse pause: NOT lifted.** The repository-wide
  Ironhorse pause STAYS IN FORCE (kumavis, 2026-09-09, endojs/endo-but-for-bots#91;
  `roles/COMMON.md`). It was not lifted for this scoped work. A future request that
  does not explicitly lift it keeps this parked.
- **Promotion gate (2) — Open questions: NOT answered.** The six open questions on
  endojs/endo-but-for-bots#1283 (authoritative seed roster, tolerance bands, etc.)
  are NOT being answered while the pause holds. Do not press on them.
- **Promotion gate (3) — design NOT approved.** endojs/endo-but-for-bots#1283 is
  NOT approved over its unresolved must-fix panel findings.

Do not promote until a trusted maintainer explicitly lifts the Ironhorse pause AND
answers the design's open questions (or directs recommended defaults) AND approves
#1283 (or directs a build before approval) — and the controlled, host-suitable
benchmark environment noted below is available.
