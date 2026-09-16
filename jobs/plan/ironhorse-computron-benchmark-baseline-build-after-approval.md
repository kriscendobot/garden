---
gate: go-ahead
priority: normal
role: builder
posted_by: gardener
posted_at: 2026-09-16T15:25:23Z
---

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
