---
title: Key moves
section-slug: endo--packages-hex-src-encode-js--polyfill-and-native-dispatch-pair-and-pre-lockdown-capture
source-slug: endo--packages-hex-src-encode-js
url: https://github.com/endojs/endo/blob/master/packages/hex/src/encode.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/hex/src/encode.js
total-lines: 60
ingest-cycle: 314
ingest-date: 2026-06-11
lane: chat
scope: full
parent: endo--packages-hex-src-encode-js--polyfill-and-native-dispatch-pair-and-pre-lockdown-capture
---

- **§the-named-polyfill-and-dispatcher-pair-shape** (first-explicit-observation):

```javascript
export const jsEncodeHex = bytes => { ... };   // pure-JS polyfill
harden(jsEncodeHex);

const toHex = /** @type {any} */ (Uint8Array.prototype).toHex;
const nativeToHex = typeof toHex === 'function' ? toHex : undefined;

export const encodeHex =
  nativeToHex !== undefined
    ? bytes => apply(nativeToHex, bytes, [])
    : jsEncodeHex;
harden(encodeHex);
```

**§the-named-polyfill-and-dispatcher-pair-shape**: a pure-JS implementation (`jsEncodeHex`) IS exported alongside a dispatcher (`encodeHex`) that picks native-intrinsic-or-polyfill at module load. **§the-named-two-named-exports-from-one-module**: the polyfill + the dispatcher.

§the-named-exported-for-benchmarking: "Pure-JavaScript hex encoder, exported for benchmarking and for environments where the native TC39 ... intrinsic ... IS unavailable or has been removed." **§the-named-export-IS-named-for-named-reason**: the JS variant IS exported NOT because users typically need it, but for named benchmarking and named-unavailable-intrinsic environments.

§the-named-fallthrough-default-via-conditional-export: `encodeHex` IS bound to either the native-wrapper or the polyfill at module load. **§the-named-conditional-export-IS-named-load-time-choice**.

- **§the-named-Reflect.apply-captured-at-module-load** (first-explicit-observation):

```javascript
const { apply } = Reflect;
```

with comment:

> Capture `Reflect.apply` once at module load; we prefer it to `Function.prototype.call` even where `.call` IS assumed to be primordial, so a tampered `Function.prototype.call` cannot redirect the dispatched native intrinsic invocation.

**§the-named-Reflect.apply-preferred-over-Function.prototype.call**: explicit named-tamper-resistance-discipline. **§the-named-tamper-resistance-via-Reflect.apply**.

§two-cycles-with-named-defensive-binding-via-destructuring (310 + 314): cycle 310 had `const { freeze } = Object;`; cycle 314 has `const { apply } = Reflect;`. Both capture intrinsics at module-load-time before SES lockdown. **§the-named-destructure-from-intrinsic-IS-named-pre-lockdown-capture**.

§the-named-even-where-call-IS-assumed-primordial: the comment acknowledges that `.call` IS *normally* assumed safe but a tampered `.call` IS still a risk vector. **§the-named-belt-and-suspenders-discipline**. **§the-named-defense-in-depth-IS-named-explicit**.

- **§the-named-pre-lockdown-binding-capture** (first-explicit-observation):

```javascript
const toHex = /** @type {any} */ (Uint8Array.prototype).toHex;
const nativeToHex =
  typeof toHex === 'function' ? toHex : undefined;
```

with comment:

> Capture the native TC39 `Uint8Array.prototype.toHex` intrinsic at module load, before any caller can reach `encodeHex` and before SES lockdown freezes the prototype. Post-lockdown mutation cannot redirect the dispatched binding.

**§the-named-pre-lockdown-binding-capture**: capture-before-freeze ensures the binding IS stable. **§the-named-binding-IS-frozen-by-virtue-of-being-captured-before-the-mutation-window-closes**. **§three-cycles-with-named-Hardened-JS-discipline-extends** (310 + 312 + 313 + 314): cycle 314 names the *pre-lockdown-capture* shape explicitly.

§the-named-post-lockdown-mutation-cannot-redirect: the comment names the property. **§the-named-mutation-window-closes-discipline**. **§the-named-immutable-binding-via-pre-mutation-capture**.

