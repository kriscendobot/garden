---
title: "@endo/errors rejector.js — canonical typedef as the pattern anchor of the distributed Rejector trio; types-only file; closes 238-cycle arc to cycle 102's first Rejector observation"
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
---

# `@endo/errors rejector.js` — canonical typedef as the pattern anchor of the distributed Rejector trio

A 23-line **types-only file** — almost entirely JSDoc with one line of code (an import). Yet this tiny file is the **canonical anchor** of the *Confirm/Is/Assert trio* pattern observed across the pivot. Cycle 340 is **chat-lane after cycle 339's designs-lane @endo/errors README** — adjacent forward pair, same package. **§the-named-streak-resumes-with-tenth-instance** — the streak count returns to 1; this is the **tenth INSTANCE** of one-cycle README↔source pattern.

**Thirty-first consecutive non-garden source after the pivot** (cycles 310-340). **§thirty-one-cycles-with-named-pivot-domain-stay**. **§fifteen-named-packages-in-the-pivot-cluster** continues (errors's source after its README).

## The single most structurally interesting move

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

## §the-named-types-only-file

The file has:

| Line range | Content |
|---|---|
| 1-2 | `// eslint-disable-next-line no-unused-vars`<br>`import { Fail } from './index.js';` |
| 3-23 | JSDoc block defining the `Rejector` typedef |

**Runtime behavior**: importing `./rejector.js` runs the import, which is a no-op (the imported `Fail` is referenced only in the JSDoc). **No exports**. **No side effects**.

**§the-named-types-only-file** — first-explicit-observation as a tier-3 meta-pattern. A file whose entire purpose is to provide a *type definition* via JSDoc. The file is grep-able and importable for typechecker integration, but doesn't contribute to runtime behavior.

**§the-named-twenty-three-line-types-only-file** — first-explicit-observation. The discipline: when a type definition needs a stable URL anchor (so consumers can `import('./rejector.js').Rejector`), put it in its own file.

**§the-named-import-for-typedef-only-with-named-lint-disable** — first-explicit-observation. Line 1: `// eslint-disable-next-line no-unused-vars`. The import of `Fail` is *unused at runtime* but *referenced in the typedef* (`@typedef {false | typeof Fail} Rejector`). The lint-disable comment explicitly acknowledges this — sibling to cycle 338's `@endo/no-polymorphic-call` disable-comment for the uncurryThis canonical idiom. **§three-cycles-with-named-named-lint-disable-with-canonical-rationale** (211 + 338 + 340).

## §the-named-Rejector-IS-false-OR-Fail

The typedef:

```js
@typedef {false | typeof Fail} Rejector
```

**§the-named-Rejector-IS-false-OR-Fail** — first-explicit-observation. The Rejector type is a sum-type with two inhabitants:
- `false` — the **silent-reject** mode (don't throw)
- `typeof Fail` — the **throwing-reject** mode (throw via the Fail template literal tag)

**§the-named-binary-choice-silent-vs-throwing** — first-explicit-observation. The Rejector parameter is the discriminator between two modes: silent (used by `is*` predicates) and throwing (used by `assert*` assertions). The SAME function body can serve both modes; the Rejector argument switches behavior at the boundary.

Cycle 102's checkKey.js named the trio pattern (Confirm/Is/Assert); cycle 340 reveals the canonical typedef that *describes the Rejector parameter shape*. The trio pattern's machinery: a private `confirmX(val, rejector)` function takes a Rejector; `isX(val) = confirmX(val, false)` (silent); `assertX(val) = confirmX(val, Fail)` (throwing).

**§the-named-discriminator-type-as-mode-switch** — first-explicit-observation as a tier-3 meta-pattern. Tier-3 framing: when one function body needs to serve two modes (silent + throwing), pass a discriminator parameter whose type is a sum-type covering both modes; let the function body short-circuit on the discriminator value.

## §the-named-cond-OR-reject-AND-reject-template-literal

The JSDoc's canonical idiom:

```js
cond || reject && reject`...`
```

**§the-named-cond-OR-reject-AND-reject-template-literal** — first-explicit-observation. The idiom is THREE-PART:

1. `cond` — the predicate; truthy means we're done
2. `||` — short-circuit if `cond` is falsy, proceed to check rejector
3. `reject && reject\`...\`` — if rejector is `false`, the `&&` short-circuits to `false`; if rejector is `Fail`, invoke as template literal tag with `...` arguments

**§the-named-three-step-evaluation-shown-in-JSDoc** — first-explicit-observation. The JSDoc walks through three explicit cases:

> If `cond` is truthy, that is the value of the expression.
> Else if `reject` is false, it is the value
> Otherwise, invoke `reject` just like you would invoke `Fail`, with the same template arguments.

The three-case enumeration MATCHES the binary-decision-tree of the idiom (truthy / falsy-and-silent / falsy-and-throwing). **§the-named-three-case-enumeration-tracks-binary-tree** — first-explicit-observation. Tier-3 framing: when prose explains a short-circuit expression, enumerate each leaf of the decision tree explicitly.

**§the-named-template-literal-tag-as-error-constructor** — first-explicit-observation. The idiom invokes `Fail` as a template literal tag: `Fail\`...\``. This is the canonical @endo error-construction syntax (cycle 87 named the `null.null` syntax for `makeTypeError`; cycle 340 names the `Fail\`...\`` syntax for the @endo/errors trio). **§two-shapes-of-error-construction-syntax** (cycle 87 `null.null` + cycle 340 `Fail\`...\``) — first-explicit-observation.

## §the-named-test-file-as-canonical-examples

Line 18: *"See rejector.test.js for illustrative examples."*

**§the-named-test-file-as-canonical-examples** — first-explicit-observation as a tier-3 meta-pattern. The JSDoc points readers to the TEST FILE for illustration. The test file IS the documentation-by-example.

Compare to cycle 333 @endo/common's *"Sometimes the associated test files also serve as informative examples"* observation — cycle 333 NAMED the pattern as a discipline; cycle 340 APPLIES the pattern. **§two-cycles-with-named-tests-as-examples-discipline** (333 + 340).

**§the-named-references-test-as-illustration** — first-explicit-observation. The discipline: when a type or idiom is subtle enough that prose alone might be ambiguous, point to a test file. Tier-3 framing: tests aren't just verification; they're documentation for cases too subtle for prose.

## Closes citation arcs (canonical-source closure of the Rejector trio)

Cycle 340 is the **canonical-source closure** of the Rejector trio pattern, observed across many prior cycles. The arcs:

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 339 (@endo/errors README) | 1 cycle | Adjacent forward pair; same-package README→source |
| **Cycle 102 (patterns/checkKey.js Rejector trio FIRST observation)** | **238 cycles** | Pattern's first-explicit-observation; CANONICAL anchor |
| Cycle 87 (pass-style/error.js) | 253 cycles | Error-discipline observation; **ties cycle 339's 252-cycle arc as second-longest** |
| Cycle 134 (remotable.js Confirm trio) | 206 cycles | Uses Fail/X |
| Cycle 138 (uses Fail) | 202 cycles | Imports from @endo/errors |
| Cycle 142 (passStyle-helpers.js) | 198 cycles | uses Fail/X |
| Cycle 148 (symbol.js assertPassableSymbol) | 192 cycles | uses Fail |
| Cycle 150 (typeGuards.js Confirm trio + Alleged X) | 190 cycles | Confirm trio + Alleged discipline |
| Cycle 211 (@endo/common ident-checker DEPRECATED with forwarding-comment to Rejector) | 129 cycles | Names Rejector in deprecation pointer |

**§nine-citation-arc-closures-in-cycle-340**. **§seventy-five-citation-arc-closures-in-pivot-now** (68 + 7 net new). The cycle 87 → 340 arc at **253 cycles** ties cycle 339's 252-cycle arc as second-longest pivot arc (current record: 261 cycles from cycle 69 → 330).

**§the-named-substrate-package-introduction-closes-many-arcs** discipline applies for the THIRD TIME (cycle 337 + 339 + 340). **§three-cycles-with-named-substrate-package-introduction** — first-explicit-observation as a tier-2 multi-cycle pattern.

**§the-named-canonical-source-closure-of-the-Rejector-trio** — first-explicit-observation. The cycle 102 arc at 238 cycles is the closure of the *Rejector pattern's first observation*. The cycle 102 ingest named the trio pattern; cycle 340 reveals the canonical typedef. The two cycles bracket the pattern's life in the library.

## §the-named-substrate-of-substrates-zero-endo-imports-modulo-rejector

Looking at this file's imports: ONE import from `./index.js` (same package). **Zero @endo imports outside the package itself**. Like cycle 338's make-hardener.js, the @endo/errors package's source files have minimal cross-org dependencies.

**§the-named-intra-package-import-as-canonical-coupling** — first-explicit-observation. The discipline: when a source file in package X needs a name from another file in the SAME package X, import via relative path `./other.js` rather than `@endo/X/other.js`. The relative-path import marks INTRA-package coupling vs cross-package coupling.

Compare to cycle 332's @endo/exo's `import { GET_INTERFACE_GUARD } from './get-interface.js';` — also an intra-package import. **§three-cycles-with-named-intra-package-relative-import** (322 + 332 + 340). The discipline is consistent across @endo packages.

## Patterns the cycle extends

- §thirty-one-cycles-with-named-pivot-domain-stay (310-340)
- §fifteen-named-packages-in-the-pivot-cluster (errors's source after its README)
- §seventy-five-citation-arc-closures-in-pivot-now (68 + 7 net new)
- §three-cycles-with-named-substrate-package-introduction (337 + 339 + 340)
- §three-cycles-with-named-named-lint-disable-with-canonical-rationale (211 + 338 + 340)
- §two-cycles-with-named-tests-as-examples-discipline (333 + 340)
- §three-cycles-with-named-intra-package-relative-import (322 + 332 + 340)
- §two-shapes-of-error-construction-syntax (87 `null.null` + 340 `Fail\`...\``)
- §the-named-streak-resumes-with-tenth-instance (cycle 339 → 340 same-package; streak count is 1)

## Tier-1 borrowing (fifteen-plus first-explicit-observations from a 23-line file)

- **§the-named-canonical-typedef-as-the-pattern-anchor** — the file IS the pattern
- **§the-named-canonical-source-of-a-distributed-pattern** — anchor for many prior observations
- **§the-named-pattern-citation-network-anchored-at-canonical-source**
- **§the-named-types-only-file** — JSDoc + import; no runtime exports
- **§the-named-twenty-three-line-types-only-file**
- **§the-named-import-for-typedef-only-with-named-lint-disable**
- **§the-named-Rejector-as-typedef**
- **§the-named-Rejector-IS-false-OR-Fail** — sum-type discriminator
- **§the-named-binary-choice-silent-vs-throwing**
- **§the-named-discriminator-type-as-mode-switch**
- **§the-named-cond-OR-reject-AND-reject-template-literal** — three-part short-circuit idiom
- **§the-named-three-step-evaluation-shown-in-JSDoc** — enumerated three cases
- **§the-named-three-case-enumeration-tracks-binary-tree**
- **§the-named-template-literal-tag-as-error-constructor**
- **§the-named-test-file-as-canonical-examples**
- **§the-named-references-test-as-illustration**
- **§the-named-intra-package-import-as-canonical-coupling**
- **§the-named-canonical-source-closure-of-the-Rejector-trio**

## Tier-2 borrowing (multi-cycle patterns extended)

- §thirty-one-cycles-with-named-pivot-domain-stay
- §fifteen-named-packages-in-the-pivot-cluster
- §seventy-five-citation-arc-closures-in-pivot-now
- §three-cycles-with-named-substrate-package-introduction (337 + 339 + 340)
- §three-cycles-with-named-named-lint-disable-with-canonical-rationale (211 + 338 + 340)
- §two-cycles-with-named-tests-as-examples-discipline (333 + 340)
- §three-cycles-with-named-intra-package-relative-import (322 + 332 + 340)
- §two-shapes-of-error-construction-syntax (87 + 340)
- §the-named-streak-resumes-with-tenth-instance (cycle 339 → 340; streak count is 1)

## Tier-3 borrowing (meta-patterns)

- **§the-named-canonical-source-of-a-distributed-pattern** — when many cycles observe a pattern's usage, the canonical-source ingest is the closure for ALL of them
- **§the-named-pattern-citation-network-anchored-at-canonical-source** — the citation network has a structural shape: many-usage-observations anchored at one canonical-source
- **§the-named-types-only-file** — when a type definition needs a stable URL anchor, put it in its own file
- **§the-named-discriminator-type-as-mode-switch** — one function body can serve multiple modes via a discriminator parameter whose type is a sum-type
- **§the-named-three-case-enumeration-tracks-binary-tree** — when prose explains short-circuit expressions, enumerate each leaf of the decision tree
- **§the-named-test-file-as-canonical-examples** — tests serve as documentation for subtle cases
- **§the-named-intra-package-import-as-canonical-coupling** — relative-path imports mark intra-package coupling; cross-package uses `@endo/X/foo.js`

## Synthesis-target

Slot machine library **§`@game/errors/rejector.js`** — canonical typedef for a distributed pattern:

1. **Canonical typedef as pattern anchor** — when many call sites use a pattern, the typedef of the pattern's parameter type should have its own stable URL
2. **Types-only file** — JSDoc + lint-disabled import; no runtime exports
3. **Binary-choice discriminator type** — `false | typeof X` for silent-vs-throwing modes
4. **Three-step idiom shown in JSDoc** — `cond || reject && reject\`...\``; enumerate each leaf of the decision tree in prose
5. **Test file as canonical examples** — point readers to test file for subtle cases
6. **Intra-package import via relative path** — same-package imports use `./other.js`, not `@org/pkg/other.js`

## Library state after cycle 340

- §library-reaches-852-sections from 385 source documents (new section + new source page)
- §one-hundred-and-seventy-third consecutive designs-chat alternation
- §thirty-one-cycles-with-named-pivot-domain-stay
- §fifteen-named-packages-in-the-pivot-cluster (errors's source after its README; fifteenth source page in the pivot)
- §seventy-five-citation-arc-closures-in-pivot-now (68 + 7 net new)
- §three-cycles-with-named-substrate-package-introduction (337 + 339 + 340) — the substrate-package-introduction-closes-many-arcs librarian discipline now spans three applications
- §the-named-streak-resumes-with-tenth-instance (cycle 339 → 340 same-package; tenth INSTANCE of one-cycle README↔source pattern; streak count is 1)
- §the-named-canonical-typedef-as-the-pattern-anchor established as tier-3 meta-pattern
- §the-named-canonical-source-of-a-distributed-pattern established as tier-3 meta-pattern
- §the-named-types-only-file established as tier-3 meta-pattern
- §the-named-discriminator-type-as-mode-switch established as tier-3 meta-pattern
- §the-named-test-file-as-canonical-examples established as tier-3 meta-pattern
- §the-named-canonical-source-closure-of-the-Rejector-trio (cycle 102 → 340 = 238 cycles)
