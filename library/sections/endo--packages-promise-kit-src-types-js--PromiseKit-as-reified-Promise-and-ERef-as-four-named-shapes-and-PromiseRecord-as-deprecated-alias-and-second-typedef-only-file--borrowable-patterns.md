---
title: §Borrowable patterns
source-slug: endo--packages-promise-kit-src-types-js
source-url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/types.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/promise-kit/src/types.js
total-lines: 25
ingest-cycle: 256
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-promise-kit-src-types-js--PromiseKit-as-reified-Promise-and-ERef-as-four-named-shapes-and-PromiseRecord-as-deprecated-alias-and-second-typedef-only-file
---

**Tier-1 (highest borrowing value):**

- §`export {};` typedef-only file pattern (second instance: 249 + 256).
- §PromiseKit as reified Promise — three properties (resolve + reject + promise) make the Promise constructor's implicit state explicit.
- §resolve takes ERef not T — the resolver accepts any of the four ERef shapes; the Promise resolution protocol folds them.
- §ERef as four named shapes — local T + local presence for remote T + promise for T + thenable for T.
- §Four-named-shapes distinguished in prose, not in type narrower than `T | PromiseLike<T>`.
- §Thenable defined explicitly as *promise-like non-promise with a "then" method*.
- §Deprecated typedef alias with named replacement in JSDoc — pure type-erased rename discipline.
- §Stack of three typedefs in one file — general-input + canonical + deprecated-alias.

**Tier-2 (file-shape patterns):**

- §Twenty-five-lines-as-a-complete-Promise-and-ERef-type-vocabulary.
- §`@template T` parameterization on all three typedefs.
- §Three-typedefs-share-a-template-parameter.
- §The-file-IS-the-protocol-contract-not-the-implementation.

**Tier-3 (named comparisons):**

- §Two-cycles-with-`export {};`-typedef-only-file-pattern (249 + 256).
- §Two-cycles-with-explicit-treatment-of-the-thenable-vs-Promise-distinction (252 detection + 256 definition).
- §Two-cycles-with-named-defense-and-named-definition-of-thenable-vs-Promise (252 + 256).
- §Two-cycles-with-multiple-typedefs-in-one-file (249 + 256).
- §Two-cycles-with-named-deprecation-with-named-replacement (251 MCP + 256 PromiseRecord).
- §Three-cycles-with-`@template`-parameterization (237 + 249 + 256).
