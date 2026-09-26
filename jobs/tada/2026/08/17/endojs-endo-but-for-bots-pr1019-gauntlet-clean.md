This PR is a pure design-doc change — it only adds `designs/rust-module-lexer-consolidation.md` (+218) and one line to `designs/README.md`. There is no application code touched, so the coverage pass and dead-code removal have nothing to act on. All five CI checks are terminal **SUCCESS** at the current head `df8fc54b45`.

The clean stage is a genuine no-op here.

## Completion report

**Job:** Gauntlet CLEAN stage for endojs/endo-but-for-bots PR #1019 ("design(endor): consolidate the Rust module lexer, share tests with cjs-module-analyzer").

**What I did:**
- Checked PR shape for idempotence via `gh pr view`. PR is a draft, OPEN, head `df8fc54b45f8cc54ee57597edc271a0cdc0040af`.
- Inspected the diff: 2 files, +219/-0 — `designs/rust-module-lexer-consolidation.md` (new design doc) and a one-line addition to `designs/README.md`. No source packages touched.
- Confirmed CI is terminal GREEN: `browser-tests`, `lint`, `build`, `zizmor`, `test` all `SUCCESS`/`COMPLETED`.

**What changed:** Nothing. There is no code to run a coverage pass over and no dead code the change could have orphaned, so no follow-up commits were pushed to the PR head. CI is already green at the current head.

**Follow-ups:** None for this stage. The gauntlet driver may advance to the next stage.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1019-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 6 tokens (99923 cached reads)
- Output: 1240 tokens
- Cost: $0.3533155 (1 engagement(s) unpriced)
- Wall-clock: 24s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
