---
slug: stale-identifier-reference-sweep
category: docs-drift
status: open
count: 1
members:
  - endojs-endo-but-for-bots-pr475-review-2c700561
prs: [475]
---


A broad identifier or file removal leaves old names and paths in comments, designs, or changesets because review samples individual prose defects but does not sweep all changed prose against the PR's rename and deletion map.

**Threshold rationale:** Held below dispatch. The touched cluster has count=1 and prs={475}, so it is
below the default floor of at least three misses across at least two distinct
PRs. Severity is moderate, not major, and the grounds identify no pre-existing
rule that explicitly required a complete old-name and deleted-path sweep. The
single-major standing-rule bypass therefore does not apply. No improvement job
is dispatched until this pattern recurs past the floor.
