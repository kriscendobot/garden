---
ts: 2026-06-17T00:00:00Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/17/000000Z-dispatch-liaison-21ea98.md
---

Fixer dispatch for PR #468 (feat/freezable-typedarray-emulation).
Addressing barrister b4afa3 verdict: 2 must-fix-loop items + 2 summary-fix items.
All four items addressed in commit f7715659e on feat/freezable-typedarray-emulation.

Must-fix #1 (Symbol.iterator divergence): Two coordinated changes in src/lib.js
and src/shim.js. Added `[Symbol.iterator]` entry to `freezableTypedArrayLibProperties`
(same body as `values`). Switched the shim's descriptor-reopen loop from
`Object.entries` to `Reflect.ownKeys` so symbol-keyed properties are included.
`Object.entries` silently skips symbol keys, so `[Symbol.iterator]` was never copied
to `typedArrayPrototype` even when present in the frozen lib record. Regression tests
added for `for...of` loops, spread syntax, and Symbol.iterator parity.

Must-fix #2 (subarray safety contract): Judgment call: wrapper approach (option a).
`subarray` now checks `hiddenTypedArrays` membership, delegates to the hidden genuine
TypedArray's `subarray`, wraps the result in `create(getPrototypeOf(this))`, and
registers the sub-wrapper in `hiddenTypedArrays`. The existing `reverseBuffers` entry
(genuine backing buffer to immutable wrapper) covers the sub-view without a second
entry. `sub.buffer === iab` now holds. Existing test updated to assert the new shape.

Summary-fix #1: Removed stale sentence from `test/_lib-setup.md` that claimed
free-function exports were still available via the deleted `index.js`.

Summary-fix #2: Corrected design-doc alias names `hiddenBuffers`/`reverseHiddenBuffers`
to actual variable names `buffers`/`reverseBuffers` in src/lib.js comment and
the corresponding mention in src/shim.js.

All 217 tests pass. Top-level PR comment posted at:
https://github.com/endojs/endo-but-for-bots/pull/468#issuecomment-4739977607

Pre-push gates: all probes pass; `no-pull-citations` probe exits with a `base:
unbound variable` shell error on the fallback code path (pre-existing bug in the
probe; not caused by our changes; no pull citations in our diff).

next: justice

Self-improvement: The root cause of the `Symbol.iterator` bug was that
`Object.entries` silently skips symbol keys when building the `configurableDescs`
map in the shim. A proposed rule from the barrister ("When a shim replaces a named
method that is aliased by a Symbol property on the same prototype, the shim must
also re-install the Symbol alias to point at the replacement") captures the
prevention strategy; worth encoding as a panel-hints entry for future TypedArray-shim
PRs.
