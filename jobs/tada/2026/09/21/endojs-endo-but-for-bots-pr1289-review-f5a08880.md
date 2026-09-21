All review asks are resolved. Completion report follows.

---

## Completion report: PR #1289 review (kriskowal → respond to @gibson042)

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED — no peer resolution). Verified no correlated fix existed; did the work.

**Enumerated asks.** The review body (id `5271785979`, kriskowal, CHANGES_REQUESTED) carried no inline comments of its own; its sole directive was "respond to @gibson042". gibson042's actual feedback lived in review `5225048373` as two inline comments on `packages/marshal/test/passables-equal.js`:

1. **line 45 (`default` case):** missing identity tracking for `error`/`promise`/`remotable` (a WeakMap value→seen-index), and no throw on an unknown pass style.
2. **line 12 (JSDoc):** "Slightly inaccurate" — the claim that non-byte-array passables retain AVA's `deepEqual` behavior.

**What I changed** (`858996f8cd`, pushed to `kriscendobot/endo-but-for-bots feat/passables-equal-ava-operator`):
- Rewrote the helper as a **per-operand projector** with a `WeakMap` value→index. `remotable`/`promise` compare by **sharing topology**; `error` carries `name`/`message` **plus** that index (so round-trip error diagnostics stay checked). Per-operand (not shared across operands) was the key correctness point — a shared map wrongly broke the marshal round-trip suites, because a reconstructed error/remotable is a distinct JS object in the same slot.
- `default` now `throw Fail\`Unexpected pass style ${q(passStyle)}\`` (exhaustive switch ⇒ `never` at the type level too).
- Rewrote the JSDoc to enumerate the per-pass-style projection accurately.
- Added tests for shared-vs-distinct remotable topology and error name/message/topology.

**Verification:** helper tests + all three consumer suites (capdata, smallcaps, stringify) = **32 passing**; `tsc` (lint:types), eslint, prettier all clean.

**Responses posted** (satisfying the review directive):
- Inline reply to line-45 comment: `#discussion_r4066557913`
- Inline reply to line-12 comment: `#discussion_r4066559217`
- Top-level summary to @kriskowal/@gibson042: `#issuecomment-5767743240`

**Follow-ups / state:** PR remains a DRAFT (unchanged); under the manual-gauntlet regime I staged no gauntlet — the maintainer promotes with "run the gauntlet #1289" when ready. gibson042's CHANGES_REQUESTED will need a re-review to clear; the per-operand-vs-shared-identity reasoning for errors is spelled out in the inline reply in case they prefer a different error-comparison policy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1289-review-f5a08880.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (3416110 cached reads)
- Output: 36945 tokens
- Cost: $3.479958000000001
- Wall-clock: 634s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
