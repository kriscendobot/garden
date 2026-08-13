FIX round 1 complete. Applied the panel-1 must-fix items to PR #980, pushed as a follow-up commit, and CI is fully green.

**Must-fix items addressed (from the panel-1 request-changes jurors):**

1. **Swissnum ASCII decode gap** (breaker, purist, spec-keeper — request-changes; engine-realist — comment-only). `decodeSwissnum` relied on `TextDecoder('ascii', { fatal: true })`, whose `'ascii'` label is a windows-1252 alias per the WHATWG Encoding Standard, so bytes `0x80`–`0xff` decoded to Latin-1 characters instead of throwing — an asymmetric invariant against the newly-strict `encodeSwissnum`. Fix:
   - Added `decodeAscii` to `@endo/ascii` (a pure-JS, XS-safe strict inverse of `encodeAscii`) with a new `./decode.js` subpath export, index export, README update, and a full test file (round-trip + `0x80`–`0xff` rejection + type-guard).
   - Routed `decodeSwissnum` through it; removed the `TextDecoder`. Verified the SturdyRef read path reconstructs raw-byte secrets via `swissnumFromBytes` (never `decodeSwissnum`), so non-ASCII byte swissnums still round-trip verbatim — no regression.
   - Added `decodeSwissnum` boundary tests to `packages/ocapn/test/ascii.test.js`.

2. **Changeset bump level** (migrator, changeset-auditor — the explicit `must-fix-loop`). `@endo/ocapn` was marked `patch` but the hub now rejects previously-accepted non-ASCII string swissnums on a post-1.0 published package. Raised to `minor` and rewrote the body to distinguish the newly-strict hub path, the newly-strict decode path, and the already-strict client encode path (whose error type/message changed `Error` → `RangeError`). Added a `@endo/ascii: minor` changeset for the new `decodeAscii`.

**Verification:** `@endo/ascii` tests (16) pass, `@endo/ocapn` `ascii.test.js` (5) pass across all three ses-ava configs, both packages type-check clean, eslint clean on changed files. Pushed via `safe-push-pr-head.sh` (`fdd0443034 → 1a95fbac86`). All 26 CI checks green (including `test-xs` and `test262`).

**Follow-ups (non-blocking, out of scope for this fix round):** several jurors flagged test-completeness nits (generalize `encodeSwissnum` rejection across the full range; assert `swissnumHex`'s two branches hash equal; add `publish`/`publishHeld` `ArrayBufferLike` coverage) and one self-improvement (a `skills/adversarial-tests` entry for the `TextDecoder('ascii')` windows-1252 trap). The driver re-posts panel-2 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-ascii-adopt-ocapn-sites-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 112 tokens (4881906 cached reads)
- Output: 30417 tokens
- Cost: $5.020874999999998
- Wall-clock: 1070s
- Model(s): claude-opus-4-8 ×2

<!-- garden-usage-end -->
