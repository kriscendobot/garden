**PR #229 gauntlet, panel round 1 (kriscendobot/minion.town): verdict is must-fix**

- **Pinned pair:** base `443519ebee45143cccfe3a36c10635ce24d74ae0`, head `7700cd9dc4d54f2cf620ba7f426e7f3cf62db071` on `kriscendobot/feat/claude-api-provider-ui`. I made an isolated checkout at `/home/kris/garden/scratch/project-wt-kriscen-ae97330000bd-abe863a2`, set it to the head object detached, and confirmed `git rev-parse HEAD` matched.
- **Style pre-pass:** `pre-push-gates.sh --no-auto-fix --probes-only` exited 0. It gave one non-blocking warning: a 5-line prose comment at `src/endo/inference-provider-service.ts:136` may only narrate the code next to it.
- **Panel:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh` exited 0. The new-mechanism probe fired, so the decomplector seat was added to the code panel. The disposition is **must-fix**. The PR is self-authored, so the review was posted as a COMMENTED review at 2026-11-03T19:10:57Z, under the "Must-fix before merge" heading. The findings visible in the first part of the review, both from the assessor seat:
  1. **Daemon failure in `admit` is never caught.** In `src/auth/inference-provider-endpoint.ts`, `admit` returns the `guestFormulaIdentifierFor(...)` promise inside a `try` without `await`. A daemon connection error therefore escapes the `catch`, and the request hangs with an unhandled rejection instead of returning 503. The fix is `return await` plus a test for the rejecting case.
  2. **Missing `limits` silently resets to defaults.** On the `owner-limits` and `:id/limits` routes, a body with no `limits` (for example `{}`) resets the limits to `{2, 20, 5}`. The fix is to require `limits` on those two routes.

  The full aggregate is in the review on the PR.

I did not fix anything or un-draft the PR; the fix stage is next.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr229-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (296498 cached reads)
- Output: 2088 tokens
- Cost: $0.4735556000000001
- Wall-clock: 171s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
