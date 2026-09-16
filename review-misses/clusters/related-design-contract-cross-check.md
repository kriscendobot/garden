---
slug: related-design-contract-cross-check
category: spec-violation
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr1072-review-c8a0f42b
prs: [1072]
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
