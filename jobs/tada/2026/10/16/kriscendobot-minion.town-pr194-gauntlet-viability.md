**PR #194 viability: proceed.** kriscendobot/minion.town PR #194, "feat(gateway): let only the Minion Town shell frame a clip", is still open and hasn't been replaced by anything newer, and the reason for it still holds.

**Deciding question:** Is the current `main` still missing the clip-embedding header increment that design #189 approved, with no other PR or commit already delivering it?

**Evidence:**
- **PR state:** open, draft, not merged. It was opened 2026-10-16T17:43Z by the job `minion-town-ui-iframe-embed-headers-after-approval` and has no reviews or comments yet.
- **Design approval is current:** the maintainer's approval of design PR #189 was posted there by the liaison on 2026-10-16T17:18Z, about 25 minutes before #194 was opened. It covers the ocap.site shell-frame and same-clip-id revisions, and says implementation of the header increment follows. #189 itself is still open as the place where the maintainer answers.
- **The base is current:** the PR's base `main-30a4c62` is the current tip of `main` (the merge of #187 on 2026-10-15). Nothing newer has landed.
- **The motivating premise holds on `main`:**
  - `src/endo/gateway/isolation-headers.ts` still emits `frame-ancestors 'none'`.
  - `deploy/aws/caddy/conf.d/minion-town.caddy` still serves `minion.town, www.minion.town` from one shared site block. There is no site-wide floor that appends `frame-ancestors 'none'`, no shell `frame-src https://*.ocap.site`, and no `www` → apex 308.
- **No competing work:** a search of all PRs about framing turns up only #189 (the design), #194, and older merged shell PRs (#90, #143, #157, #159). None of those touches the clip frame-ancestor floor. The open shell PRs #188 and #190 deal with how the clip gutter refreshes and is ordered, not with framing headers.

I spent no clean, panel, fix, CI-wait or un-draft budget, and made no commits.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr194-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (156354 cached reads)
- Output: 1737 tokens
- Cost: $0.3933308
- Wall-clock: 44s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
