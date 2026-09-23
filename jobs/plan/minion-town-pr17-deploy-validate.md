---
gate: orchestrated
orchestrated_by: minion-town-pr17-conduct-deploy-validate
priority: normal
posted_by: producer
posted_at: 2026-09-02T22:22:42Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Repository: kriscendobot/minion.town. Second half of kriskowal's PR review directive: "Please conduct, deploy, and validate in production." — https://github.com/kriscendobot/minion.town/pull/17#pullrequestreview-5095277423

Precondition: child 1 of this orchestration merged PR #17 into live `main`. Confirm that first (`gh pr view 17 -R kriscendobot/minion.town --json state,mergeCommit`); if it is not MERGED, stop and report — do not proceed.

1. **Deploy.** `.github/workflows/deploy.yml` auto-triggers on push to `main` (continuous deployment to the AWS-hosted minion.town stack, `concurrency: minion-town-deploy`, one run at a time). Find the run triggered by PR #17's merge commit (`gh run list -R kriscendobot/minion.town --workflow=deploy.yml --json databaseId,headSha,status,conclusion,createdAt`) and watch it to a terminal conclusion. If it did not trigger (e.g. the merge commit message carried `[skip deploy]`) or it fails, do not treat this as done — trigger it manually via `workflow_dispatch` (`deploy_target: all`) or report the failure; do not silently skip deploy.

2. **Validate in production.** The PR strengthens Streamable HTTP session-identity pinning: a live session should accept a newly issued credential (fresh `jti`) for the same `iss`+`sub` it was initialized with, and continue to reject a different identity. Exercise the equivalent of the PR's test scenario against the live production endpoint — mint/refresh a credential for the same identity against a real pinned session and confirm the `200`/tool-list behavior the PR's test checks, then confirm a different identity is still rejected. Follow the precedent in `skills/minion-town-clip-publishing/SKILL.md` for how a prior job ran a real production repro and cleaned up after itself (e.g. `endojs/endo-but-for-bots` PR #71 / minion.town issue #74 verification) — leave production in the state you found it (no stray test sessions/credentials/published artifacts left behind).

Report the deploy run's outcome and the production validation result explicitly; this is the completion of kriskowal's review directive on PR #17.
