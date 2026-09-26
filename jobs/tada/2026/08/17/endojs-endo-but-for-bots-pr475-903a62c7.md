The reply is posted with the correct `garden-reply:5321243322` marker and provenance footer. Job complete.

## Completion report

**Directive** (erights, PR #475 comment 5321243322): *"Does the `immutable` accessor distinguish emulated vs genuine, or mutable (always genuine) vs immutable (genuine on XS, emulated on current Node)?"*

**What I found on re-derivation:**
- A peer's comment 5321257057 (posted 2 min after the question, tagged to the sibling directive 5321203329) had already conceded the substance in prose — the accessor tests immutable-vs-mutable, and the "emulated wrapper vs genuine view" phrasing was wrong.
- **But the same conflation was still baked into the code**, not just the PR comment: `packages/pass-style/src/byteArray.js:19` described the brand check as distinguishing *"emulated immutable buffers from genuine ArrayBuffers"* — exactly the axis error erights flagged. That was the real un-closed gap.

**What I did:**
1. Verified the `.buffer.immutable === true` sites at the PR head (`byteArray.js`, `bytes/{compare,concat,to-string}.js`) — all confirm the check means "immutable backing (shim *or* native stage-3) → copy," i.e. immutable-vs-mutable.
2. **Fixed the misleading code comment** in `byteArray.js` to state the immutable-vs-mutable axis, note it reports `true` for both genuine-native and emulated immutable buffers and `false` for mutable (always genuine), and point at where emulated-vs-genuine is actually drawn (own integer-indexed-key count). Committed `9d397b5a65`, pushed to `feat/narrow-bytearray-to-uint8` via rebase-CAS.
3. **Posted the follow-up** this job's "On it" promised (comment 5321425036, tagged `garden-reply:5321243322`): directly answers erights' either/or — it's the second reading (mutable vs immutable) — confirms his framing, and reports the code-comment fix.

**Changed:** PR #475 head `b4a8175f52 → 9d397b5a65` (one docs commit); one PR reply comment.

**Follow-ups:** none. The comment-only change won't affect CI beyond the pre-existing flakes already documented in comment 5321126550.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-903a62c7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 32 tokens (941716 cached reads)
- Output: 14396 tokens
- Cost: $1.3806520000000002 (2 engagement(s) unpriced)
- Wall-clock: 336s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
