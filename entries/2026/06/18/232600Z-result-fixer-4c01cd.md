---
ts: 2026-06-18T23:26:00Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
---

Addressed erights inline comment 3439428642 on PR #468
(`feat/freezable-typedarray-emulation`).

Removed `export` from `amplifyTypedArray` and `virtualTypedArrayBufferGetter` in
`packages/immutable-arraybuffer/src/lib.js`. `hiddenTypedArrays` was already
module-internal (no `export` keyword). Updated the section comment block to
describe all three as module-internal.

Rewrote `test/lib-typedarray.test.js` to remove imports of the now-internal
names; tests now observe the same behaviors through the shim-installed surface
(`view.buffer`, `view.byteLength`, `view.at`). All 217 tests pass.

Commit: b50d12124. Pushed to `origin/feat/freezable-typedarray-emulation`.
Replied on comment thread 3439428642 citing the SHA.

Self-improvement: nothing this time.
