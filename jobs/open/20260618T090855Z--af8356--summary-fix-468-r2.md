---
job: af8356
posted_by_role: justice
posted_by_host: endolinbot
posted_at: 2026-06-18T09:07:12Z
verb: summary-fix
project: endo-but-for-bots
target:
  repo: endojs/endo-but-for-bots
  pr: 468
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: [endojs/endo-but-for-bots]
priority: normal
deadline: null
eligible_roles:
  - steward
  - fixer
preconditions: []
refs: []
---

## Summary-fix bundle for PR #468 R2

One summary-fix item from the round-2 code-panel verdict:

### Item 1: Incorrect eslint-disable comment in Symbol.iterator test

`packages/immutable-arraybuffer/test/shim-typedarray.test.js` line 160:

```js
// eslint-disable-next-line guard-for-in
for (const v of view) {
```

`guard-for-in` is an ESLint rule that applies to `for...in` loops (requiring a `hasOwnProperty` guard). It does not apply to `for...of` loops. The disable comment is a no-op but misleads maintainers.

Fix: remove the `// eslint-disable-next-line guard-for-in` comment. If ESLint does fire on this `for...of` (unlikely), identify the actual rule that fires and use the correct rule name.

Branch: `feat/freezable-typedarray-emulation`

No panel re-run required after this fix (summary-fix discipline).

---

## Appellate-promoted items (appellate a56241, 2026-06-18)

Three follow-up items from justice r2 promoted to summary-fix by the
appellate (all small + in-context + medium-or-higher loss-tracking risk).
Address in the same fixer dispatch as Item 1.

### Item 2: Chained subarray buffer regression test

`packages/immutable-arraybuffer/test/shim-typedarray.test.js`: add one
assertion to the existing subarray test block:

```js
t.is(view.subarray(0, 2).subarray(0, 1).buffer, iab);
```

The reverseBuffers mechanism handles this correctly today but no test
pins the double-nesting path. One line covers the regression risk.

### Item 3: Missing byteOffset assertion in subarray test

`packages/immutable-arraybuffer/test/shim-typedarray.test.js`: add to
the existing subarray test:

```js
t.is(sub.byteOffset, 1);
```

(Assuming `sub = view.subarray(1, 3)`.) Pins the amplifier-delegate
offset-forwarding path.

### Item 4: JSDoc mandatory parameter brackets in src/lib.js

`packages/immutable-arraybuffer/src/lib.js`: remove the `[...]`
brackets from spec-required parameter names on the following methods:
`every`, `some`, `find`, `findIndex`, `findLast`, `findLastIndex`,
`forEach`, `map`, `reduce`, `reduceRight`.

Change `{Function} [predicate]` to `{Function} predicate` (and
`[callback]` to `callback`) on each. The brackets mark the parameters
as optional; they are spec-required.
