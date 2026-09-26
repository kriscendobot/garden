Inbox empty. The job is complete.

---

## Completion report

**Task:** Verify erights's obsolete "all tests exercise the shimmed path" claim on endojs/endo-but-for-bots PR #475, confirm no head code depends on the "no native engine / always shimmed" assumption, fix what should be fixed, file follow-ups, and reply.

**Findings**
- **Claim is obsolete.** Current XS ships native immutable ArrayBuffer, and the shim's install policy is stage-3 *detect-then-skip* (`immutable-arraybuffer/src/shim.js`): when `sliceToImmutable` already exists, the shim steps aside and native wins, so `new Uint8Array(iab)` is a *genuine* view — not the emulated plain-object wrapper.
- **The obsolete prose does not survive in the tree.** Design docs, both READMEs, and all changesets are already correctly hedged/symmetric (native-vs-shim); no text asserts the "always shimmed" premise. The claim lived only in the PR comment.
- **Runtime source is native-safe** — it branches on `ArrayBuffer.isView` and takes the genuine-view path under native.
- **The dependence survived only in test code**: unit tests that unconditionally construct an emulated wrapper and assert emulated-only shapes (`isView === false`, `view[i] === undefined`, the `[object ImmutableArrayBuffer]` buffer tag, OrdinarySet own-property shadowing). These pass today only because Node lacks native support *and* these packages' `test:xs` is `exit 0`/absent — latent failures that surface once any engine ships native support or `test:xs` runs under `xst`.

**What changed** (landed as `0984dd89b` on head `feat/narrow-bytearray-to-uint8`)
- Added `packages/immutable-arraybuffer/test/_emulated-only.js` — a runtime native-detection predicate exporting `emulatedOnlyTest` (`test` under the shim, `test.skip` under native).
- Gated the emulated-only assertions in `@endo/immutable-arraybuffer` (`shim-typedarray.test.js` ×4, `shim-typedarray-per-flavor.test.js` ×2, `shim-amplifier.test.js` ×1) and `@endo/bytes` (`main.test.js` ×2, inline predicate) behind it. Byte-value assertions that hold on both paths stay unguarded.
- Test-only, no changeset needed. Composes cleanly with the toStringTag getter-wrapper repair (`fc2238dcb`) that landed mid-job — I rebased onto it and dropped my now-obsolete guards on the toStringTag tests (that commit closed the fidelity gap, so they're native-safe; `isView` remains the single distinguisher).
- Local CI-equivalent checks all green: immutable-arraybuffer 237 tests, bytes 44 tests; eslint 0 errors; tsc 0 errors on both packages.

**Follow-up filed** — parked plan job `endojs-endo-but-for-bots-pr475-guard-passstyle-emulated-tests`: `packages/pass-style/test/byteArray.test.js` carries the same latent pattern in a more nuanced form (~9 tests whose tamper setup — `view[0]=X` shadow, `defineProperty` at an index, the `isView false, needs 0` message — is unreachable on a native genuine view). Left for a dedicated pass rather than rushed in. `@endo/base64` audited clean.

**Reply posted** to erights: https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-5349170331 (top-level PR comment; no conversation resolved, per erights's policy).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-verify-shimmed-claim-20260819.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 150 tokens (8969421 cached reads)
- Output: 70336 tokens
- Cost: $8.722208999999996 (1 engagement(s) unpriced)
- Wall-clock: 1016s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
