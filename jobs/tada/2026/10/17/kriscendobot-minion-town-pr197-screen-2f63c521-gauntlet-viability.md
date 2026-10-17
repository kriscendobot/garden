**Gauntlet viability: kriscendobot/minion.town PR #197** (`feat(shell): frame a served clip live from its own ocap.site origin`)

**Result: proceed.** The PR is open, unmerged and not a draft. It was opened 2026-10-17. Its head is on `feat/clip-live-frame` and its base is `main` (@`3a2c1200`). It is still needed and nothing has replaced it.

Deciding question: Does current `main` still frame clips only as an inert `srcdoc` card, with no other merged or open PR shipping the live ocap.site frame, while the contract approved on #189 and the header increment it builds on (#194) are both still in place?

Evidence:
- **Base code still inert.** In current `main`, `deploy/aws/www/shell.js:126` reads `export const frameConfiguration = clip => ({ sandbox: '', srcdoc: clipDocument(clip) })`, and the comment at line 103 says "the shell never FRAMES this origin". The live frame does not exist on base yet.
- **No newer commits on `main` touch this.** Since the PR opened, `main` got #190 (persisting the gutter order), #195 and #196 (the bearer-echo fix and its probe). None of them changes how clips are framed.
- **No competing PR.** The newer open PRs, #198 through #202, cover the landing page, guest coupons, settings, New Clip and Chat. None of them is a live-frame implementation.
- **The premise still holds.**
  - #194, the header increment that lets only the shell frame a clip, is merged.
  - #189, the design PR, is still open. The liaison relayed kriskowal's approval of its clip-embedding contract on 2026-10-16, and no later comment there takes it back.
- **PR state is healthy.** The PR's own panel already passed round 1 at head `f55f6a21`, with 34 seats and no blockers. The PR body reports 29/29 browser-gate checks passing on Chromium, Firefox and WebKit.

No follow-ups.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr197-screen-2f63c521-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (203455 cached reads)
- Output: 1797 tokens
- Cost: $0.396127
- Wall-clock: 37s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
