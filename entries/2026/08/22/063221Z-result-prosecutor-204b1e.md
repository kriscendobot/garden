---
kind: result
role: prosecutor
host: endolin-garden-ece02cb4
at: 2026-08-22T06:32:30Z
---
---
refs:
  - endojs/endo-but-for-bots#475:review:4976935353:retro
  - endojs-endo-but-for-bots-pr475-review-2c700561
---

# Review retrospective: stale identifier references on PR #475

Verdict: **review miss**, category `docs-drift`, severity `moderate`.

The maintainer's review requested a PR-head-wide sweep after an implementation
comment still named a replaced byte-comparison function. This was not new
direction. The PR's rename and deletion map was explicit in its diff, and the
archivist seat already requires comments and JSDoc to describe the code after a
change. The 2026-08-19 gauntlet also ran a types/style/docs lens over the
incremental diff and found three related stale prose defects, but declared no
fix loop and did not complete the sweep. The later fixer found the stale
implementation comment plus an added design and two changesets that still used
removed identifiers or deleted paths.

World check: I fetched formal review 4976935353 and its inline comment directly,
read the parent thread, read the gauntlet's durable job report and PR verdict
comment 5337548450, and inspected the current PR file patches. The primary did
not close as a no-op: commit `2419e759b` exists in the PR history, the corrected
prose is present in the current patches, and reply 3816960288 reports the sweep.
There is no false-peer discrepancy.

Recorded at
`review-misses/misses/endojs-endo-but-for-bots-pr475-review-2c700561.md` and
minted cluster `stale-identifier-reference-sweep` (count=1, PRs={475},
status=open, recurrence=0). The cluster covers broad renames or removals that
leave old names or paths in changed prose because review samples individual
defects instead of reconciling all prose against the rename/deletion map.

Threshold: held below dispatch. Count=1 on one PR is below the default floor of
three misses across two PRs. Moderate severity does not qualify for the
single-major standing-rule bypass, and no existing instruction explicitly
requires a complete map-based sweep. No improvement job was posted.

Follow-up: if this pattern recurs past the floor, the improvement should combine
producer-side rename/deletion reconciliation with an archivist review check or
mechanical changed-prose probe, then re-litigate every cluster member.

Self-improvement: nothing this time.
