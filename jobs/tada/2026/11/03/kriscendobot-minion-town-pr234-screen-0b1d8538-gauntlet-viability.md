**Viability report: kriscendobot/minion.town PR #234**

PR #234 is open and not a draft. Its base is the frozen `main-3f6c2b2`, which is the current tip of `main`. The head is `0b1d8538`: 15 commits ahead of `main`, 0 behind, and GitHub reports it MERGEABLE. The PR was opened today, and the last fix round, at 18:59Z today, answered review 5757823555.

Deciding question: Does current `main` already have the contact-forget and mail-dismiss guest routes or a local invitation round-trip check in the prod probe, or has the need for a standing-guest probe of invitation onboarding gone away?

Evidence:
- **Not on `main`.** `main`'s `deploy/probe/prod-objectives.mjs` has only the `prod-probe-roundtrip` check (writeText, then a new session, then readText). It has no invitation check. A code search for `local-invitation-roundtrip`, `dismiss-all` and `contacts/:petName` found nothing on `main`.
- **#233 does not overlap.** It is the only newer merge into `main` (MCP `invite`/`cancelInvite`, 15:32Z). It covers the MCP guest tools, not these web guest routes or the probe.
- **The motivation still holds.** Issue #81 (web invite and accept workflow) is merged, so there is shipped behavior to probe. Coupon admission (#199) is still open, so closing `POST /api/guest` to anonymous callers is still pending. That pending change is why the PR uses standing guests, not per-run guests.
- **Nothing replaces it.** No other open or merged PR adds this probe or these routes. #199, #202 and #210 cover other things.
- **What's open is review work.** The previous gauntlet stopped at review-budget-reached with CI green. After that, a fix round answered the decomplector and pruner findings. The remaining items are review findings, not reasons the PR is obsolete.

Verdict: proceed. The gauntlet may begin. I did not spend any clean, panel, fix or CI budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr234-screen-0b1d8538-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (246652 cached reads)
- Output: 1752 tokens
- Cost: $0.47376240000000003
- Wall-clock: 33s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
