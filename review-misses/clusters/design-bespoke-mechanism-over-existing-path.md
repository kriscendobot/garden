---
slug: design-bespoke-mechanism-over-existing-path
category: process
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr1226-review-2fc247cc
prs: [1226]
---


A design invents a bespoke per-entity channel or mechanism where the repository's existing client/connection path already provides the access, and successive design-panel rounds patch that mechanism's recurring must-fix findings instead of asking whether it is needed at all.

**Threshold rationale:** Held below the dispatch floor. The newly minted
`design-bespoke-mechanism-over-existing-path` cluster has one moderate miss
from one PR (`count=1`, `prs=[1226]`), below the default threshold of at least
three misses across at least two distinct PRs. The severity bypass does not
apply. The decomplector's existing "minimum viable abstraction" category did not
bind, but the miss was confined to a design, caught before the builder step, and
already fixed on llm. Candidate sensing for a future improvement: when a design
panel re-raises must-fix findings on the same mechanism across two or more
rounds, the decomplector or critic asks whether an existing repository path
would make that mechanism unnecessary.
