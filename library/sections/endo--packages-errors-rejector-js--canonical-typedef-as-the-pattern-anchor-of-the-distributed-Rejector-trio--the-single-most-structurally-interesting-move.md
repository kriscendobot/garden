---
title: The single most structurally interesting move
source: endo--packages-errors-rejector-js
url: https://github.com/endojs/endo/blob/master/packages/errors/rejector.js
authors: [Mark S. Miller, Endo project (collective)]
repo: endojs/endo
path: packages/errors/rejector.js
total-lines: 23
ingest-cycle: 340
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-canonical-typedef-as-the-pattern-anchor
  - the-named-canonical-source-of-a-distributed-pattern
  - the-named-types-only-file
  - the-named-Rejector-as-typedef
  - the-named-Rejector-IS-false-OR-Fail
  - the-named-cond-OR-reject-AND-reject-template-literal
  - the-named-three-step-evaluation-shown-in-JSDoc
  - the-named-binary-choice-silent-vs-throwing
  - the-named-references-test-as-illustration
  - the-named-test-file-as-canonical-examples
  - the-named-import-for-typedef-only-with-named-lint-disable
  - the-named-twenty-three-line-types-only-file
  - the-named-streak-resumes-with-tenth-instance
  - the-named-pattern-citation-network-anchored-at-canonical-source
  - the-named-fifteenth-package-source-in-the-pivot
  - thirty-one-cycles-with-named-pivot-domain-stay
  - seventy-five-citation-arc-closures-in-pivot-now
parent: endo--packages-errors-rejector-js--canonical-typedef-as-the-pattern-anchor-of-the-distributed-Rejector-trio
---

**§the-named-canonical-typedef-as-the-pattern-anchor** — the entire file is:

```js
// eslint-disable-next-line no-unused-vars
import { Fail } from './index.js';

/**
 * Either
 * - `false`
 * - or an object like `Fail`
 *
 * A `Rejector` should be used as
 * ```js
 * cond || reject && reject`...`
 * ```
 * If `cond` is truthy, that is the value of the expression.
 * Else if `reject` is false, it is the value
 * Otherwise, invoke `reject` just like you would invoke `Fail`, with the
 * same template arguments. This throws the same kind of Error object that
 * `Fail` would throw, typically because it is the `Fail` template literal
 * tag itself.
 *
 * See rejector.test.js for illustrative examples.
 *
 * @typedef {false | typeof Fail} Rejector
 */
```

**§the-named-canonical-typedef-as-the-pattern-anchor** — first-explicit-observation as a tier-3 meta-pattern. The file IS the pattern: ONE import + ONE typedef + ONE worked-idiom (in JSDoc) + ONE pointer to test file. **Zero runtime exports**; pure type-level + pure documentation.

**§the-named-canonical-source-of-a-distributed-pattern** — first-explicit-observation as a tier-3 meta-pattern. The *Rejector* trio pattern has been observed in:
- Cycle 102 patterns/checkKey.js (the first explicit observation; **238 cycles ago**)
- Cycle 134 remotable.js Confirm trio
- Cycle 138 (uses Fail)
- Cycle 140 (uses Fail/X)
- Cycle 142 passStyle-helpers.js
- Cycle 148 symbol.js (assertPassableSymbol)
- Cycle 150 typeGuards.js Confirm trio (with Alleged X discipline)
- Cycle 211 @endo/common (ident-checker.js DEPRECATED with §forwarding-comment to Rejector confirm/reject pattern)
- Cycle 322 exo-makers (Fail via M)
- Cycle 325 pass-style README
- Cycle 332 exo-tools (direct `q + Fail` import)
- Cycle 337 @endo/harden README (named in dependency-ceiling)
- Cycle 339 @endo/errors README (just ingested)

Cycle 340 reveals: the CANONICAL DEFINITION of *Rejector* lives in this 23-line types-only file. Every prior observation was a *usage* of the pattern; cycle 340 is the *anchor*.

**§the-named-pattern-citation-network-anchored-at-canonical-source** — first-explicit-observation. The pattern's citation network spans 13+ prior cycles, all anchored at this one file. Tier-3 framing: when a distributed pattern is observed across many cycles, the **canonical-source ingest** is the closure cycle for ALL of them.
