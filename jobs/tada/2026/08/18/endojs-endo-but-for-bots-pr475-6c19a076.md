All done and verified. The head is my landed commit `9b202d4554`, inbox is clear.

## Completion report

**Job:** attention directive on endojs/endo-but-for-bots PR #475 — @erights (issue-comment 5321775351 + follow-up 5321778831 "And the tests"): "Yes, please do both. And please correct all the prose so `isView` becomes the only fidelity loss we're committed to."

**Preflight:** exit 2 (HINT). Corroborated — the latest branch commit (`cae5509130`, 00:06:23Z) predated the directive (00:11:45Z), so no peer had resolved it. Proceeded.

**What I did** (landed as PR-head commit `9b202d4554`, pushed CAS-clean to `feat/narrow-bytearray-to-uint8`):

1. **byteArray.js change** — `@endo/pass-style` `src/byteArray.js`: the two-shape brand check now discriminates on `ArrayBuffer.isView` (`isView(candidate) ? ownIndexCount === length : ownIndexCount === 0`). Strictly more precise — rejects an emulated wrapper tampered with `length` own indexed writes (and a native exotic stripped to zero).
2. **compare.js index-in-place rewrite** — `@endo/bytes` `src/compare.js` `toIndexableUint8` now indexes a genuine view in place (zero-copy) and copies only a non-view (emulated) wrapper or bare buffer, gating on `isView` instead of the `.immutable` accessor.
3. **Prose corrected** so `isView` is the one committed fidelity loss — immutable-arraybuffer README (new "The one committed fidelity loss" section; integer-indexed-read and `[Symbol.toStringTag]` sections retitled "(an incidental consequence)"), `designs/freezable-typedarray.md`, the byteArray.js axis comment, and both changesets.
4. **Tests** — new committed pins `ArrayBuffer.isView(emulatedWrapper) === false` (shim side in `shim-typedarray.test.js`, client side in `bytes/test/main.test.js`); read-`undefined` and toStringTag tests reframed as companion observations.

**Verification:** validated both rewrites empirically against the real shim (emulated wrappers order correctly through `compareBytes`; discriminator accepts both valid shapes, rejects tampered ones). `prettier --check` clean on all 9 files. Posted the per-round summary comment (#issuecomment-5321895142).

**Race coordination:** on draining my inbox I found this same erights request had been split into two comments and posted as two more jobs (`pr475-fa8acb7f`, `pr475-e4629ae8`); `fa8acb7f` had asked me to stand down, but that message arrived after I'd already completed and won the push. I messaged both peers to stand down (head is `9b202d4554`) and complete as verified no-ops to avoid duplicate/clobbering commits. Remote head re-confirmed still mine after notifying them.

**Follow-ups:** `eslint`/`tsc` couldn't run locally (the worktree's install is incomplete — the known native-build env gap); CI will verify them. The two racing peer jobs should resolve as no-ops.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr475-6c19a076.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 133 tokens (8167329 cached reads)
- Output: 69925 tokens
- Cost: $7.436887500000001
- Wall-clock: 954s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
