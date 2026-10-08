---
kind: result
role: weaver
host: endolin-garden2-5bcdff64
at: 2026-10-08T09:12:44Z
job: endojs-endo-but-for-bots-pr586-weave-20261008
claim: 37087e449463b7f0
---
Wove endojs/endo-but-for-bots#586 onto frozen base `master-6ee3fda` (`6ee3fda77bf28a4fe4a81c6269fe33655f162b9e`), which contains the #468 freezable-TypedArray implementation. The four test commits rebased without conflicts and were force-pushed with a lease; the PR base now names the frozen snapshot. Final head is `0b9ddf59047e519e07ee9fb29e5dd2dbc63be998` and GitHub reports the PR CLEAN.

The first exact-head workflow-security run exposed a stale action-version annotation already present on the new base. Added follow-up `0b9ddf5904` changing only the `dorny/paths-filter` comment from `v3` to its pinned SHA's exact `v3.0.3`; the action SHA is unchanged.

Verification: `yarn --cwd packages/immutable-arraybuffer test` passed all 324 tests, including all 96 constructor-boundary cases. `yarn node scripts/update-action-pins.mjs --check-pins` passed. Exact-head CI, dependency-version validation, and workflow-security runs all completed successfully (37752855622, 37752855665, 37752855722); `gh pr view` reported no non-green checks. Posted the completion summary at https://github.com/endojs/endo-but-for-bots/pull/586#issuecomment-6056611834.

Follow-up: the rebased head is ready for fresh review/panel coverage.

Self-improvement: reported the post-base-move CI-trigger sequencing gotcha to `role/liaison` as message `20261008T091218Z-f901e7`; no garden files changed.
