---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Improve review of architectural boundary ownership

Cluster: `review-misses/clusters/architectural-boundary-ownership.md`

Member miss:

- `review-misses/misses/endojs-endo-but-for-bots-pr1018-review-eccc706c.md`
  (`endojs/endo-but-for-bots#1018`, review 5069628663)

This cluster crossed the dispatch floor through the single-major standing-rule
bypass. A central design assigned engine, supervisor, persistence, and crank
responsibilities ambiguously after six design-panel rounds, even though the
critic's adjacent-module composition check, the decomplector's concern-
separation check, and the novice's architectural mental-model check already
covered the failure in principle.

Deliver both halves below. A completion that supplies only one is incomplete.

## (a) Prevention in producing work

Amend the narrowest design-authoring role or skill so a design spanning multiple
components or layers states an explicit ownership map before review. The map
must distinguish at least mechanism, policy, durable state, lifecycle/commit
authority, and the value crossing each boundary. It must expose vocabulary that
wrongly imports an outer layer's concept into an inner layer, as `CrankOutcome`
did for an engine that only evaluates and runs to quiescence. Prefer a reusable,
checkable design artifact over a reminder that depends on memory.

## (b) Durable review-cycle sensing

Add a durable design-panel check that reconstructs and challenges the same
ownership map. Use a deterministic panel-stage check when a reliable signal is
available. Otherwise amend the most appropriate existing seat brief, with a
panel-hints probe when the historical diff offers a useful signal. The check
must ask who owns persistent state, commit/discard decisions, restart/replay,
and execution classification, then flag APIs or names that assign an outer-
layer lifecycle concept to the inner mechanism.

## Re-litigation test

Demonstrate against the historical PR #1018 design at reviewed commit
`efcf04a26d1114d1d1c90f52895eec7e8f49fc54` that the new check fires on its
Ironhorse/Slot Machine boundary. Name the exact gate, probe plus seat line, or
seat check that catches the member. The demonstration must identify the
engine-side `CrankOutcome` and the transcript/embargo/commit responsibilities as
the conflicting ownership evidence. Include a negative control showing that a
multi-component design with an explicit, coherent ownership map does not fail
merely for naming multiple layers.

Run the relevant garden tests, land the prevention and sensing changes on
`main2`, then close the cluster with:

```
scripts/jobs/review-miss-record.sh cluster-status architectural-boundary-ownership closed --improved-by "<commits/files changed>"
```

Report the exact re-litigation evidence and test commands. Do not alter the
historical miss record.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-16T22:52:22Z
