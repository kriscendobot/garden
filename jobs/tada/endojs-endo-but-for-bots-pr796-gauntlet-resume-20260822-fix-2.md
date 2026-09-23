All 27 checks pass, head is my commit `f4a1b0c497`, PR mergeable. The fix stage is complete and CI is green.

## Completion report

**Gauntlet FIX round 2 — endojs/endo-but-for-bots PR #796: applied the panel round-2 must-fix items, pushed, CI green.**

Read the latest panel verdict (round 2, request-changes at head `4bb3ebee27`) which raised 9 blocking must-fix items M1–M9. Applied all of them in one follow-up commit `f4a1b0c497` on the PR head branch `feat/hashline-core`:

- **M1** (`packages/crc32/src/crc32.js`): replaced the `ArrayBuffer.isView` fast-path gate — which is true for every `DataView` and every typed-array element kind — with a genuine single-byte-view brand (intrinsic `%TypedArray%.prototype` `length === byteLength`). Non-byte views, lookalikes, and length-spoofing subclasses now fall to the validating `.at` path and throw instead of silently checksumming wrong. Captured `.at` once. Added regression tests (DataView, Uint16Array, spoofed-length subclass, Int8Array/Uint8ClampedArray).
- **M2** (`hashline.js`): reapply refuses to relocate a narrow (2-char) anchor — a 16-bit anchor is required, since 8-bit relocation is a ~1/256-per-line coin flip onto a wrong line.
- **M3**: a range op's two endpoints must relocate by the same delta (subsumes inversion), so a one-sided/unequal relocation can't silently resize the consumed span.
- **M4**: blank-line anchors (hash equals the blank seed for their line) are never relocated.
- **M5**: validate `ops`/`payload` by explicit indexed loops over a once-captured length — closes the `map`-skips-holes sparse-array bypass and the `ops.length` TOCTOU.
- **M6**: strip a trailing CR per patch line so CRLF-authored text parses like LF; reject an embedded CR in the `hashline-json` payload validator.
- **M7** (`designs/cli-edit-verb.md`): dropped the "tentative"/deferral prose and documented the reapply relocation soundness constraints as landed.
- **M8**: added regression tests pinning `actions.sort` (range op after a higher-line single-line op) and `appendAll` (200k-line payload that would `RangeError` if spread).
- **M9** (`types.d.ts`/tests): renamed daemon `Sha256Hex` → `Sha256HexFn` to avoid colliding with `@endo/mem-cas`'s async `Sha256Hex`; dropped the unused import; renamed `prop`→`property` in the proxy tests.

Bundled should-fixes also applied: rewrote the crc32 README/JSDoc to the brand-checked two-path model, restored the pako upstream URL, and named the new public entry points in the changeset.

Verification: `crc32` (12) + `hashline` (56) tests pass; daemon `lint:types`, `test:types`, and eslint clean; prettier clean; `@endo/zip` tests (crc32 hot-path consumer) pass. Pushed via `safe-push-pr-head.sh` (advance mode). CI watched to terminal: **all 27 checks pass**, PR mergeable.

Note: the session was torn down twice by reaper requeues while awaiting CI; the fix was already committed/pushed each time, so resumption was idempotent — no duplicate commits. No follow-ups; the driver re-posts the panel-3 stage next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr796-gauntlet-resume-20260822-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 1 host(s)
- Input: 165 tokens (15291189 cached reads)
- Output: 90708 tokens
- Cost: $12.1374785
- Wall-clock: 1993s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
