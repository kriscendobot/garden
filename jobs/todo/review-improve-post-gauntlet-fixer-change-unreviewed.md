---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Close review-miss cluster `post-gauntlet-fixer-change-unreviewed`

The cluster is at `review-misses/clusters/post-gauntlet-fixer-change-unreviewed.md`.
It now has three misses across three PRs and has crossed the default dispatch
floor. Read and re-litigate every member:

- `review-misses/misses/endojs-endo-but-for-bots-pr475-review-e560d700.md`
- `review-misses/misses/endojs-endo-but-for-bots-pr858-review-8add9193.md`
- `review-misses/misses/endojs-endo-but-for-bots-pr1226-review-adf95686.md`

The cluster name predates the shepherd and designer members. Generalize the
remedy to substantive changes made after the latest completed panel, regardless
of whether the producing role is fixer, shepherd, designer, or another PR-
touching role.

Deliver both halves in one improvement round:

1. **Prevention:** change the narrowest producing workflow so a substantive
   post-panel delta cannot be presented for maintainer review as though the old
   panel still covered the current head. Define a checkable freshness contract
   between the reviewed head and the presented head. Preserve the standing
   manual-gauntlet-trigger policy: do not silently start an entire gauntlet when
   the maintainer has not requested one. Prefer a deterministic hold, explicit
   stale-review disposition, or narrowly scoped fresh review over a prose-only
   reminder.
2. **Durable sensing:** add a deterministic review-cycle check that compares the
   last panel-reviewed commit with the current/presented head and detects a
   substantive intervening delta. Wire it into the handoff or completion path so
   the condition cannot be forgotten. If full mechanization cannot distinguish
   substantive from non-substantive changes, make the deterministic sensor err
   toward review and route the judgment to an existing seat/stage.

Do not close the cluster after delivering only prevention or only sensing.

## Re-litigation test

For each member, name the exact new check and demonstrate it on the historical
sequence:

- PR #475: panel head `b28bb1fc3`, followed by fixer commit `a4767d542b` that
  introduced the asymmetric inverse-map lifecycle.
- PR #858: panel head `7d23bf082`, followed by shepherd commit `1ec375e2` that
  added the unnecessary CI conditional.
- PR #1226: final design-panel head `4e1696a4`, followed by the 2026-09-17
  designer rewrite that replaced the broker/socket architecture with a
  Claude-spawned ordinary daemon client and changed the config carrier.

Show the sensor flags every historical post-panel delta before maintainer
review. Include a negative control for a head with no post-panel delta and a
documented disposition for a non-substantive metadata-only delta. Verify that
the remedy does not violate the manual-gauntlet-trigger regime.

After both halves land on `main2`, close the cluster with:

```
scripts/jobs/review-miss-record.sh cluster-status post-gauntlet-fixer-change-unreviewed closed \
  --improved-by "<commits/files changed>"
```
