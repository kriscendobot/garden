---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Prevent phase slices from substituting for production evidence

Improve review cluster `phase-slice-substitutes-for-production-evidence` from
`review-misses/clusters/phase-slice-substitutes-for-production-evidence.md`.
Read every member record before editing. Current member:

- `review-misses/misses/kriscendobot-minion.town-pr87-review-1456cb95.md`

The historical case is kriscendobot/minion.town PR 87 at reviewed head
`b6280ed36dbb8eca297d13593c047e4c3fad02e6`. Its governing design required an
ordered production sequence, placed a real substrate and entitlement stop gate
before Minion wiring, required canary observations after wiring, and explicitly
said unit tests were not production evidence. The PR narrowed delivery to the
later wiring phase, left production seams unavailable or fail-closed, and used
unit-test success as the reviewable result. Three panel rounds did not restore the
design-level acceptance bar.

Deliver both halves in one improvement:

1. **Prevention.** Amend the narrowest producer artifact so an implementation
   derived from a design with ordered prerequisites, stop gates, or explicit
   acceptance evidence cannot present a later phase as the feature deliverable
   while a prerequisite is open. Require the producer to carry a phase/evidence
   ledger into the PR body and either satisfy the governing acceptance evidence
   or label the artifact as a deliberately non-deliverable probe that remains
   draft. Prefer a deterministic authoring-time check wherever the signal can be
   extracted.
2. **Review-cycle sensing.** Add a durable panel-stage check. Prefer a
   deterministic gate or panel-hints probe that detects feature PR bodies/diffs
   declaring unlanded prerequisites, unavailable or fail-closed production seams,
   deferred numbered phases, or acceptance evidence that is still absent. Route
   it to the existing panel seat whose brief you amend with an explicit check, or
   add a narrowly scoped seat only if no existing lens can own it. The check must
   compare against the governing design's sequence and acceptance section, not
   merely count tests.

Close with the re-litigation test required by the review-retrospective skill:
name the exact prevention and sensing checks that would catch the member, run the
probe or gate against PR 87's historical diff/body at `b6280ed36d`, show that it
fires and would prevent review-ready disposition while the production gate is
open, then close the cluster with:

```
scripts/jobs/review-miss-record.sh cluster-status \
  phase-slice-substitutes-for-production-evidence closed \
  --improved-by "<commits/files changed>"
```

Both prevention and sensing are required. A prose reminder without a durable
review check, or a detector without producer guidance, is incomplete.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-27T17:50:45Z
