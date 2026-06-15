---
title: "@endo/patterns index.js — barrel index as package-surface artifact; JSDoc-cannot-express-TS-features named; tenth package; closes cycle 325 Validation arc"
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
---

# `@endo/patterns index.js` — barrel index; JSDoc-cannot-express discipline; tenth package

The 98-line index.js is the **barrel index** / public-API surface of @endo/patterns. Cycle 326 is **chat-lane after cycle 325's designs-lane @endo/pass-style README**. **Seventeenth consecutive non-garden source after the pivot** (cycles 310-326). **§seventeen-cycles-with-named-pivot-domain-stay**. **Tenth package added to pivot cluster** (nat + memoize + hex + lp32 + stream + eventual-send + exo + captp + pass-style + **patterns**) — @endo/patterns was already heavily in the library via cycles 102/104/110/115/120/123/125/127 (eight prior comment-fragment ingests).

**§the-named-citation-arc-from-cycle-325-takes-1-cycle-to-close** — cycle 325 pass-style README cited *"Validation: @endo/patterns"* as a role-label; cycle 326 IS @endo/patterns's public surface. **Second one-cycle README-to-source arc closure in the pivot** (after cycle 324 closing cycle 323 in 1 cycle). §two-cycles-with-named-one-cycle-README-to-package-arc (323→324 + 325→326).

**§fifteen-citation-arc-closures-in-pivot-now**: 1, 1, 2, 4, 165, 169, 175, 175, 177, 189, 191, 214, 238, 254, 255 (cycles).

## The single most structurally interesting move

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

## §the-named-barrel-index-as-package-surface-artifact

The file is **96 export statements** organized into clusters by source file (eight source files), plus a deprecation section. Reading this single file tells the user:

- **What @endo/patterns exports** (the full public API in one place)
- **Which source file each export lives in** (one cluster per source file)
- **Which exports are deprecated** (with canonical pointers to where to find them now)

**§the-named-organized-export-clusters-by-source-file** — each cluster has a comment-free `export { ... } from './path/to/source.js';` shape; the cluster boundaries (= source-file boundaries) are visible by file path. First-explicit-observation.

**§eight-source-files-aggregated** by the index:
- `./src/keys/checkKey.js` (cycle 102 — 224-cycle arc implied)
- `./src/keys/copySet.js` (cycle 110 — 216-cycle arc implied; `coerceToElements`)
- `./src/keys/copyBag.js` (cycle 115 — 211-cycle arc implied; `coerceToBagEntries`)
- `./src/keys/compareKeys.js` (cycle 104 — 222-cycle arc implied)
- `./src/keys/merge-set-operators.js` (cycle 123 — 203-cycle arc implied)
- `./src/keys/merge-bag-operators.js` (cycle 125 — 201-cycle arc implied)
- `./src/patterns/patternMatchers.js` (not yet ingested — patternMatchers.js is 2402 lines; the only @endo/patterns/src file still un-ingested)
- `./src/patterns/getGuardPayloads.js` (cycle 127 — 199-cycle arc implied)

