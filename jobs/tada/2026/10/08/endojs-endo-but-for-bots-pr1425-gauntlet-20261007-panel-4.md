Panel round 4 on endojs/endo-but-for-bots#1425 came back **must-fix**, and the review is on the PR. I checked again: it's there against head `842abe7fcf`. The only must-fix item is the PR description; the code change itself has no must-fix findings. Last time the job wasn't recorded as done because my report ended with the result marker instead of the completion line. Nothing new was run this time.

**What ran:** `panel.sh` in single-round mode against head `842abe7fcf`, on an isolated checkout. The base was `master-6ee3fda`, passed as its exact commit `6ee3fda77b`. It exited 0 with disposition `must-fix`.

**How the 34 seats voted:** 11 approve, 22 comment-only, 1 request-changes.

**The must-fix (pruner seat):** the PR description is too long. The automatic length check flagged it too (481 words, over the 300 limit). The fix:
- Remove the "Scaling / Documentation / Upgrade Considerations: None" sections.
- Replace the per-file "The changes:" list with one or two sentences.

**Earlier rounds' repeats:** rounds 2 and 3 kept raising must-fix items on the same mechanism. Asked directly, the decomplector seat concluded the `onIntrinsics` hook is needed and is the smallest option that works.

**Should-fix items in the review:**
- The `dorny/paths-filter` pin change in `ci.yml` is unrelated to the fix. Move it to its own PR or explain in the PR why it's included.
- Two different constructors are both named `ShimStartCompartment`. Rename one or add a comment telling them apart.
- Type fixes in the hook's comments: avoid the bare `Function` type.
- Post a top-level comment saying which round 2/3 items head `842abe7fcf` addressed.

**How it was posted:** as a comment review, because GitHub won't let the bot request changes on its own PR; rounds 1–3 were posted the same way. The full panel output was over GitHub's size limit, so I cut the approving seats' text and kept only their names. Review: https://github.com/endojs/endo-but-for-bots/pull/1425#pullrequestreview-5458021169

**Follow-up:** the next gauntlet stage (the fixer) should handle the PR description and the `ci.yml` question.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1425-gauntlet-20261007-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1154813 cached reads)
- Output: 6797 tokens
- Cost: $1.8340816000000002
- Wall-clock: 229s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
