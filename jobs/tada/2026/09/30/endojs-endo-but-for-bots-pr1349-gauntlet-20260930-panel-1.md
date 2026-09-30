**PANEL round 1 for endojs/endo-but-for-bots PR #1349: must-fix**

- **Checkout:** The PR head is `endojs/endo-but-for-bots:build/hardened-text-codecs-shim` at `d98467c6b5`. I checked it out in its own worktree at `scratch/project-wt-endojs--fa0f495fea4d-3ef03ade`.
- **Panel run:** I ran `panel.sh` in single-round mode against the PR's base commit `6ee3fda77b` (`master-6ee3fda`), not the possibly stale `origin/<baseRef>`. The diff is small: 2 files, +26/−2, in `.github/workflows/ci.yml` and `packages/ses/test/_xs.js`. All 33 seats returned `ok`. `panel.sh` exited 0 with disposition **must-fix**.
- **Why must-fix:** The PR body doesn't follow `.github/PULL_REQUEST_TEMPLATE.md`, and that check forces must-fix on its own. All seven template headings are missing (Description plus the six "considerations" sections). The body instead uses three headings the template doesn't have: "where the design stands", "this change" and "verification".
- **Other findings (none blocking):**
  - The concision check fired on the PR description, so the panel also ran the pruner seat over it.
  - The packager seat notes that the ci.yml pin-comment commit is unrelated to the test change.
  - The saboteur seat raised one should-fix item.
  - The seats I read (assessor, typist, stylist, archivist) approved the code itself.
- **Review posted:** I posted the full aggregate as a `gh pr review` at 2026-09-30T02:14:51Z. Its heading states the must-fix verdict, and it includes the template findings. The review shows as COMMENTED, not REQUEST_CHANGES, because GitHub refuses a request-changes review on the bot's own PR.
- **Edit before posting:** The `gh` wrapper first refused the post over bare `#1`–`#6`. Those were numbered items in the saboteur seat's list, not issue references, so I put them in backticks.

The run directory is `scratch/panel-run-pr1349-g20260930-r1`, with the aggregate in `round-1.md` and the posted text in `review-body.md`. As a single-round stage, it made no fixes and didn't un-draft the PR. The next step is the fix stage: rewrite the PR body to the template, and possibly move the CI comment commit into its own PR.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1349-gauntlet-20260930-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (791358 cached reads)
- Output: 3836 tokens
- Cost: $0.6329196
- Wall-clock: 252s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
