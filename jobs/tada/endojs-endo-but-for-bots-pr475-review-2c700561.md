Completed the review directive on endojs/endo-but-for-bots PR #475 (review 4976935353 by @erights).

**The ask (single inline comment, 3816877676):** "check for other such phantom references anywhere in this PR head" — dangling references in comments/docs to identifiers this PR renamed or deleted.

**What I did:**
- Preflight: `PROCEED` (no peer resolution). Enumerated the review — exactly one inline comment tied to it; re-fetched an empty review body.
- Got an isolated PR-head checkout (f7f7a278e) and swept every changed file against the PR's own rename map, corroborated against the actual code and the `consolidate-immutable-byte-utilities` changeset. Also ran a background thorough scan agent to cross-check.

**Fixed (commit `2419e759b`, pushed to the PR head `feat/narrow-bytearray-to-uint8` on endojs/endo-but-for-bots):**
1. `packages/bytes/src/compare.js:41` — the thread's own phantom (still present at head): named the removed `compareUint8Arrays` and described a `1` return `compareBytes` doesn't produce. Reworded to describe actual behavior, self-contained.
2. `packages/immutable-arraybuffer/designs/freezable-typedarray.md` (added by this PR) — "Future adapter withdrawal" section described the deleted `bytesToImmutable`/`bytesFromImmutable` + deleted files as present and the withdrawal as a future out-of-scope follow-up, though this same PR already did it. Rewritten to shipped `frozenBytes`/`thawedBytes` names and completed tense.
3. `.changeset/byte-array-hex-codecs.md` — claimed marshal-justin renders `bytesToImmutable(...)`; code actually emits `frozenBytes(decodeHex(...))` (marshal-justin.js:350). Corrected.
4. `.changeset/narrow-bytearray-to-uint8.md` — named the removed functions as current API (would publish phantom names in merged changelogs). Corrected.

**Deliberately left as-is (with justification given in the reply):** `immutable-arraybuffer.md` (a R100 byte-identical rename of pre-existing `DESIGN.md`) — historical narration of a prior refactor; the doc disclaims retroactive rewrites. `compareUint8Arrays` is genuinely live in `@endo/ocapn`/`@endo/ocapn-noise`, untouched.

**Verification:** prettier clean on all changed files; compare.js change is comment-only (eslint status unchanged). Posted a threaded reply (r3816960288) via `jq --rawfile`/`--input` so the backtick-heavy body never touched the shell — confirmed 96 backticks rendered intact. Added a 👍 reaction to the request. Inbox drained clean.

**Follow-ups:** none required. CI is unaffected (docs/comments/changesets only); the directive did not ask for CI shepherding.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-review-2c700561.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (3110469 cached reads)
- Output: 37702 tokens
- Cost: $5.381390249999999
- Wall-clock: 856s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
