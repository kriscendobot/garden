**Viability verdict for kriscendobot/minion.town PR #170: the gauntlet can begin (`viability=proceed`).**

I re-checked just now and nothing has changed. The PR is still open, unmerged and a draft, with head `c0746f82` and base `76bb2762`. `main` is still at `76bb2762`. The previous run did not register as complete because it put the completion signal on the second-to-last line. This report puts it last.

Deciding question: Does current `main` still keep locator and guest fragments readable after landing (cleared only by a same-document `replaceState`, and the guest id stored in plaintext `localStorage`), with no newer PR or commit replacing that handling?

Evidence:
- **Base is current.** Comparing base `76bb2762` with `main` shows 0 commits ahead. The tip of `main` is still `76bb2762` (2026-10-08 04:05Z), so nothing on `main` has replaced this change since it was built.
- **The problem it fixes is still on `main`.** `deploy/aws/www/guest.js` reads `location.hash` and clears it with `history.replaceState` in the same document (lines 43, 88 and 119). It stores the guest id in plaintext with `localStorage` (lines 12 and 15). This is the exposure the PR fixes: the original URL can still be recovered through Navigation Timing, and the guest id sits unencrypted in browser storage.
- **No competing PR replaces it.** I searched minion.town PRs in every state for "fragment" and "locator". The open ones nearby work on other things:
  - #131 and #129 cover copying and recovering guest-shell URLs.
  - #132 covers the federation `--locator` docs.
  - #88 is a clip design.

  None of them implements the bootstrap scrub or encrypted storage. The two merged matches, #117 and #81, are the work this PR builds on.
- **The PR has no feedback yet.** It was opened 2026-10-08 04:59Z by today's `minion-town-locator-fragment-scrub` job and has no comments or reviews.

I made no repository changes and spent no clean, panel, fix, CI-wait or un-draft budget.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr170-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (332223 cached reads)
- Output: 2709 tokens
- Cost: $0.9085714
- Wall-clock: 35s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
