---
ts: 2026-06-19T04:52:00Z
kind: result
role: shepherd
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/19/044500Z-dispatch-liaison-f652ec.md
---

Shepherd fix for PR #473 TS2769 lint failure in `packages/immutable-arraybuffer/src/lib.js`.

**Problem:** `virtualTypedArrayBufferGetter` was typed as `(() => any) | undefined`
because `PropertyDescriptor.get` is always optional (a descriptor may be a data
descriptor, not an accessor). The prior fix cast `getOwnPropertyDescriptor(taGetters,
'buffer')` to `PropertyDescriptor`, removing the outer `undefined`, but did not address
the optionality of the inner `get` field. TypeScript TS2769 fired at
`apply(virtualTypedArrayBufferGetter, this, [])` on line 788.

**Fix (commit `4d52757ba`):** Replaced the `/** @type {PropertyDescriptor} */` cast
with `// @ts-expect-error TS doesn't know it'll be there`, consistent with the same
pattern used for `typedArrayBufferGetter` at line 80 and `arrayBufferByteLength` at
line 48 of the same file.

`yarn lint:types` on `packages/immutable-arraybuffer` passes cleanly.
Pre-push gates: all probes pass; `chacha12-fast-check-test` exports probe failure
is pre-existing and unrelated to this change.

Pushed to `feat/pass-style-byte-array-plain-frozen-validation`.
Top-level summary posted to PR #473 @-mentioning @erights.

Self-improvement: nothing this time.
