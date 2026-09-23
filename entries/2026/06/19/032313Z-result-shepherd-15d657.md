---
ts: 2026-06-19T03:45:00Z
kind: result
role: shepherd
repo: endojs/endo-but-for-bots
project: endo
refs:
  - pr: 473
---

Shepherd dispatch for PR #473 (`feat(pass-style): validate plain frozen Uint8Array on immutable buffer as byteArray`).

erights asked at 03:16:19Z: "@kriscendobot, what are these CI errors about?"

## CI state on entry

Run 27799396184: 6 failing checks (lint, cover, test x4 matrix).

## Diagnosis

### Cluster 1: lint -- TypeScript errors in `packages/immutable-arraybuffer/src/lib.js`

Two TypeScript errors, each appearing twice (lint tool runs the type-check once per tsconfig scope):

- `TS2353 packages/immutable-arraybuffer/src/lib.js:605`: `@type {(this: object) => ArrayBuffer}` JSDoc was placed on the `taGetters` object-literal declaration instead of inside the getter. TypeScript applied the function-type annotation to the object, making `buffer` an unknown property.
- `TS2339 packages/immutable-arraybuffer/src/lib.js:622`: `getOwnPropertyDescriptor` returns `PropertyDescriptor | undefined`; TypeScript rejected the `{ get }` destructure because of the `undefined` branch.

**Fix (commit `add275479`):** Moved the `@type` inside the getter method. Added a `PropertyDescriptor` cast on the `getOwnPropertyDescriptor` call.

### Cluster 2: test + cover -- wrong error message in pass-style under unsafe harden taming

Failing test: `byteArray rejects a Uint8Array backed by a mutable ArrayBuffer`
Config: `ava-endo-lockdown-unsafe.config.mjs` (`LOCKDOWN_HARDEN_TAMING=unsafe`)

Under unsafe taming `Object.isFrozen` returns `true` for unfrozen objects. A `new Uint8Array(new ArrayBuffer(4))` (mutable buffer, not hardened) bypassed the early `!isFrozen` gate in `passStyleOf` that normally throws "Cannot pass mutable typed arrays". `ByteArrayHelper.confirmCanBeValid` correctly returned `false` (buffer not immutable), so no helper claimed the value. The code fell through to `assertValid(remotableHelper, ...)`, which threw "cannot serialize Remotables with non-methods like '0' in '[Uint8Array]'" -- a confusing message that did not match the test's `/Cannot pass mutable typed arrays/` expectation.

**Fix (commit `4d30cc82c`):** Added `isTypedArray(inner) && assert.fail(X\`Cannot pass mutable typed arrays like ${inner}.\`)` immediately before the remotable fallthrough in `passStyleOf`. This closes the gap the unsafe-taming mode opens and produces the canonical error message in all configurations.

## Actions taken

- Committed and pushed two fix commits to `feat/pass-style-byte-array-plain-frozen-validation` (head now `4d30cc82c`).
- Posted a top-level comment on PR #473 at-mentioning @erights with the above analysis.

## Classification

CI is re-running on the new head. If it converges green, no further escalation needed.

next: none (pending CI convergence on new head; if green, re-request review or dispatch conductor per gamut).
