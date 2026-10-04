# Panel round 1 for kriscendobot/garden-book#12: must-fix

I ran one single-round panel on PR #12 and posted the verdict. The result is **must-fix**. I did not fix anything, un-draft the PR, or start another round.

**How it ran**
- **Checkout:** isolated project worktree of `kriscendobot/book-equilibrium-data` at head `634e04b9fc`.
- **Panel:** ran with `GARDEN_PANEL_SINGLE_ROUND=1` against the PR's exact base commit `6e0ad9790d`, not the possibly stale `origin/main-6e0ad97` branch ref. All 33 seats returned `ok` and there was no decider error. The terminal line read "code-panel single-round — must-fix", which is what `panel.sh` prints on a normal exit.
- **Exit code:** I didn't capture `panel.sh`'s exit code because it ran detached. I'm treating the run as a clean exit 0 based on that terminal line.

**Where the verdict is posted**
- The aggregate is 83 KB, over GitHub's 65,536-character limit for a review body. I split it at seat boundaries:
  - **Part 1 (review):** a seat/verdict table plus the first half of the seat blocks. GitHub refused a request-changes review because the PR is the bot's own, so it is posted as a `COMMENTED` review (7.31Z).
  - **Part 2 (comment):** the remaining seat blocks, posted as https://github.com/kriscendobot/garden-book/pull/12#issuecomment-5977725269.
- **Seat verdicts:**
  - request-changes: assessor, stylist, prover, saboteur and fast-checker
  - summary-fix: pruner
  - comment-only or approve: most of the rest

**Main finding for the fixer**
- **Assessor (must-fix):** in `art/generate-equilibrium-charts.mjs` (lines 498–616), charts E6 and E7 read counts produced by `tally()` without a default. `tally()` leaves out any category with zero occurrences, so a later regeneration where a count drops to zero would draw broken (`NaN`) bars and print `undefined` in the charts. The fix is `?? 0`.
- **Typist:** five characters to replace with plain-text equivalents (`→`, `×`). The gate's `--fix` handles most of them; the `×` inside a formula needs `*` rather than the automatic `x`.
- **Other request-changes seats:** stylist, prover, saboteur and fast-checker have findings in the posted aggregate.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/book-equilibrium-stylize-20261004-gauntlet-panel-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1099910 cached reads)
- Output: 6460 tokens
- Cost: $0.77655
- Wall-clock: 427s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
