---
kind: result
role: prosecutor
host: endolin-garden-ece02cb4
at: 2026-08-22T06:37:10Z
---
---
kind: result
role: prosecutor
project: endo-but-for-bots
refs:
  - endojs/endo-but-for-bots#475:review:4976976834:retro
  - endojs-endo-but-for-bots-pr475-review-5aae699b
---

# Retro on endojs/endo-but-for-bots #475 review 4976976834: MISS recorded, holding

The review asked whether repairing the emulated TypedArray toStringTag behavior
would change or break the hardener's getter-based TypedArray brand check.

Verdict: miss (`test-gap`). An earlier maintainer review on this PR had already
directed replacement of the TypedArray toStringTag getter. The later
`design-endo475-istypedarray-isview` increment retained that getter as the
hardener's brand check and tested DataView, but did not exercise the planned
receiver-aware getter replacement against emulated wrappers or the two
shim/hardener initialization orders. The five-lens gauntlet predated that
increment, and no panel reviewed it before the maintainer raised the interaction.
The corner-prober's standing boundary-enumeration rule and the critic's adjacent-
module composition check should have caught it.

World evidence also exposes a discrepancy in the primary's claimed resolution.
The primary reply exists, but it incorrectly assumed a fidelity repair meant a
toStringTag data property and said the getter-based classification could not
change. Subsequent thread replies corrected that analysis. Commit `fc2238dcb`
then installed the receiver-aware getter and demonstrated that classification
does change when the shim installs before hardener capture, while hardening stays
successful in both orders. The omitted interaction was therefore real but benign,
so severity is minor rather than a correctness bug.

Recorded as
`review-misses/misses/endojs-endo-but-for-bots-pr475-review-5aae699b.md` and joined
cluster `type-representation-matrix-coverage`. Writer result: count=2,
prs=[475], status=open, recurrence=0. Threshold decision: HOLD. Both members are
on one PR, so the cluster fails the K >= 3 across at least 2 distinct PRs floor;
minor severity does not qualify for the major standing-rule bypass. No
`review-improve-*` job was dispatched.

Self-improvement: nothing this time.
