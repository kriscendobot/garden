Viability gate result for kriscendobot/minion.town PR #234: **proceed**. The PR is open, nothing newer has replaced it, and the reason it was opened still applies.

Deciding question: Is PR #234 still the only change that adds the contact-forget and mail-dismiss guest routes and the local invitation round-trip check to the prod probe, with `main` still lacking that check?

Evidence:
- **PR state:** open, not draft, not merged. Base is the frozen `main-3f6c2b2` (`3f6c2b24a9`) and head is `42712293`. CI is green after fix round 1. The previous gauntlet stopped at `review-budget-reached`, waiting for a maintainer decision.
- **No newer `main` history:** comparing `3f6c2b2...main` shows `main` 0 commits ahead of the base. Nothing has landed since the PR was cut.
- **The check is still missing on `main`:** `deploy/probe/prod-objectives.mjs` there contains no invitation, `dismiss-all` or `api/guest/contacts` code. The motivating need still holds: the scheduled probe should cover local invitation onboarding (#81, merged 2026-09-02; tracker kriscendobot/garden#58).
- **No competing PR:**
  - #233 (MCP `invite`/`cancelInvite` tools, merged today) works on the MCP guest surface. It neither adds the probe check nor the forget/dismiss web routes.
  - #199 (coupon admission) is still open. #234 already plans for it by minting with `attachCoupon: false`.
  - No other open or merged PR covers this work.
- **Open review items:** decomplector suggested dropping the two routes or switching to disposable guests. Those are scope suggestions for the PR's owner, not evidence that the PR was replaced. The other leftover corner cases are should-fix items.

I made no changes and spent nothing on clean, panel, fix or CI-wait stages.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr234-screen-42712293-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 6 tokens (125647 cached reads)
- Output: 1318 tokens
- Cost: $0.4325694
- Wall-clock: 23s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
