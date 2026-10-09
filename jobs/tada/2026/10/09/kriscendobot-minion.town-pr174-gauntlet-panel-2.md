The round 2 panel on PR #174 returned **must-fix**. I posted the verdict on the PR as a review, and this stage is done.

- **Checkout:** I used an isolated worktree of the PR head, `build/credit-metering-no-ertp` at `4c257ff`. The base was the frozen branch `main-39867df`, which I fetched as `origin/main-39867df`.
- **Panel run:** `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh … 174 origin/main-39867df` exited 0 and ended with "code-panel single-round — must-fix". All 33 seat processes finished with status ok, and the aggregate has 32 seat verdicts: 10 request changes, 15 comment only, 7 approve. The run is recorded in the journal at `panel-runs/kriscendobot-minion.town-174/9441a3770249.md`.
- **A second record exists:** my first launch of the panel, which I stopped to restart it without a time cap, appears to have finished first. It left another record, `7f3af2f87b9e.md`. The verdict I posted comes from `9441a3770249`.
- **Review posted:** https://github.com/kriscendobot/minion.town/pull/174#pullrequestreview-5469395377
  - It is a comment review, not a request-changes review. GitHub refuses request-changes on the bot's own PR, and the round 1 verdict was posted the same way.
  - The full aggregate is 91KB, over GitHub's review body limit, so the posted body is about 62KB. All 10 request-changes seats are in full and the rest are included until the space ran out. The 14 seats that didn't fit are named at the bottom (none of them requested changes); their full text is in the journal record.
- **Main must-fix items:**
  - In `publish`/`upgrade`, the credit refund only covers failures while storing. If `evaluateRegister` or `writeDirectory` fails afterwards, the user stays charged.
  - The read-only CLI command rewrites the live ledger file (`src/endo/credit-ledger.ts:96-109`).
  - `designs/ertp-credits.md` has gaps: the list of record kinds omits `refund`, and a design citation points at text that isn't there.
  - The PR skips steps in the build order of `clip-usage-metering.md` without saying so.
  - `creditLedgerDir` is an abbreviated identifier.

I made no fixes and left the PR in draft; the fixer stage is next.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr174-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1049255 cached reads)
- Output: 6119 tokens
- Cost: $0.7686789999999999
- Wall-clock: 566s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
