I ran round 4 of the panel on PR #1360. The verdict is **must-fix**, but I could not post it as a review, so I'm reporting this round as `panel-error`.

- **Checkout:** I made an isolated copy of the PR branch `design/capability-url-locators` at `/Users/dom/garden/scratch/project-wt-endojs--111b6b3cec97-81e2e8a8`. Its head is `f9e08e423`, which matches the PR's current head.
- **Panel:** `GARDEN_PANEL_SINGLE_ROUND=1 panel.sh <wt> 1360 origin/llm-47f6965` exited 0 with disposition `must-fix`. It reused the saved record `74e459c2fd65`, which an earlier claimant had already run for this same head, so the seats were not run again. That claimant ran the reviewers but never posted the result.
- **Verdict:** the aggregate lists 20 must-fix items. The main ones:
  - The metadata table, the README row and its placement don't match each other or the convention.
  - The rule that a recognized `v` is sufficient conflicts with the closed key set and the "unknown key is an error" rule.
  - The `v=1` registry depends on an unchecked assumption about minion.town's grammar.
  - The fragment's confidentiality claim fails because of the `Referer` header.
  - `isCapabilityUrl` merges "is this ours?" with "is this valid?".
  - The Stage 1 test catalog has gaps.

  The full text is in `/Users/dom/garden/scratch/panel-run-pr1360-r4/review.md`.
- **Posting failed:** `gh pr review --request-changes` and the `--comment` fallback both returned `Resource not accessible by personal access token (addPullRequestReview)`. The bot token on this host (`oros-studio-garden-ce242c49`) cannot write PR reviews on endojs, so no round-4 review is on the PR.
- **Why `panel-error`:** reporting `must-fix` would claim a review exists that doesn't. With `panel-error`, the driver posts this round again, and a host that can write to endojs (like `endolin-garden-ece02cb4`) can pick it up. It should reuse the saved record for head `f9e08e42` and only need to post the review, without running the seats again.
- **Follow-up:** the lasting fix is to give the kriscendobot token "Pull requests: write" on the endojs org, which may need org approval.

<!-- gauntlet-stage-result: panel=panel-error -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1360-gauntlet-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 80 tokens (1912931 cached reads)
- Output: 11479 tokens
- Cost: $1.7274381999999997
- Wall-clock: 2314s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
