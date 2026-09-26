Pushed to main2.

## Completion report

**Job:** Narrow `retro_eligible` in `scripts/jobs/comment-watcher.sh` so a review/attention whose sole actionable content is a pipeline-op verb, or an empty approval with zero inline comments, mints no retro.

**What I found:** The 2026-08-15 narrowing (commit `35762f50`) already suppressed the retro for two body-only shapes — `review_is_pipeline_op_only` (conduct/rebase/shepherd/retcon/weave/merge/close) and `review_is_empty_approval` — but the gate-out was wired **only** into the `VERB=review` branch. An `attention` job (the ambiguous/trusted-directive class) whose body was a bare pipeline directive like "please conduct" or "rebase and merge" still passed `reads_as_directive` → `retro_eligible=y` → minted a retrospective indicting a merge directive that reviews nothing. That leak was the bulk of the ~85% dismissal flood.

**What I changed:** Restructured the retro-eligibility block so the two verb classes are computed first (`review` unconditionally; `attention` when its body reads as a directive), then **both** flow through one shared, deterministic, body-only gate-out that clears `retro_eligible` when `review_is_pipeline_op_only || review_is_empty_approval`. No new predicates, no LLM in the watcher, no change to the primary review/attention job — only the paired retrospective is suppressed. Updated the two lead-in comment blocks to describe the consolidated behavior.

**Verification:** `bash -n` clean; extracted the two predicates and unit-tested them — "please rebase, retcon, and conduct", "conduct", "please merge this PR", and an empty `[APPROVED]` all gate out, while "please fix the null deref" and an approval-with-a-note both keep the retro. Committed and rebase-CAS-pushed to `main2`.

**Follow-ups:** None. The change deploys to every instance on the next deliberate deploy of the root checkout.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-review-retrospective-consolidated-20260804-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 29 tokens (798157 cached reads)
- Output: 7352 tokens
- Cost: $1.0537015
- Wall-clock: 117s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
