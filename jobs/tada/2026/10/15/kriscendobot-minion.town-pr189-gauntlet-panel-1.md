I ran one panel round on PR #189 and it came back **must-fix**. The verdict is posted to the PR, but as a comment review: GitHub would not let the bot request changes on its own PR.

- **Checkout:** I made an isolated checkout of `kriscendobot/minion.town` `design/clip-iframe-embedding` at head `0e8fb71`, compared against base `origin/main-ad0257e` (`ad0257e`).
- **Panel run:** `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh … 189 origin/main-ad0257e` exited 0 with "design-panel single-round — must-fix". Its ownership-map pre-pass flagged cross-boundary concerns, so the decomplector seat was added. The seats were critic, skeptic, decomplector, ergonomist, novice, copyeditor, pedant, orthographer and thesaurus.
- **Must-fix items:** both come from the skeptic seat.
  - Section 3.1 assumes that a `frame-ancestors` policy overrides `X-Frame-Options: DENY`. Nobody has checked this in Chrome, Firefox or Safari.
  - Section 3.2 says the clip's `same-origin` CORP header won't block the frame, which depends on the shell staying at COEP `unsafe-none`. Nothing tests or enforces that.
- **Should-fix items:**
  - The allowed parent `https://minion.town` is hard-coded into the gateway's generic header set; it should come from configuration.
  - The design gives control of the frame's navigation to both the shell and the clip, and doesn't say which "selected clip" the shell shows.
  - Any page on the `minion.town` origin can frame a clip, and the design doesn't audit what else is served there.
  - The `allow-scripts allow-same-origin` sandbox needs a hard check that rejects any clip `src` outside `*.ocap.site`.
  - The tests in section 3.7 have gaps, and the editorial seats asked for prose and structure changes.
- **Posting:** `gh pr review --request-changes` failed with "Can not request changes on your own pull request". I posted the same body with `--comment` at 2026-10-15T07:39:59Z (state COMMENTED). It opens with a "must-fix" header and has the full set of seat verdicts below it.

**Follow-up:** the bot authors these PRs, so its must-fix panel verdicts can only land as COMMENTED reviews. If the next-stage heuristic needs a CHANGES_REQUESTED review to see must-fix, it could miss this one, so it should be checked.

I made no garden-repo changes and pushed nothing.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr189-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (628547 cached reads)
- Output: 3377 tokens
- Cost: $0.5720014
- Wall-clock: 281s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
