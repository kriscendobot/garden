---
title: "§`resolve: (value: ERef<T>) => void` — resolver accepts any ERef"
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

§The-resolver-takes-`ERef<T>`-not-`T`. §This-IS-load-bearing: §a-PromiseKit's-resolve-can-be-called-with-a-bare-T + §or-with-a-Promise-of-T + §or-with-a-PromiseLike-of-T (thenable). §The-Promise-resolution-protocol-folds-any-of-these-shapes-into-the-final-resolved-value.

§First-explicit-observation in library of §resolve-takes-ERef-not-T-as-the-canonical-PromiseKit-resolver-shape. §When-a-resolver-must-accept-any-of-the-Promise-shapes, §the-resolver's-parameter-type-IS-ERef<T>-not-T.

§Sibling-pattern-to-cycle-252's-isPromise — §two-cycles-with-explicit-distinction-between-T-and-Promise-of-T-and-thenable-of-T. §Cycle-252's-isPromise-detects-genuine-Promise-vs-thenable; §cycle-256's-ERef-accepts-all-three-shapes-as-input-to-the-resolver.
