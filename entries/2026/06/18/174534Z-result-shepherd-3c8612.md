---
ts: 2026-06-18T17:00:00Z
kind: result
role: shepherd
repo: endojs/endo-but-for-bots
project: endo
refs: []
---

## Shepherd result: PR #468 (feat/freezable-typedarray-emulation)

Responded to erights's CI inquiry at 17:33:35Z. Analyzed run 27749506323 (head 8541aaf8b).

### Classification (cycle 1, head 8541aaf8b)

| Class | Job | Signature | Disposition |
| --- | --- | --- | --- |
| C | lint | TS2322 (10x): `@param {Function}` vs `= undefined` default; TS2538: symbol index on `PropertyDescriptorMap` | fixed inline, commit 74e3651a7 |
| C | test (all 4 platforms) | `trap` tests: `MIN_TRANSFER_BUFFER_LENGTH NaN` in `captp/src/atomics.js` | fixed inline, commit b7f63cb8b |

### Root causes

**Lint (Class C, fixed):**
- `lib.js` TS2322: Ten methods in `freezableTypedArrayLibProperties` had `@param {Function} predicate` (required) in JSDoc but `predicate = undefined` (optional) in the implementation. Fix: bracketed the 10 JSDoc annotations to `[predicate]`/`[callback]`.
- `shim.js` TS2538: `Reflect.ownKeys` returns `(string | symbol)[]` but `PropertyDescriptorMap` index only accepts `string`. Fix: cast `key` to `string` at both index sites with inline JSDoc casts.

**Test failures (Class C, fixed):**
`ses/src/lockdown.js` imports `@endo/immutable-arraybuffer/shim.js`, so the shim runs for every package that imports `ses` (including all captp AVA configs via `@endo/init`). The shim replaces the eleven concrete global TypedArray constructors with `PseudoTypedArray` functions. These pseudo-constructors did not forward the `BYTES_PER_ELEMENT` own property. `captp/src/atomics.js` computes `MIN_TRANSFER_BUFFER_LENGTH = BigUint64Array.BYTES_PER_ELEMENT + Int32Array.BYTES_PER_ELEMENT` at module-evaluation time; after the shim, both are `undefined`, so the constant is `NaN`. Every `splitTransferBuffer` call then throws. Fix: forward `BYTES_PER_ELEMENT` from `OriginalConstructor` to `PseudoTypedArray` via `defineProperty` inside `makePseudoTypedArrayConstructor`.

### Commits pushed

- `b7f63cb8b`: fix(immutable-arraybuffer): copy BYTES_PER_ELEMENT onto PseudoTypedArray
- `74e3651a7`: fix(immutable-arraybuffer): correct JSDoc and TypeScript type errors

Both pushed to `feat/freezable-typedarray-emulation`. CI re-running.

### PR comment posted

https://github.com/endojs/endo-but-for-bots/pull/468#issuecomment-4744644607

### Termination

next: conductor (if CI goes green on new head); next: liaison (if further failures surface).

Self-improvement: shim replaces globals via ses/lockdown import chain — worth a field note in shepherd AGENT.md for future dispatches on this PR chain. The gotcha is that any static property on a TypedArray constructor (`BYTES_PER_ELEMENT`, `length`, etc.) must be explicitly forwarded by `makePseudoTypedArrayConstructor`; the prototype chain does not carry them.
