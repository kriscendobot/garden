## Completion report

**Job:** Guard `@endo/pass-style` byteArray tests against a native immutable ArrayBuffer (endojs/endo-but-for-bots PR #475, head `feat/narrow-bytearray-to-uint8`).

**What I did**
1. **Enumerated** every test in `packages/pass-style/test/byteArray.test.js` (18 tests) against the actual `byteArray.js` validator, and audited the siblings — `byte-array.test.js`, `passStyleOf.test.js`, `symbol.test.js`, `safe-promise.test.js`. Only `byteArray.test.js` carries emulated-wrapper dependencies; the sibling `byte-array.test.js` only asserts genuine-view acceptance (holds on both paths).
2. **Guarded 6 emulated-only tests** with a local `emulatedOnlyTest` helper (mirroring `immutable-arraybuffer/test/_emulated-only.js`, detecting emulation via `!ArrayBuffer.isView(new Uint8Array(new ArrayBuffer(0).sliceToImmutable()))`):
   - toStringTag **own-slot** deepEqual on a raw IAB (native inherits `'ArrayBuffer'` on the prototype, no own slot).
   - "no own indexed properties regardless of length" (a genuine view has length-many).
   - the two `view[i]=x` own-property-shadow tamper rejections (a no-op on a genuine immutable-backed view → the value is *accepted*, so the `t.throws` would fail).
   - `defineProperty` at an out-of-range integer index, and an accessor at an integer index (both throw at the `defineProperty` call on a genuine integer-indexed exotic, before `passStyleOf`).
3. **Deliberately left 12 unguarded** because they hold on both paths — genuine-view acceptance, byteOffset/length span rejections, mutable-buffer rejection, and the **non-index / non-canonical-key / buffer-expando** rejections (`'extra'`, `'01'`, buffer `'tampered'`) whose rejection *messages* the validator reproduces identically on a genuine view. This matches the reference commit `3e33abfb1`'s discipline (guard wrapper-shape observations; leave structural/expando guards).
4. **Ran the suite** via `ses-ava` under Node: 18 passed on both config legs, no regression.
5. **Lint:** `eslint test/byteArray.test.js` → 0 errors.
6. **Committed** test-only (no changeset) and **pushed** to `feat/narrow-bytearray-to-uint8` with a rebase-CAS loop (`4dbe5ffff..affe74453`). No new PR opened; no review conversations touched.

**Follow-ups / notes**
- Three tamper-rejection tests I kept unguarded (`'extra'`, `'01'`, buffer `'tampered'`) rely on a genuine engine (a) treating those keys as ordinary/expando properties `defineProperty` accepts and (b) native immutable ArrayBuffers being extensible objects — my reasoning holds and matches the shim's own model, but this is the one classification that can only be *empirically* confirmed once an engine wires `test:xs`/native support. These files still run only under Node today (pass-style has no `test:xs`), so they remain inert until then, exactly like the other two packages.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-guard-passstyle-emulated-tests.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (2625241 cached reads)
- Output: 26929 tokens
- Cost: $2.8771584999999993
- Wall-clock: 385s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
