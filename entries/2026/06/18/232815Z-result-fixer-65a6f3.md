---
ts: 2026-06-18T23:28:00Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - pr: 468
  - comments: [3439437779, 3439444181]
---

Applied both erights JSDoc suggestions on `packages/immutable-arraybuffer/src/lib.js`:

1. `hiddenTypedArrays` WeakMap: changed `@type {WeakMap<object, any>}` to `@type {WeakMap<TypedArray, TypedArray>}`.
2. `amplifyTypedArray`: changed `@param {object}` / `@returns {object}` to `@param {TypedArray}` / `@returns {TypedArray}`.

`yarn lint:types` (tsc) passed with no errors for both changes. Committed as `197b32104` and pushed to `feat/freezable-typedarray-emulation`. Replied on both inline threads citing the SHA.

Self-improvement: nothing this time.
