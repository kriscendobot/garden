---
title: Key moves
section-slug: endo--packages-memoize-src-memoize-js--memoization-primitive-with-named-encapsulatedPumpkin-recursion-sentinel
source-slug: endo--packages-memoize-src-memoize-js
url: https://github.com/endojs/endo/blob/master/packages/memoize/src/memoize.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/memoize/src/memoize.js
total-lines: 54
ingest-cycle: 312
ingest-date: 2026-06-11
lane: chat
scope: full
parent: endo--packages-memoize-src-memoize-js--memoization-primitive-with-named-encapsulatedPumpkin-recursion-sentinel
---

- **§the-named-memoize-IS-the-named-canonical-memoization-primitive** (first-explicit-observation): a single-argument-function memoization utility, hardened on export. **§the-named-foundation-utility-shape** (matches cycle 310's named-foundation-utility-shape for @endo/nat). **§the-named-small-leaf-dependency-discipline-extends** (54 lines + harden import).

- **§the-named-WeakMap-IS-named-for-WeakKey-arguments** (first-explicit-observation):

```javascript
import harden from '@endo/harden';
...
export const memoize = fn => {
  /** @type {WeakMap<A, R>} */
  const memo = new WeakMap();
  ...
};
```

**§the-named-WeakMap-as-named-memoization-backing-store**: WeakMap (not Map) allows GC of memo entries when the key IS no longer referenced elsewhere. **§the-named-GC-friendly-memoization**.

§the-named-WeakKey-template-discipline: `@template {WeakKey} A` — the JSDoc template constrains `A` to be a `WeakKey` (a type that can be used as a WeakMap key). **§the-named-TypeScript-template-via-JSDoc**. **§the-named-WeakKey-constraint-IS-named-by-template**.

§the-named-arity-restriction: "Given a one-argument function `fn` ... returns `memoFn`". Only single-arg functions are supported. **§the-named-no-multi-arg-support-IS-named-deliberate** — multi-arg memoization would need an explicit argument-tuple-as-key wrapping; the primitive stays narrow.

- **§the-named-encapsulatedPumpkin-IS-named-recursion-sentinel** (first-explicit-observation):

```javascript
/**
 * Must not escape this module.
 */
const encapsulatedPumpkin = harden({});
```

**§the-named-encapsulatedPumpkin-IS-named-module-private-sentinel**. The empty hardened object IS used as the named-sentinel-value for detecting recursion-through-memoization on the same argument.

§the-named-pumpkin-IS-named-Cinderella-reference: in the Cinderella story, the carriage turns back into a pumpkin at midnight. The naming IS the named-narrative-mnemonic: if you see the pumpkin in the memo, something IS off — the value reverted to its placeholder state. **§the-named-narrative-naming-IS-named-mnemonic**. **§the-named-mythological-allusion-IS-named-cognitive-anchor**.

§the-named-must-not-escape-this-module: the JSDoc explicitly states the invariant. **§the-named-module-private-invariant**. **§the-named-explicit-encapsulation-discipline**: the JSDoc IS the named-invariant-marker.

§the-named-single-sentinel-instance-per-module: the same `encapsulatedPumpkin` IS used for all in-flight memoization keys. **§the-named-shared-sentinel-discipline**. **§the-named-identity-equality-IS-named-detection-mechanism** (`memoedResult === encapsulatedPumpkin`).

- **§the-named-three-phase-memoize-pattern** (first-explicit-observation):

| Phase | Action | Purpose |
|---|---|---|
| 1 | check `memo.has(arg)` | return cached or throw recursion error |
| 2 | `memo.set(arg, encapsulatedPumpkin)` | establish sentinel; in-flight marker |
| 3 | call `fn(arg)`; on success `memo.set(arg, result)`; on throw `memo.delete(arg)` | replace sentinel with real result OR clean up |

**§the-named-three-phase-memoize-pattern**. **§the-named-sentinel-set-IS-named-in-flight-marker**. **§the-named-replace-or-clean-up-discipline**.

§the-named-recursion-detection-via-sentinel: if a memoized function calls itself with the same arg before its outer call returns, the inner call sees the sentinel and throws. **§the-named-recursion-detection-discipline**. **§the-named-anti-infinite-recursion-via-named-sentinel**.

§the-named-recursion-error-message: `'no recursion through memoization with same arg'`. **§the-named-explicit-error-message-naming-the-discipline**.

§the-named-clear-recursion-protection-on-exception (Phase 3 exception branch):

```javascript
try {
  result = fn(arg);
} catch (e) {
  // if `fn` throws, clear the recursion protection on the way out.
  memo.delete(arg);
  throw e;
}
```

**§the-named-exception-cleanup-discipline**: clearing the sentinel on thrown exception allows future calls with the same `arg` to retry. **§the-named-failed-calls-do-not-stick**. **§the-named-rethrow-after-cleanup-discipline** (preserves the original error after cleanup).

- **§the-named-dual-purpose-sentinel-set** (first-explicit-observation):

```javascript
// This both prevents recursion through memoization,
// and errors early on a non-weak-key-compat arg, rather than calling `fn`.
memo.set(arg, /** @type {R} */ (encapsulatedPumpkin));
```

**§the-named-dual-purpose-sentinel-set**: the `memo.set` call serves two named purposes — (1) sentinel insertion for recursion-detection, (2) early failure on `arg` that can't be a WeakMap key. **§the-named-fail-fast-on-invalid-arg-discipline**: an invalid `arg` (e.g., a primitive number) triggers a TypeError from WeakMap.set BEFORE `fn(arg)` IS called. **§the-named-early-error-IS-named-better-than-late-error**.

§the-named-two-named-purposes-of-one-statement: the comment names the dual purpose. **§the-named-multi-purpose-statement-discipline**.

- **§the-named-explicit-TS-limitation-comment** (first-explicit-observation):

```javascript
if (memo.has(arg)) {
  // TS doesn't know both that nothing interleavs between the `has` and
  // the `get`, and that in the absence of interleaving, a `get` on this
  // branch of `has` must succeed.
  const memoedResult = /** @type {R} */ (memo.get(arg));
  ...
}
```

**§the-named-explicit-TS-limitation-comment**: the comment names two things TypeScript's flow analysis can't infer — (1) no interleaving between `has` and `get` (the JS event loop IS single-threaded; nothing runs between the two calls), (2) `get` on the `has === true` branch must succeed. **§the-named-two-named-TS-limitations**.

§the-named-typo-interleavs: "nothing interleavs between" (missing the final `e` in "interleaves"). **§the-named-typo-IS-named-evidence-of-organic-prose**. Same shape as cycle 263's named-preserved-typo-as-named-evidence-of-informal-or-incomplete-status. **§four-cycles-with-named-preserved-typo-IS-named-evidence** (263 + 280 + 295 + 312).

§the-named-TS-cast-via-JSDoc-type-assertion: `/** @type {R} */ (memo.get(arg))` — the TypeScript-via-JSDoc syntax for type assertion via parenthesized cast. **§the-named-JSDoc-cast-syntax**. **§the-named-type-assertion-IS-named-explicit-when-TS-cant-infer**.

- **§the-named-three-named-harden-call-sites** (first-explicit-observation):

```javascript
import harden from '@endo/harden';   // ← import
const encapsulatedPumpkin = harden({});  // ← call #1 (sentinel)
return harden(memoFn);                  // ← call #2 (inner returned fn)
harden(memoize);                         // ← call #3 (module-level export)
```

**§three-named-harden-call-sites**: the sentinel + the returned inner function + the module-level memoize itself. **§the-named-defensive-harden-on-every-exposed-value**.

§two-named-harden-shapes-across-cycles: cycle 310 (@endo/nat) used `const { freeze } = Object;` as a harden stand-in (under named-applicability-condition: unadorned arrow functions); cycle 312 (@endo/memoize) imports harden directly from @endo/harden. **§two-named-harden-shapes** (310 freeze-stand-in + 312 import-directly). **§the-named-different-packages-use-different-harden-shapes**.

§the-named-import-harden-IS-named-canonical-shape: @endo/memoize's direct import IS the canonical shape; @endo/nat's freeze-stand-in IS the workaround for downstream Apps Script compatibility (per cycle 310's named-conditional-applicability-discipline). **§the-named-canonical-shape-vs-workaround-shape-distinction**.

- **§the-named-TODO-with-named-future-resolution** (first-explicit-observation):

> See memoize.md for the Memoization Safety properties of `memoize`.
> (TODO turn into link once there's a URL)

**§the-named-deferred-link-discipline**: the comment names that the link IS deferred until the URL exists. **§the-named-TODO-with-named-resolution-condition**. **§the-named-explicit-incompleteness-marker**.

§the-named-cross-document-reference-pattern: the comment points at `memoize.md` (the README) for the named-Memoization-Safety-properties. **§the-named-source-points-at-companion-doc-for-properties**.

- **§the-named-early-return-discipline** (first-explicit-observation):

```javascript
const memoFn = arg => {
  if (memo.has(arg)) {
    ...
    return memoedResult;
  }
  // (no else branch)
  memo.set(arg, encapsulatedPumpkin);
  ...
};
```

**§the-named-early-return-no-else-discipline**: the `if (memo.has(arg))` block returns; no `else` follows. The post-`if` code IS the implicit "else" path. **§the-named-implicit-else-via-early-return**.

- **§the-named-cycle-312-IS-the-third-non-garden-pivot-cycle** (first-explicit-observation):

§the-named-three-cycle-stay-after-pivot: cycles 310 + 311 + 312 all source from @endo/* packages. **§three-cycles-with-named-pivot-domain-stay** (310 nat src + 311 nat README + 312 memoize src).

§the-named-pattern-surface-remains-fresh: each cycle in the pivot picks a distinct fresh source; the patterns enumerated are not redundant with the garden cluster's saturated patterns. **§the-named-pivot-IS-named-productive-three-cycles-in**.
