All 27 CI checks pass on my pushed commit `56d160f534`. CI is GREEN — the fix stage is complete.

---

**Gauntlet FIX round 5 — endojs/endo-but-for-bots PR #796 — complete.**

Applied the panel round-5 must-fix items as review-feedback follow-up commit `56d160f534` on `feat/hashline-core`, pushed via `safe-push-pr-head.sh` (advanced `b5932998b7 → 56d160f534`, no rewind). All 27 CI checks are green.

**What changed (8 files):**

- **crc32 detached-buffer guard** (warden / spec-keeper / engine-realist must-fix): replaced the shadowable, engine-gated `buffer.detached` plain-property read with a portable `Reflect.construct(Uint8Array, [buffer, 0, 0])` probe — throws on a detached buffer in every engine (incl. XS and the Node 20.17 floor), cannot be defeated by a planted own `detached: false`, accepts `SharedArrayBuffer`. Added a shadow-attack regression test.
- **hashline `isWellFormed`** (saboteur must-fix): swapped the raw `String.prototype.isWellFormed` native reach for `@endo/pass-style`'s `isWellFormedString`, so a payload-carrying edit yields a structured failure (not a raw throw) on engines lacking the built-in.
- **hashline `options` seam** (assessor/locksmith/breaker/saboteur/prover): routed guest-supplied `options` (null, non-object, throwing accessor, non-boolean `reapply`, out-of-range `reapplyWindow`) through the structured `patch-syntax` failure contract instead of raw engine throws; expanded the options test to pin every path.
- **hashline payload cap** (breaker must-fix): cap per-op payload length (read once) against `MAX_RESULT_CHARS` before validating, closing the proxy-over-array CPU-amplification hole.
- **whitespace wire contract** (archivist must-fix): pinned trailing-strip to exactly U+0020/U+0009/U+000D (not the wider `.trimEnd` set) in the module header, the normalize comment, and `designs/cli-edit-verb.md`.
- **`EditResult` type-doc** (purist/locksmith/wire-watcher must-fix): corrected the "by construction" claim — whole-file channel is closed, but per-line CRC digests on the failure path are a read oracle, so documented the `edit`-presupposes-`read` invariant on `EditResult` and `AnchorMismatch`.
- **regression tests** (prover must-fix): pinned `newText` absent from the success `EditResult`; added `t.timeout` to the stall/exhaustion tests.
- **changeset** (packager x2 / archivist / curator / migrator must-fix): fixed the DataView error class (RangeError, not TypeError), added `SpliceOutcome` to the type enumeration, dropped the bump-rationale precedent clause; crc32 README now spells every optional default and the index/length RangeError.

Local gates before push: crc32 17/17 + hashline 63/63 tests pass, `tsc` clean both packages, eslint 0 errors, prettier clean.

**Deliberately deferred (reported, not applied this round):** the wire-watcher must-fix requiring the strict anchor width to be `>= anchorHexWidthForLineCount(lines.length)` — it changes documented wire behavior (the design explicitly justifies the current width-selection, and a test pins it), so it warrants a maintainer decision rather than a unilateral wire change in an automated round; and the packager should-fix renaming the `./src/hashline.js` public subpath. Note: kriskowal left a review "resume this on a rebase when immutable byte arrays merge," so the PR is maintainer-parked pending a rebase.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr796-gauntlet-resume-20260822-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 189 tokens (13079239 cached reads)
- Output: 61477 tokens
- Cost: $9.718948500000002
- Wall-clock: 2280s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
