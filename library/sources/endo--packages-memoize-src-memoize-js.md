---
title: "@endo/memoize src/memoize.js — WeakMap-backed memoization primitive with encapsulatedPumpkin recursion sentinel"
source-slug: endo--packages-memoize-src-memoize-js
url: https://github.com/endojs/endo/blob/master/packages/memoize/src/memoize.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/memoize/src/memoize.js
total-lines: 54
ingest-cycle: 312
ingest-date: 2026-06-11
lane: chat
---

# `@endo/memoize src/memoize.js`

A 54-line module — the canonical memoization primitive for `@endo`. WeakMap-backed memoization with the named **encapsulatedPumpkin** recursion sentinel. **Third consecutive non-garden source** after cycle 310's @endo/nat src + cycle 311's @endo/nat README. §the-named-three-cycle-stay-after-pivot (310 + 311 + 312). §the-named-small-focused-foundation-package-shape extends.

## Key moves

- **§the-named-memoize-IS-the-named-canonical-memoization-primitive** — single-arg function memoization; hardened on export; §the-named-foundation-utility-shape.
- **§the-named-WeakMap-IS-named-for-WeakKey-arguments** — WeakMap (not Map) allows GC of memo entries; §the-named-GC-friendly-memoization; §the-named-WeakKey-constraint-IS-named-by-template (`@template {WeakKey} A`).
- **§the-named-arity-restriction** — single-arg only; §the-named-no-multi-arg-support-IS-named-deliberate.
- **§the-named-encapsulatedPumpkin-IS-named-recursion-sentinel** — hardened empty object as module-private sentinel; §the-named-must-not-escape-this-module (named-module-private-invariant); §the-named-pumpkin-IS-named-Cinderella-reference (narrative naming as mnemonic); §the-named-single-sentinel-instance-per-module; §the-named-identity-equality-IS-named-detection-mechanism (`=== encapsulatedPumpkin`).
- **§the-named-three-phase-memoize-pattern** — check + sentinel-set + replace-or-cleanup; §the-named-sentinel-set-IS-named-in-flight-marker; §the-named-replace-or-clean-up-discipline; §the-named-recursion-detection-via-sentinel; §the-named-anti-infinite-recursion-via-named-sentinel; §the-named-explicit-error-message-naming-the-discipline.
- **§the-named-exception-cleanup-discipline** — if fn throws, `memo.delete(arg)` before rethrow; §the-named-failed-calls-do-not-stick; §the-named-rethrow-after-cleanup-discipline.
- **§the-named-dual-purpose-sentinel-set** — `memo.set` serves both recursion-protection AND fail-fast-on-invalid-arg (WeakMap.set throws on non-WeakKey); §the-named-multi-purpose-statement-discipline; §the-named-early-error-IS-named-better-than-late-error.
- **§the-named-explicit-TS-limitation-comment** — comment names two things TS can't infer (no interleaving between has and get; has=true branch implies get succeeds); §two-named-TS-limitations; §the-named-cite-the-tool-limitation-discipline.
- **§the-named-typo-interleavs** — preserved typo "interleavs" (missing final e); §four-cycles-with-named-preserved-typo-IS-named-evidence (263 + 280 + 295 + 312); §the-named-typo-IS-named-evidence-of-organic-prose.
- **§the-named-TS-cast-via-JSDoc-type-assertion** — `/** @type {R} */ (memo.get(arg))`; §the-named-JSDoc-cast-syntax; §the-named-type-assertion-IS-named-explicit-when-TS-cant-infer.
- **§three-named-harden-call-sites** — sentinel + inner-returned-fn + module-level-export; §the-named-defensive-harden-on-every-exposed-value; §two-named-harden-shapes-across-cycles (310 freeze-stand-in for Apps Script + 312 import-directly); §the-named-canonical-shape-vs-workaround-shape-distinction.
- **§the-named-TODO-with-named-future-resolution** — "(TODO turn into link once there's a URL)"; §the-named-deferred-link-discipline; §the-named-TODO-with-named-resolution-condition; §the-named-explicit-incompleteness-marker; §the-named-cross-document-reference-pattern (source → memoize.md README).
- **§the-named-early-return-no-else-discipline** — `if-return` without else; §the-named-implicit-else-via-early-return.
- **§the-named-cycle-312-IS-the-third-non-garden-pivot-cycle** — §three-cycles-with-named-pivot-domain-stay (310 + 311 + 312); §the-named-pivot-IS-named-productive-three-cycles-in.

## Section files

- [§the-named-memoize-canonical-primitive + §the-named-encapsulatedPumpkin-recursion-sentinel + §three-phase-memoize-pattern + §the-named-explicit-TS-limitation-comment + §the-named-pumpkin-IS-named-Cinderella-reference + 18+ more first-explicit-observations](../sections/endo--packages-memoize-src-memoize-js--memoization-primitive-with-named-encapsulatedPumpkin-recursion-sentinel.md) — full 54-line module in scope.

## Ingest scope

Cycle 312 (chat-lane after cycle 311's designs-lane @endo/nat README.md). Full 54-line module in scope. Third consecutive @endo/* source. **First-explicit-observations (twenty-plus)** at full scope, including: §the-named-encapsulatedPumpkin-IS-named-recursion-sentinel with §the-named-pumpkin-IS-named-Cinderella-reference (narrative naming as mnemonic), §the-named-three-phase-memoize-pattern (check + sentinel-set + replace-or-cleanup), §the-named-dual-purpose-sentinel-set (recursion-protection AND fail-fast-on-invalid-arg in one statement), §the-named-explicit-TS-limitation-comment naming two named TS flow-analysis gaps, §the-named-typo-interleavs (preserved typo extending the §four-cycles-with-named-preserved-typo-IS-named-evidence pattern: 263 + 280 + 295 + 312), §three-named-harden-call-sites with §two-named-harden-shapes-across-cycles (310 freeze-stand-in + 312 import-directly), §the-named-TODO-with-named-future-resolution, §the-named-cycle-312-IS-the-third-non-garden-pivot-cycle.
