---
title: §"a promise-like non-promise with a 'then' method" — named thenable definition
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

§The-ERef-typedef's-prose explicitly defines a thenable as *a promise-like non-promise with a "then" method*. §The-definition-IS-the-distinguishing-property: §thenable-has-`.then` + §thenable-is-not-a-Promise. §First-explicit-observation in library of §thenable-defined-explicitly-as-promise-like-non-promise-with-then-method.

§Sibling-pattern-to-cycle-252's-isPromise — §two-cycles-with-explicit-treatment-of-the-thenable-vs-Promise-distinction. §Cycle-252 detects the difference; §cycle-256 defines the difference in the type prose.

§Two-cycles-with-named-defense-and-named-definition-of-thenable-vs-Promise (252 detection + 256 definition).