These are **implicit** arc closures (the index *aggregates* the source files; it doesn't deeply re-examine them). I count only the cycle 325 → 326 arc as a direct closure; the seven file-citations are *acknowledgments* that the index gathers what those earlier cycles examined.

## §the-named-deprecation-re-export-with-canonical-pointer

Lines 82-98 form a deprecation section with two re-exports:

```js
// /////////////////////////// Deprecated //////////////////////////////////////

export {
  /**
   * @deprecated
   * Import directly from `@endo/common/list-difference.js` instead.
   */
  listDifference,
} from '@endo/common/list-difference.js';
```

**§the-named-deprecated-but-still-working** — the deprecated re-exports *still work*; backwards compatibility holds. The `@deprecated` JSDoc tag triggers IDE/lint warnings but doesn't break callers. **§the-named-deprecation-tag-with-canonical-pointer**: the JSDoc points to *exactly where* the new import path is. First-explicit-observation. Sibling to cycle 321's "Most users don't need this" (which named *low-utility paths*); the deprecation discipline names *paths the package wants you to abandon over time*.

**§the-named-section-divider-as-separator** (line 82) — `// /////////////////////////// Deprecated //////////////////////////////////////` is a visual divider; the slashes echo the file's structure (export statements / divider / deprecated exports). Compare to cycle 322 exo-makers's use of comments-as-warnings (state-sealed-not-frozen repeated three times); this is comments-as-section-delimiters. First-explicit-observation.

## §the-named-line-level-eslint-disable-with-context-rationale

Line 79-80: `// eslint-disable-next-line import/export\nexport * from './types-index.js';` — line-level eslint disable specifically marks the wildcard export's potential conflict with the named exports above. Compare to cycle 324 atomics.js's three line-level `no-bitwise` disables (which marked individual deliberate bitwise ops). Cycle 326's disable marks a *single* wildcard export with a *contextual* lint rule (import/export reports possible conflicts between `export *` and named exports).

**§three-cycles-with-named-line-level-eslint-disable** (324 + 326; both line-level; cycle 314 + 318 were file-level). §two-shapes-of-eslint-disable continues to apply.

## Patterns the cycle extends

- §seventeen-cycles-with-named-pivot-domain-stay (310-326)
- §ten-named-packages-in-the-pivot-cluster (tenth: patterns)
- §fifteen-citation-arc-closures-in-pivot-now (added cycle 325 → 326 = 1 cycle)
- §four-cycles-with-named-honesty-about-API-tradeoffs (321 + 323 + 325 + 326; four named subtypes)
- §two-cycles-with-named-one-cycle-README-to-package-arc (323→324 + 325→326)
- §three-cycles-with-named-line-level-eslint-disable (324 + 326; doc-level for index/export rationale)

## Tier-1 borrowing (mostly meta-structural observations)

This is a *short* file (98 lines, mostly export statements). The observations are necessarily fewer than a 300+-line implementation file would yield, but they are *meta-structural* — about how the package presents itself to consumers rather than how it does work internally:

- **§the-named-barrel-index-as-package-surface-artifact** — readable in one sitting; gives the full API view
- **§the-named-JSDoc-cannot-express-TypeScript-declarations-discipline** — name the documentation-language limitation surgically (which features, which exports, which workaround)
- **§the-named-three-TS-features-JSDoc-cannot-express** — namespace merge + type predicate + asserts signature
- **§the-named-typed-re-export-for-JSDoc-limitations** — the workaround pattern (separate types-index.js)
- **§the-named-deprecation-tag-with-canonical-pointer** — `@deprecated / Import directly from <path>`
- **§the-named-section-divider-as-separator** — visual `// ///////` divider for sections within a file
- **§the-named-line-level-eslint-disable-with-context-rationale** — disable the lint rule with the context that triggered it visible

## Tier-2 borrowing (multi-cycle patterns extended)

- §seventeen-cycles-with-named-pivot-domain-stay
- §ten-named-packages-in-the-pivot-cluster
- §fifteen-citation-arc-closures-in-pivot-now
- §four-cycles-with-named-honesty-about-API-tradeoffs (four named subtypes now)
- §two-cycles-with-named-one-cycle-README-to-package-arc

## Tier-3 borrowing (meta-patterns)

- **§the-named-documentation-language-cannot-express-target-language-features** — when the documentation language (JSDoc) cannot express features of the target language (TypeScript), name the gap honestly and provide a workaround
- **§the-named-honesty-about-API-tradeoffs** parameterized with four named subtypes (low-utility + relaxed-security + functionality-elsewhere + documentation-language-cannot-express)
- **§the-named-barrel-index-as-package-surface-artifact** — a single file enumerates the package's full public API
- **§the-named-organized-export-clusters-by-source-file** — readers can navigate from any export back to its source by reading the cluster's `from` path
- **§the-named-deprecated-but-still-working** — deprecation as a soft removal path; users get warnings but their code keeps working
- **§the-named-deprecation-tag-with-canonical-pointer** — the deprecation pointer is the migration plan

## Synthesis-target

Slot machine library **§`@game/patterns/index.js`** — barrel index for game-pattern-matching library:

1. **Barrel-index** that enumerates the full public API.
2. **Organized-export-clusters by source file** so readers can navigate from each export to its source.
3. **Typed-re-export for JSDoc limitations** — if any exports require TS features JSDoc can't express (namespace merge for builder objects + type predicates for type-guards + asserts signatures for type-guard-asserts), put them in a separate `types-index.js` and re-export with `export * from './types-index.js'` (line-level eslint-disable for the wildcard).
4. **Deprecation section** with `@deprecated / Import directly from <path>` per export.
5. **Section divider** (`// /////////// Deprecated /////////////`) visually separates active from deprecated.
6. **Comment** above the typed-re-export naming which features JSDoc can't express.

## Library state after cycle 326

- §library-reaches-838-sections from 374 source documents
- §one-hundred-and-fifty-ninth consecutive designs-chat alternation
- §seventeen-cycles-with-named-pivot-domain-stay
- §ten-named-packages-in-the-pivot-cluster
- §fifteen-citation-arc-closures-in-pivot-now
- §four-cycles-with-named-honesty-about-API-tradeoffs (parameterized with four named subtypes)
