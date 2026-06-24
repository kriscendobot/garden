---
title: "@endo/hex src/encode.js — hex encoder with native-and-polyfill dispatch pair and pre-lockdown intrinsic capture"
source-slug: endo--packages-hex-src-encode-js
url: https://github.com/endojs/endo/blob/master/packages/hex/src/encode.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/hex/src/encode.js
total-lines: 60
ingest-cycle: 314
ingest-date: 2026-06-11
lane: chat
---

# `@endo/hex src/encode.js`

A 60-line module — hex encoder with native-TC39-intrinsic dispatch and pure-JS polyfill fallback. **Fifth consecutive non-garden source after the pivot** (cycles 310 + 311 + 312 + 313 + 314). §five-cycles-with-named-pivot-domain-stay. **§the-named-rotate-after-pair-discipline**: cycles 310-311 (nat pair) → 312-313 (memoize pair) → 314 (hex, fresh package).

## Key moves

- **§the-named-polyfill-and-dispatcher-pair-shape** — `jsEncodeHex` pure-JS polyfill + `encodeHex` dispatcher (native-or-polyfill at module load); §the-named-two-named-exports-from-one-module; §the-named-conditional-export-IS-named-load-time-choice; §the-named-exported-for-benchmarking; §the-named-export-IS-named-for-named-reason.
- **§the-named-Reflect.apply-captured-at-module-load** — `const { apply } = Reflect;`; §the-named-Reflect.apply-preferred-over-Function.prototype.call (tamper-resistance); §the-named-tamper-resistance-via-Reflect.apply; §the-named-even-where-call-IS-assumed-primordial; §the-named-belt-and-suspenders-discipline; §the-named-defense-in-depth-IS-named-explicit; §two-cycles-with-named-defensive-binding-via-destructuring (310 `const { freeze } = Object;` + 314 `const { apply } = Reflect;`); §the-named-destructure-from-intrinsic-IS-named-pre-lockdown-capture.
- **§the-named-pre-lockdown-binding-capture** — capture native intrinsic before SES freezes the prototype; §the-named-binding-IS-frozen-by-virtue-of-being-captured-before-the-mutation-window-closes; §the-named-post-lockdown-mutation-cannot-redirect; §the-named-mutation-window-closes-discipline; §the-named-immutable-binding-via-pre-mutation-capture.
- **§the-named-cast-to-any-to-access-non-spec-prop** — `/** @type {any} */ (Uint8Array.prototype).toHex`; §the-named-TypeScript-cast-via-named-any-projection; §the-named-cast-to-any-for-not-yet-standardized-prop; §the-named-typeof-check-IS-named-tri-state-handling; §the-named-explicit-undefined-fallback; §the-named-feature-detection-via-typeof-function.
- **§the-named-Stage-4-TC39-proposal-citation** — proposal-arraybuffer-base64 stage-4; §the-named-cite-the-TC39-stage-and-proposal-name; §the-named-Stage-4-IS-named-explicit-maturity-marker; §the-named-TC39-proposal-naming-IS-named-link-class; §four-named-link-classes-now (spec 310 + esdiscuss 310 + tc39-notes 311 + TC39-proposal 314).
- **§the-named-pre-allocate-for-linear-time-discipline** — `const chars = new Array(bytes.length * 2);` then `chars.join('')`; §the-named-quadratic-anti-pattern-named; §the-named-pre-allocate-array-then-join-discipline; §the-named-explicit-Big-O-in-comment.
- **§the-named-bitwise-via-shift-and-mask-IS-named-canonical-byte-to-nibble** — `b >>> 4` (high nibble) + `b & 0x0f` (low nibble); §the-named-nibble-extraction-via-shift-and-mask; §the-named-byte-IS-two-named-nibbles; §the-named-unsigned-shift-IS-named-explicit-for-clarity; §the-named-explicit-unsigned-shift-discipline; §the-named-hexAlphabet-IS-named-string-as-lookup-table; §the-named-string-indexing-IS-named-lookup-table-shape; §the-named-character-lookup-via-string-indexing.
- **§the-named-eslint-disable-no-bitwise** (file-level) — §the-named-deliberate-eslint-disable.
- **§the-named-lowercase-hex-default-with-caller-uppercase-discipline** — §the-named-output-format-IS-named-canonical-caller-transforms; §the-named-canonical-form-on-output-caller-discretion-on-format; §the-named-uppercase-IS-caller-responsibility-discipline.
- **§the-named-encodeHex-typed-as-typeof-jsEncodeHex** — `@type {typeof jsEncodeHex}`; §the-named-typeof-IS-named-type-inheritance-via-JSDoc; §the-named-canonical-type-and-dispatcher-typed-from-it; §three-named-JSDoc-type-application-shapes (cast-with-parens + type-comment + typeof-reference).
- **§two-named-harden-calls-on-exports** — `harden(jsEncodeHex)` + `harden(encodeHex)`; §the-named-export-and-harden-per-export-discipline; §three-cycles-with-named-canonical-import-harden-shape (312 + 313 + 314); §the-named-canonical-shape-extends.
- **§the-named-five-cycle-stay-after-pivot** — §five-cycles-with-named-pivot-domain-stay; §three-named-packages-in-the-pivot-cluster (@endo/nat + @endo/memoize + @endo/hex); §the-named-rotate-after-pair-discipline; §the-named-package-rotation-discipline.

## Section files

- [§the-named-polyfill-and-dispatcher-pair-shape + §the-named-Reflect.apply-captured-at-module-load + §the-named-pre-lockdown-binding-capture + §the-named-Stage-4-TC39-proposal-citation + §the-named-pre-allocate-for-linear-time-discipline + 15+ more first-explicit-observations](../sections/endo--packages-hex-src-encode-js--polyfill-and-native-dispatch-pair-and-pre-lockdown-capture.md) — full 60-line module in scope.

## Ingest scope

Cycle 314 (chat-lane after cycle 313's designs-lane @endo/memoize README). Full 60-line module in scope. Fifth consecutive @endo/* source. **First-explicit-observations (twenty-plus)** at full scope, including: §the-named-polyfill-and-dispatcher-pair-shape, §the-named-Reflect.apply-captured-at-module-load with §the-named-tamper-resistance-discipline, §the-named-pre-lockdown-binding-capture (capture native intrinsic before SES freezes the prototype), §the-named-Stage-4-TC39-proposal-citation, §the-named-pre-allocate-for-linear-time-discipline with §the-named-quadratic-anti-pattern-named, §the-named-bitwise-via-shift-and-mask-IS-named-canonical-byte-to-nibble, §the-named-eslint-disable-no-bitwise (deliberate), §the-named-lowercase-hex-default-with-caller-uppercase-discipline, §two-named-harden-calls-on-exports, §five-cycles-with-named-pivot-domain-stay (310 + 311 + 312 + 313 + 314), §the-named-rotate-after-pair-discipline (pair → pair → fresh package).
