---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
The prosecutor retro on kriscendobot/minion.town#68 (review 5083859413, body "please run a gauntlet") had to spend a full scoped pass to reach a guaranteed not-a-miss verdict, because `review_is_pipeline_op_only()` (comment-watcher.sh:769-793) does not recognize the sanctioned gauntlet-trigger phrase as a pipeline-op: `RETRO_PIPELINE_OP_VERBS` (line 769) lists `conduct rebase shepherd retcon weave merge close` but omits `gauntlet`, and `RETRO_DIRECTIVE_GLUE` (line 772) omits `run` — so the residual-word scan over "please run a gauntlet" leaves `run`+`gauntlet` unrecognized and falls through to minting a retro. Under the manual-gauntlet-trigger regime a review body that is *only* the gauntlet-trigger verb ("run the gauntlet [#N]" / "please run a gauntlet") is structurally always a maintainer-invoked pipeline advance, never review-catchable feedback — the same class the 2026-08-15 pipeline-op-only gate already exists to filter for `conduct`/`rebase`/etc. Add `gauntlet` to `RETRO_PIPELINE_OP_VERBS` and `run` to `RETRO_DIRECTIVE_GLUE` so this shape is gated out like its siblings; the primary gauntlet-recording job (line 1969 `[ "$VERB" = gauntlet ]`) is unaffected — only the paired retrospective is skipped. Confirm no existing test fixture exercises "gauntlet" as a residual word before landing.

<!-- garden-transient-elapsed: kind=signature through=0 values=4 -->
<!-- garden-reap-now -->
---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-17T14:51:49Z
