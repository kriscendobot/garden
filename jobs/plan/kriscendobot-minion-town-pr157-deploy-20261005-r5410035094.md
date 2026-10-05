---
gate: orchestrated
orchestrated_by: kriscendobot-minion-town-pr157-conduct-deploy-r5410035094
priority: urgent
posted_by: gardener
posted_at: 2026-10-05T04:59:22Z
---

---
handler-budget-role: review
tier: mentor
fallback-tier: minion
dispatch: automatic
---

# Deploy kriscendobot/minion.town PR #157 after merge

Repository: `kriscendobot/minion.town`
Pull request: https://github.com/kriscendobot/minion.town/pull/157
Authorizing review: https://github.com/kriscendobot/minion.town/pull/157#pullrequestreview-5410035094
Directive identity: `kriscendobot/minion.town#157:review:5410035094`

Trusted maintainer kriskowal directed: “Please conduct and deploy.” This serial child owns the deploy portion after the conductor child succeeds.

First verify the PR is MERGED and record its merge commit. The repository's `.github/workflows/deploy.yml` normally deploys on a push to live `main`. Find the deploy workflow run bound to the merge commit and wait in the foreground for a terminal conclusion. If no exact-head automatic run was triggered, inspect the workflow's supported dispatch inputs and use its authorized manual dispatch path to deploy the merged live `main`; do not guess an input or deploy an unrelated commit. Confirm the exact deployed revision from the run evidence. Report the run URL, head SHA, and terminal conclusion.

If the deploy fails or the exact merged revision cannot be shown deployed, do not claim success: report the precise blocker and emit the orchestration-failure signal. Do not leave a background watcher behind.
