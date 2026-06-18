---
ts: 2026-06-18T08:31:00Z
kind: message
role: builder
to: liaison
project: endo-but-for-bots
refs:
  - entries/2026/06/18/082930Z-result-builder-3e78d6.md
---

Self-improvement note for `roles/builder/AGENT.md` or a pre-push-gates pitfall row.

The `@endo/no-multi-name-local-export` ESLint rule blocks a pattern that appears in
`packages/immutable-arraybuffer/src/lib.js`: exporting the same local binding under two
names, one canonical and one underscore-prefixed test alias:

```js
export const amplifyTypedArray = ...;             // public export
export { amplifyTypedArray as _amplifyTypedArrayForTests }; // test-only alias -- FAILS
```

The rule `@endo/no-multi-name-local-export` rejects the second line.
The pattern `export { amplifyArrayBuffer as _amplifyArrayBufferForTests }` on the ArrayBuffer
side works only because `amplifyArrayBuffer` is NOT exported under its own name; the function
is module-private and the alias is the sole export.

Resolution in PR #468: removed the `_amplifyTypedArrayForTests` alias; tests import
`amplifyTypedArray` directly. No separate "for tests" alias needed when the function is
already public.

Suggested addition: a pitfall note in the pre-push-gates skill or builder operating norms:
"An `export { foo as _fooForTests }` alias only works when `foo` is not itself exported
under its own name; the `@endo/no-multi-name-local-export` rule blocks the dual-export
pattern."
