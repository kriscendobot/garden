---
title: The single most structurally interesting move
source: endo--packages-patterns-index-js
url: https://github.com/endojs/endo/blob/master/packages/patterns/index.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/patterns/index.js
total-lines: 98
ingest-cycle: 326
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-barrel-index-as-package-surface-artifact
  - the-named-organized-export-clusters-by-source-file
  - the-named-JSDoc-cannot-express-TypeScript-declarations-discipline
  - the-named-three-TS-features-JSDoc-cannot-express
  - the-named-typed-re-export-for-JSDoc-limitations
  - the-named-namespace-merge-for-M
  - the-named-type-predicate-for-matches
  - the-named-asserts-signature-for-mustMatch
  - the-named-deprecation-re-export-with-canonical-pointer
  - the-named-deprecated-but-still-working
  - the-named-section-divider-as-separator
  - the-named-line-level-eslint-disable-with-context-rationale
  - the-named-documentation-language-cannot-express-target-language-features
  - seventeen-cycles-with-named-pivot-domain-stay
  - ten-named-packages-in-the-pivot-cluster
  - fifteen-citation-arc-closures-in-pivot-now
  - the-named-citation-arc-from-cycle-325-takes-1-cycle-to-close
parent: endo--packages-patterns-index-js--barrel-index-as-package-surface-and-jsdoc-cannot-express-discipline
---

**§the-named-JSDoc-cannot-express-TypeScript-declarations-discipline** — the comment at line 55-58 names *three specific TS features* that JSDoc cannot express, with surgical specificity:

```js
// M, matches, and mustMatch are re-exported from types-index.js
// so they get typed declarations (namespace merge, type-predicate,
// asserts signatures) that JSDoc cannot express.
```

**§the-named-three-TS-features-JSDoc-cannot-express** — first-explicit-observation. Each of the three functions maps to a *specific* TS feature:

| Export | TS feature needed | Why JSDoc can't express |
|---|---|---|
| `M` | **Namespace merge** (interface + namespace with same name merge) | M is both a callable function AND a namespace (`M.string()`, `M.number()`, etc.); JSDoc treats a name as exactly one of {value, type, namespace} |
| `matches` | **Type predicate** (`function matches(x): x is Pattern`) | Narrows the type at the call site; JSDoc's `@returns {x is Pattern}` is non-standard and inconsistently supported |
| `mustMatch` | **Asserts signature** (`function mustMatch(x): asserts x is Pattern`) | TS's `asserts` keyword performs flow-narrowing AFTER the call; JSDoc has no equivalent |

**§the-named-typed-re-export-for-JSDoc-limitations** — the workaround is a *separate* `types-index.js` file that re-exports these three with TS-only declarations. Most of @endo/patterns uses JSDoc-typed JavaScript (per the *no-build-step* discipline shared with @endo/lp32, @endo/hex, etc.); three specific exports get a hand-written `.d.ts`-like file because JSDoc's expressive ceiling is too low for them. **§the-named-documentation-language-cannot-express-target-language-features-IS-named-tooling-honest-acknowledgment** as a tier-3 meta-pattern. First-explicit-observation.

This is also a **sibling pattern** to cycle 323's @endo/captp-README §the-named-API-with-honesty-about-relaxed-security-model: both are *honest acknowledgments of limitations*. Cycle 323 was about API tradeoffs; cycle 326 is about *documentation-language* tradeoffs. **§four-cycles-with-named-honesty-about-API-tradeoffs**? — cycle 326 expands the named subtypes to four:
- **Low-utility-paths** (cycle 321): "most users don't need this"
- **Relaxed-security-models** (cycle 323): "not for mutually-suspicious parties"
- **Functionality-elsewhere** (cycle 325): "for validation, see @endo/exo"
- **Documentation-language-cannot-express** (cycle 326): "JSDoc cannot express these"

**§four-cycles-with-named-honesty-about-API-tradeoffs** (321 + 323 + 325 + 326) — first-explicit-observation as an extension of the parameterized meta-pattern with four named subtypes.