§the-named-cast-to-any-to-access-non-spec-prop: `/** @type {any} */ (Uint8Array.prototype).toHex` — cast to any before accessing the non-standard prop (TypeScript doesn't know about `toHex` on `Uint8Array.prototype` in some compilation targets). **§the-named-TypeScript-cast-via-named-any-projection**. **§the-named-cast-to-any-for-not-yet-standardized-prop**.

§the-named-typeof-check-IS-named-tri-state-handling: `typeof toHex === 'function' ? toHex : undefined`. **§the-named-explicit-undefined-fallback**. **§the-named-feature-detection-via-typeof-function**.

- **§the-named-Stage-4-TC39-proposal-citation** (first-explicit-observation):

> Dispatches to the native `Uint8Array.prototype.toHex` intrinsic when available (stage-4 TC39 proposal-arraybuffer-base64).

**§the-named-cite-the-TC39-stage-and-proposal-name**. **§the-named-Stage-4-IS-named-explicit-maturity-marker**: stage-4 IS the named-final-stage in the TC39 process before merging into the spec. **§the-named-TC39-proposal-naming-IS-named-link-class**.

§three-named-link-classes-extends: cycle 310's spec-authoritative + cycle 310's esdiscuss-historical + cycle 311's tc39-notes-deliberation + cycle 314's TC39-proposal-name. **§four-named-link-classes-now** (spec + esdiscuss + tc39-notes + TC39-proposal).

- **§the-named-pre-allocate-for-linear-time-discipline** (first-explicit-observation):

```javascript
// Pre-allocate the output array to avoid quadratic-time string
// concatenation on large inputs.
const chars = new Array(bytes.length * 2);
for (let i = 0; i < bytes.length; i += 1) {
  const b = bytes[i];
  const j = i * 2;
  chars[j] = hexAlphabet[b >>> 4];
  chars[j + 1] = hexAlphabet[b & 0x0f];
}
return chars.join('');
```

**§the-named-quadratic-anti-pattern-named**: the comment explicitly names the anti-pattern (string concatenation builds a new string each iteration; pre-allocation + join avoids this). **§the-named-pre-allocate-array-then-join-discipline**.

§the-named-anti-pattern-named-by-its-asymptotic-cost: "quadratic-time" — the comment uses Big-O language. **§the-named-explicit-Big-O-in-comment**.

- **§the-named-bitwise-via-shift-and-mask-IS-named-canonical-byte-to-nibble** (first-explicit-observation):

```javascript
chars[j] = hexAlphabet[b >>> 4];     // high nibble
chars[j + 1] = hexAlphabet[b & 0x0f]; // low nibble
```

**§the-named-nibble-extraction-via-shift-and-mask**: `b >>> 4` (unsigned shift right; high nibble) + `b & 0x0f` (mask off high bits; low nibble). **§the-named-byte-IS-two-named-nibbles**.

§the-named-unsigned-shift-IS-named-explicit-for-clarity: `>>>` (zero-fill right shift) instead of `>>` (sign-propagating right shift). For unsigned byte values (0-255) both produce the same result, but `>>>` IS named-explicitly-unsigned. **§the-named-explicit-unsigned-shift-discipline**.

§the-named-hexAlphabet-IS-named-string-as-lookup-table: `const hexAlphabet = '0123456789abcdef';` — the 16-character string IS indexed by nibble value. **§the-named-string-indexing-IS-named-lookup-table-shape**. **§the-named-character-lookup-via-string-indexing**.

§the-named-eslint-disable-no-bitwise: `/* eslint no-bitwise: ["off"] */` — file-level eslint disable. **§the-named-deliberate-eslint-disable**. The bitwise operators are *intended* here, not accidental; the rule IS off because the code IS doing low-level encoding.

- **§the-named-lowercase-hex-default-with-caller-uppercase-discipline** (first-explicit-observation):

> Emits lowercase hex. Callers that need uppercase can call `.toUpperCase()` on the result.

**§the-named-output-format-IS-named-canonical-caller-transforms**. **§the-named-canonical-form-on-output-caller-discretion-on-format**. **§the-named-uppercase-IS-caller-responsibility-discipline**.

- **§the-named-encodeHex-typed-as-typeof-jsEncodeHex** (first-explicit-observation):

```javascript
/**
 * @type {typeof jsEncodeHex}
 */
export const encodeHex = ...;
```

**§the-named-typeof-IS-named-type-inheritance-via-JSDoc**: the dispatcher's type IS bound to the polyfill's type. The polyfill IS the canonical type-defining export; the dispatcher inherits the type. **§the-named-canonical-type-and-dispatcher-typed-from-it**.

§two-cycles-with-named-TS-cast-via-JSDoc-type-assertion-extends (312 + 314): cycle 312's `/** @type {R} */ (memo.get(arg))` + cycle 314's `/** @type {any} */ (Uint8Array.prototype).toHex` + `/** @type {typeof jsEncodeHex} */`. **§three-named-JSDoc-type-application-shapes**: cast-with-parens + type-comment + typeof-reference.

- **§the-named-multiple-harden-calls** (first-explicit-observation):

```javascript
harden(jsEncodeHex);
harden(encodeHex);
```

**§two-named-harden-calls-on-exports**: the polyfill + the dispatcher. **§the-named-export-and-harden-per-export-discipline**.

§the-named-harden-IS-named-imported-not-stand-in: extends cycle 312's named-canonical-shape-vs-workaround-shape-distinction. Cycle 314 (@endo/hex) uses the canonical shape (import harden). **§the-named-canonical-shape-extends** (cycles 312 + 314 both use import-directly; cycle 310 IS the workaround).

§three-named-cycles-with-canonical-import-harden-shape (extends two-cycles-with): cycle 312 + cycle 313 (README confirms) + cycle 314. **§three-cycles-with-named-canonical-import-harden-shape**.

- **§the-named-five-cycle-stay-after-pivot** (first-explicit-observation):

§five-cycles-with-named-pivot-domain-stay: 310 + 311 + 312 + 313 + 314 all @endo/* sources. **§the-named-fifth-non-garden-cycle-in-the-pivot**.

§the-named-pivot-spans-two-packages: cycles 310-311 (@endo/nat) + cycles 312-313 (@endo/memoize) + cycle 314 (@endo/hex). **§three-named-packages-in-the-pivot-cluster**.

§the-named-package-rotation-discipline: the pivot doesn't stay in one package; it rotates after a source-and-README pair. **§the-named-rotate-after-pair-discipline**.
