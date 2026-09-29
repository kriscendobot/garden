---
slug: related-design-contract-cross-check
category: spec-violation
status: open
count: 2
members:
  - endojs-endo-but-for-bots-pr1072-review-c8a0f42b
  - endojs-endo-but-for-bots-pr1357-review-b33b9342
prs: [1072, 1357]
---




A design or review-feedback edit states a protocol or wire-format rule that contradicts an already-landed authoritative design in the same repository, because the producing and review paths do not cross-check related design contracts before presenting the change to the maintainer.

**Threshold rationale:** Held below the dispatch floor. The newly minted
`related-design-contract-cross-check` cluster contains one moderate miss from
one PR (`count=1`, `prs=[1072]`), below the default threshold of at least three
misses across at least two distinct PRs. The severity bypass does not apply:
although an existing authoritative design contract failed to bind, the
contradiction was confined to a draft design and was caught before gauntlet,
undrafting, or merge. No improvement job is dispatched unless this pattern
recurs past the floor.

**Threshold rationale:** **Threshold rationale (2026-09-29, pr1357 retro):** Held below the dispatch
floor. The cluster now has two minor-to-moderate misses from two distinct PRs
(`count=2`, `prs=[1072,1357]`), short of K >= 3. The severity bypass does not
apply: the pr1357 member is minor, confined to a draft design, and already
resolved in revision 7a6d4259c. Both members share one cause: a draft design
reaches the maintainer without a cross-check against landed related designs,
because no panel runs on drafts under the manual-gauntlet regime. A third
member should dispatch an improvement: prevention in the designer's
library-lookup step (list the designs/ files that share the new design's
domain terms and cite or reconcile each), plus a deterministic sensor that
flags related designs a new design never links.
