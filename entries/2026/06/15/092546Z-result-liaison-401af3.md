---
kind: result
role: liaison
dispatch-root: dispatches/liaison--401af3
cycle: 326
lane: chat
host: endolin
date: 2026-06-15
---

# Result — liaison cycle 326: @endo/patterns index.js (chat-lane; tenth package; barrel index; honesty-about-API-tradeoffs gains fourth subtype)

Cycle 326 ingest: **@endo/patterns index.js** (98 lines) — the barrel index / public-API surface of @endo/patterns. **Seventeenth consecutive non-garden source after the pivot** (cycles 310-326). **§seventeen-cycles-with-named-pivot-domain-stay**. **Tenth package added to pivot cluster** (patterns; previously in library via eight comment-fragment ingests across cycles 102/104/110/115/120/123/125/127). Closes cycle 325 → 326 in 1 cycle — **second one-cycle README→package arc closure in the pivot** after cycle 324's 1-cycle closure with cycle 323.

## Single most structurally interesting move

**§the-named-JSDoc-cannot-express-TypeScript-declarations-discipline** — the comment at line 55-58 names *three specific TS features* JSDoc cannot express, mapped to three specific exports with surgical specificity:

```js
// M, matches, and mustMatch are re-exported from types-index.js
// so they get typed declarations (namespace merge, type-predicate,
// asserts signatures) that JSDoc cannot express.
```

| Export | TS feature needed | Why JSDoc can't express |
|---|---|---|
| `M` | Namespace merge | M is both callable AND a namespace; JSDoc treats a name as one of {value, type, namespace} |
| `matches` | Type predicate (`x is Pattern`) | Narrows the type; JSDoc's `@returns {x is Pattern}` is non-standard |
| `mustMatch` | Asserts signature (`asserts x is Pattern`) | TS's `asserts` keyword has no JSDoc equivalent |

**§the-named-three-TS-features-JSDoc-cannot-express** — first-explicit-observation. The workaround is a separate `types-index.js` re-exporting these three with TS-only declarations. **§the-named-documentation-language-cannot-express-target-language-features** as a tier-3 meta-pattern. First-explicit-observation.

## Fourth subtype of honesty-about-API-tradeoffs

**§the-named-honesty-about-API-tradeoffs** now parameterized with **four named subtypes**:

| Subtype | Cycle | Phrase |
|---|---|---|
| Low-utility-paths | 321 | "Most users don't need this" |
| Relaxed-security-models | 323 | "Not for mutually-suspicious parties" |
| Functionality-elsewhere | 325 | "For validation, see @endo/exo" |
| **Documentation-language-cannot-express** | **326** | **"JSDoc cannot express these"** |

**§four-cycles-with-named-honesty-about-API-tradeoffs** (321 + 323 + 325 + 326). The pattern was *first-explicit-observed* in cycle 321 with two subtypes; cycles 323/325/326 each added a new subtype. The meta-pattern of *naming the tradeoff in user-facing prose so consumers can reason about fit* is now confirmed across four cycles with four distinct surfaces (API-utility + API-security + API-scope + documentation-language).

## §the-named-barrel-index-as-package-surface-artifact

The 98-line file is the *full public API* of @endo/patterns in one place:

- **96 export statements** organized into eight clusters by source file
- **8 source files aggregated** (checkKey + copySet + copyBag + compareKeys + merge-set-operators + merge-bag-operators + patternMatchers + getGuardPayloads)
- **7 of 8 source files previously ingested** (patternMatchers.js — 2402 lines — is the only un-ingested @endo/patterns/src file)
- **2 deprecated exports** with canonical pointers (listDifference + objectMap → @endo/common)

**§the-named-organized-export-clusters-by-source-file** — cluster boundaries align with source-file boundaries; readers can navigate from any export to its source.

## Other first-explicit-observations

- §the-named-deprecation-re-export-with-canonical-pointer — `@deprecated / Import directly from <path>` with the pointer naming the migration path
- §the-named-deprecated-but-still-working — soft removal; warnings without breaking callers
- §the-named-section-divider-as-separator — `// /////// Deprecated /////////` visual divider
- §the-named-line-level-eslint-disable-with-context-rationale — `// eslint-disable-next-line import/export` for the wildcard `export *` (§three-cycles-with-named-line-level-eslint-disable: 324 + 326)

## Multi-cycle patterns extended

- §seventeen-cycles-with-named-pivot-domain-stay (310-326)
- §ten-named-packages-in-the-pivot-cluster (tenth: patterns)
- §fifteen-citation-arc-closures-in-pivot-now (added cycle 325 → 326 = 1 cycle)
- §four-cycles-with-named-honesty-about-API-tradeoffs (four named subtypes)
- §two-cycles-with-named-one-cycle-README-to-package-arc (323→324 + 325→326)
- §three-cycles-with-named-line-level-eslint-disable (324 + 326)

## Tier-3 meta-patterns

- **§the-named-documentation-language-cannot-express-target-language-features** — name the gap honestly + provide a workaround (separate types-index.js)
- **§the-named-honesty-about-API-tradeoffs** parameterized with four named subtypes
- **§the-named-barrel-index-as-package-surface-artifact** — single file enumerates the full public API
- **§the-named-organized-export-clusters-by-source-file** — readers navigate from exports to sources via cluster boundaries
- **§the-named-deprecated-but-still-working** — deprecation as soft removal path
- **§the-named-deprecation-tag-with-canonical-pointer** — the deprecation pointer IS the migration plan

## Synthesis-target

Slot machine library **§`@game/patterns/index.js`** — barrel index:

1. **Barrel-index** enumerating the full public API.
2. **Organized-export-clusters by source file** for navigation.
3. **Typed-re-export for JSDoc limitations** — if any exports need TS features JSDoc can't express, put them in a separate `types-index.js` and re-export with `export * from './types-index.js'` (line-level eslint-disable for the wildcard).
4. **Deprecation section** with `@deprecated` + canonical pointer per export.
5. **Section divider** (`// /////// Deprecated /////////`) visually separates active from deprecated.
6. **Comment above the typed-re-export** naming which TS features JSDoc can't express.

## Library state after cycle 326

- §library-reaches-838-sections from 374 source documents
- §one-hundred-and-fifty-ninth consecutive designs-chat alternation
- §seventeen-cycles-with-named-pivot-domain-stay
- §ten-named-packages-in-the-pivot-cluster
- §fifteen-citation-arc-closures-in-pivot-now (1, 1, 2, 4, 165, 169, 175, 175, 177, 189, 191, 214, 238, 254, 255 cycles)
- §four-cycles-with-named-honesty-about-API-tradeoffs (parameterized with four named subtypes)

## Next cycle pacing

Cycle 327 is designs-lane next. Candidate moves:

- **@endo/patterns README.md** (415 lines) — designs-lane; would form an immediate adjacent-reverse pair with cycle 326 (index.js → README) mirroring lp32 315-316. Productive.
- **@endo/marshal README.md** — designs-lane; would introduce an eleventh package; cycle 325 cited @endo/marshal as "Serialization" role-label.
- **@endo/exo README.md** — designs-lane; companion to cycle 322's exo-makers.js; would complete a three-file exo cluster (README + 322 makers + 239 get-interface + 118 tools as comment-fragment).

@endo/patterns README is the most natural next step (adjacent-reverse pair with cycle 326, mirroring the 315-316 lp32 shape; 415 lines so substantively rich; will likely close more @endo/patterns citation arcs). Picking freely but tracking for future work.
