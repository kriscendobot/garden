---
role: shepherd
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-10-16T05:12:32Z cleared=none -->

---
role: shepherd
requires: host=endolin-garden-ece02cb4
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Drive endojs/endo-but-for-bots PR #1396 CI green

This is the second serial child of
`endojs-endo-but-for-bots-pr1396-parcel-restack-20261015-finish-endolin-split`.
It runs only after the base-move child completes.

Start by reading the current PR state from GitHub. The expected head branch is
`build/sturdyref-captp-construct`, initially at
`609821f7118d0633132a5df973ae1f789f696066`, and the expected base branch is
`build/sturdyref-captp-wire-6f3185b`. The source restack and local package checks
were already done: `packages/ocapn` `yarn test` passed and `yarn lint` had zero
errors. Do not repeat the restack.

Drive required GitHub Actions checks to a terminal green state. At 2026-10-15
18:50 UTC no Actions run had started for the force-push. If runs are still
missing, first use a close/reopen cycle to retrigger them; if necessary, use an
empty commit on the PR head and report the resulting head SHA. If source changes
are required to fix genuine failures, obtain this job's isolated project checkout
with:

`/home/kris/garden/scripts/jobs/ensure-project-worktree.sh endojs-endo-but-for-bots-pr1396-parcel-restack-20261016-ci-green endojs/endo-but-for-bots build/sturdyref-captp-construct`

Make the smallest correct fix, run relevant local checks, commit, and push with a
lease. Wait in the foreground for CI. Report every required check and its terminal
conclusion, the final head SHA, and any changes made.

If CI cannot be made green, finish with the orchestrated-failure signal. If every
fleet-available check is complete and the sole remaining barrier is interactive
maintainer login/MFA, use the orchestrated-auth-unavailable signal instead.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-16T05:21:04Z
