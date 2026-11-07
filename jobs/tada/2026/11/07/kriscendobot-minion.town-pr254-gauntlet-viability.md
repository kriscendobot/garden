**Gauntlet viability: kriscendobot/minion.town PR #254** ("fix(web): explain failed guest recovery")

The gauntlet may begin. The PR is open, unmerged and still a draft, and it has no reviews or comments yet. It was opened on 2026-11-07 from `fix/recovery-outcome-screen` (head `d90975d2e`), against the frozen base `main-7a0bcc9`.

Deciding question: Since this PR was opened, has anything landed on `main` (or in another PR) that already gives a failed signed-in guest recovery an accessible outcome card, which would make this PR redundant or its reproduced bug moot?

Answer: no.

Evidence:
- **Base is current.** `compare 7a0bcc9...main` shows `ahead_by: 0`. The frozen base is the tip of `main`, and nothing has landed since the 2026-11-05 maintainer directive that motivated the PR. The bug it reproduced (error written into a hidden wait-list card, no focus move, message lost on reload) is therefore still present on the base.
- **No PR displaces it.** Searching "recovery outcome" turned up no other PR doing this work. The closest one, #253 (wait-list sign-up goes to a thank-you page at `/soon`, opened the same day), handles the success path of a wait-list sign-up. #254 handles failed guest recovery, so #253 is a sibling, not a replacement.
- **Overlap with #253.** Both PRs change `deploy/aws/www/home.js`, `index.html`, `minion-town.caddy` and `test/home-page.test.ts`. Whichever lands second will probably need conflict resolution, but that does not make this one obsolete.
- **The work is unfinished.** The PR's ledger lists Phase 4 (merge, deployment and production acceptance) as open, owned by its successor `verify-minion-town-recovery-outcome-production-20261107b`.

Follow-up: watch the ordering of #253 and #254 so the second one is rebased (woven) onto whichever merges first.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr254-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (190309 cached reads)
- Output: 1367 tokens
- Cost: $0.45944179999999996
- Wall-clock: 36s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
