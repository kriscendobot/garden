---
slug: incomplete-rename-old-name-sweep
category: naming
status: open
count: 2
members:
  - endojs-endo-but-for-bots-pr475-review-c85b88c9
  - kriscendobot-minion.town-pr62-review-353e723b
prs: [475, 62]
---



A rename lands the new identifiers but review does not sweep the whole PR for the old names, so stale references to the pre-rename byte API survive in code.

**Threshold rationale:** Held below dispatch (retro for kriscendobot-minion.town-pr62-review-353e723b, 2026-09-27). The cluster now has count=2 across prs={475,62}, which meets the two-PR requirement but not the K>=3 floor. Severity is moderate, and no pre-existing rule required a producer-side or cross-repo old-name sweep, so the single-major bypass does not apply. When a third member arrives, dispatch one improvement covering this cluster and its docs twin stale-identifier-reference-sweep: a whole-PR old-name grep over the PR's rename map, extended to the site that produces the renamed name, including a dependency seam. The #62 member also shows a gauntlet bypass (the PR was opened ready-for-review with no panel). builder-pr-gauntlet-bypass already tracks that.
