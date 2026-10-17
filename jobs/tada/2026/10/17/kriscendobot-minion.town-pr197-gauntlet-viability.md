**Viability verdict for kriscendobot/minion.town PR #197: proceed.** The PR is open, unmerged and still a draft. It was opened today (2026-10-17T05:35Z) against the frozen base `main-bda7739`, and that base is the current tip of `main`.

**Deciding question:** Does current `main` still render every clip only as the inert sandboxed card, with no newer change framing a served clip live from its `ocap.site` origin, and is the prerequisite framing-header increment (#194) merged?

**Answer:** Yes on both counts.

**Evidence:**
- **#194 is merged.** "feat(gateway): let only the Minion Town shell frame a clip" merged as `bda7739` at 2026-10-17T04:54Z. That is the newest commit on `main`, so the PR's base is current and nothing has landed since.
- **`main` has no live frame yet.** In `deploy/aws/www/shell.js` on `main`, `frameConfiguration` is still `clip => ({ sandbox: '', srcdoc: clipDocument(clip) })`. A code comment there says "the shell never FRAMES this origin". The `isCanonicalClipId` validator and `allow-scripts` live branch exist only in #197.
- **Nothing displaces it.** A search of all minion.town PRs finds no other live-frame implementation. The related PRs are #189 (the design this implements, still open), #88 (open; the PR says it is deliberately not relied on) and #190 (gutter order, unrelated).
- **The premise still holds.** The PR implements the next increment of `designs/clip-shell-framework.md` after #194. Its body cites maintainer approval of the #189 contract on 2026-10-16. I couldn't confirm that approval on GitHub: #189's six reviews are all bot comments from 2026-10-15, so it may have come through another channel.
- **State at the head commit.** Head is `f55f6a2`, with no reviews or comments yet. The PR body reports the three-engine browser gate passing 29/29; I didn't verify that, since this stage spends no CI-wait budget.

I didn't change any code, commit anything or post any jobs; the gauntlet may now begin.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr197-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (183759 cached reads)
- Output: 1418 tokens
- Cost: $0.45800779999999996
- Wall-clock: 23s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
