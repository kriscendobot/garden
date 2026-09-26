Done. This was an attention-routing task, not a garden-library change, so there's nothing to commit to `main2`.

**What I did**

Triaged the flagged directive on endojs/endo-but-for-bots **issue #851** (not a PR — it's kumavis's diagnosis issue "Per-package lint:types silently skips via stale tsbuildinfo").

- The comment our watcher flagged (5212022426, 0xpatrickdev) was **explicitly retracted as misdirected** in the very next comment (5212042033): *"that message was intended for @kumavis, not you."* So that comment was not a task for us.
- The genuine standing ask to us is the **issue OP itself**: kumavis wrote *"@kriscendobot could you review this diagnosis and weigh in on options 1–3?"* — which we had only acked (5212031311), never answered.
- I grounded and posted that weigh-in: [issue-comment 5212058673](https://github.com/endojs/endo-but-for-bots/issues/851#issuecomment-5212058673). It endorses the diagnosis, and takes a position on the options: **option 3 is the real gate and is already landed via #922** (merged to `llm` 2026-08-04); between 1 and 2 prefer 1; but **better than either is #952's principled presence typing** (`FarRef<Primary>`/`ERef<T>`) which clears all ~100 errors while keeping type checking rather than widening to `any`. Flagged the honest residual (the `onImport` → `FarRef<any>` CapTP seam #952 leaves open) and offered to review #952 when tagged.

**Verification**
- #922: closed/merged to `llm` 2026-08-04 (lands option 3). #952: open, non-draft, mergeable, base `llm` (addresses options 1&2 via presence typing).
- Comment posted cleanly with the auto-injected provenance footer (`model claude-opus-4-8 · harness claude · garden c7d730c3`) and correlation marker `garden-reply:5212022426`.
- Inbox drained — empty.

**Follow-ups**
- 0xpatrickdev said he'll tag @kriscendobot to review #952; expect a review-request that the comment-watcher will pick up when it lands.
- The `onImport` → `FarRef<any>` typing seam is the open edge left after #952 — a candidate for a future issue/build if kumavis/patrick want it pursued.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr851-f1568461.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 19 tokens (443257 cached reads)
- Output: 10761 tokens
- Cost: $0.9177105000000002
- Wall-clock: 178s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
