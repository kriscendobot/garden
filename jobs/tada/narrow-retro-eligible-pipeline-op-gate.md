Empty inbox. Work is complete and pushed.

## Completion report

**What was asked:** Narrow `retro_eligible` in `scripts/jobs/comment-watcher.sh` so a `review`-classed comment that indicts no work product mints no review retrospective — for two specific, deterministically-detectable shapes only, keeping the LLM out of the watcher.

**What I did (committed `35762f850e`, pushed to `main2`):**

1. **`scripts/jobs/comment-watcher.sh`** — added two pure-string helpers (`review_is_pipeline_op_only`, `review_is_empty_approval`) plus two closed word sets (`RETRO_PIPELINE_OP_VERBS` = conduct/rebase/shepherd/retcon/weave/merge/close; `RETRO_DIRECTIVE_GLUE` = the connective filler), and wired them into the existing verb-class `case` at the `retro_eligible` computation. Now, when `VERB=review`:
   - **Shape 1** — the body's only actionable content is a pipeline-op verb (strip state markers → tokenize → remove pipeline-op verbs + glue; if a pipeline-op was seen and nothing else remains → gate out). A body carrying `[INLINE-REVIEW]` never qualifies.
   - **Shape 2** — an `[APPROVED]` body that is empty/whitespace-only with no `[INLINE-REVIEW]` marker → gate out.
   - Any residual non-glue word (real feedback) keeps the retro, so the gate **errs toward minting** (prior behavior). The primary review/finalization job is untouched — only the paired retrospective is suppressed. A gated review is logged.

2. **`scripts/jobs/test/comment-watcher-test.sh`** — three new cases beside the existing retro tests: the **canonical** APPROVED 35-char "Please rebase, retcon, and conduct." with zero inline (primary review job still mints, no retro); a **keep-case** (a verb bundled with substantive feedback still mints its retro); and the **empty-approval** case (no retro).

**Verification:** `bash -n` clean on both files; shellcheck no findings on the new code; full comment-watcher suite **312 passed / 0 failed**; provenance suite 28/0.

**Honest scope note (not overselling):** measured against `journal/review-misses/` (2026-08-15, 195 dismissed vs 50 real misses, all dismissals `new-direction`), expected yield is ~10-15% of retrospective spend — not the ~85% dismissal rate, whose dominant cause is genuinely new direction no review surface could anticipate.

**Follow-up / caveat:** Shape 2 is a correct but largely **defensive** guard — a clean empty-body zero-inline approval already routes to `VERB=finalize` (conductor) upstream in `classify`, so it does not reach the review-case retro path today; the ~19 empty-body retros in the corpus were reviews the source flagged `[INLINE-REVIEW]` (nonzero inline from the watcher's deterministic view) and so are outside the "zero inline" shape by design. The guard makes the intent explicit and covers any future routing. No further work is owned by anyone else.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/narrow-retro-eligible-pipeline-op-gate.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 79 tokens (3825995 cached reads)
- Output: 42479 tokens
- Cost: $4.0868685000000005
- Wall-clock: 881s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
