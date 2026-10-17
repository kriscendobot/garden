**Viability report: kriscendobot/minion.town PR #201** ("feat(shell): New Clip, a blank clip that becomes a pet-name inventory")

The gauntlet can proceed: the PR is open, nothing newer replaces it, and the beta work that motivated it is still live.

**Deciding question:** Has `main` gained, since the PR's frozen base `main-bda7739`, a New Clip mint route or inventory clip that replaces this one, or has the closed-beta "+ makes a New Clip" need been dropped? **Answer: no.**

**Evidence:**
- **PR state:** open, draft, not merged. It was opened today (2026-10-17T08:37Z) by the `mt-beta-new-clip-inventory` job as part of the maintainer's closed-beta product pass, also dated 2026-10-17. It has no reviews or comments yet.
- **Newer base history:** `main` is 21 commits ahead of `bda7739`. All 21 belong to the merged #190, which saves the clip gutter order. None of them touch minting a New Clip, the inventory, or the `+` creators.
- **Code on `main`:** none of the PR's main files exist there (`designs/new-clip.md`, `src/endo/gateway/new-clip.ts`, `clips/new-clip/model.js`). There is also no `clips/new` route in `src/auth/guest-self-endpoint.ts`.
- **Related open PRs:** a search finds #197 (live clip framing), #189 (iframe design), #88 (session locator) and #85 (in-place upgrade), all still open. #201 lists them as dependencies or follow-ons; none of them replaces it.
- **What #201 assumes still holds:** prod runs `CLIP_SITES_LIVE=1` with the powers plane armed, and an in-place `upgrade` on the live `@sites` path is still unavailable, since #85 is open. The PR works around that limit on purpose by keeping the same clip id across the change of form.

**Follow-up:** #190's gutter-order changes to the shell may conflict with this PR's edits to `deploy/aws/www/shell.js`. The fix step will find out if they do; viability doesn't depend on it.

I spent no clean, panel, fix or CI-wait budget, and committed nothing.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr201-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (179108 cached reads)
- Output: 1514 tokens
- Cost: $0.43249360000000003
- Wall-clock: 26s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
