---
source: packages/exo/src/exo-tools.js
source_repo: endojs/endo
source_branch: master
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
source_date: 2025-10-09
source_authors: [Kris Kowal]
ingested: 2026-06-02
ingested_by: scholar
section_count: 3
status: current
notes: |
  Nineteenth comment-fragment ingest. Kris Kowal-authored
  *method-defense + prototype-building* file — *the* implementation
  that cycle 108's exo-makers.js imports `defendPrototype` and
  `defendPrototypeKit` from. Same author + same commit as cycles
  108 (exo-makers.js) + 110 (copySet.js) + 115 (copyBag.js).
  
  The 513-line file decomposes into two argument-cluster sections.
  Section 1 (lines 1-346) covers the per-method defense layer:
  sentinels + defendSyncArgs + buildMatchConfig + defendSyncMethod
  + desync + defendAsyncMethod + defendMethod + bindMethod.
  Section 2 (lines 348-513) covers the prototype-building layer:
  defendPrototype + defendPrototypeKit with interface-guard
  validation.
  
  Section 1's structurally interesting moves: (1) the
  *REDACTED_RAW_ARG-sentinel-for-raw-guard-pass-through* — raw-
  guarded positions are replaced with a string sentinel for the
  matchConfig check; method receives the un-redacted values;
  (2) the *desync transformer* + *TOCTTOU-aware context lookup*
  (*Get the context after all waiting in case we ever do
  revocation by removing the context entry. Avoid TOCTTOU!*);
  (3) the *concise-method-syntax-via-destructure-pattern* for
  `this`-preserving wrappers + chained `.catch`-not-onRejected
  for catching mustMatch throws.
  
  Section 2's structurally interesting moves: (1) the
  *constructor-filter discipline* lets the user pass a JavaScript
  `class.prototype` directly as behavior-methods; (2) the
  *thisful-vs-shifted-method dual mode* — `shiftedMethod(...args)
  { return originalMethod(this, ...args) }` adapter supports
  non-thisful style; (3) the *bidirectional listDifference
  validation* — interface declares vs behavior implements, both
  ways; (4) the *GET_INTERFACE_GUARD auto-installation* — every
  exo class gets a runtime-introspection point for its interface
  guard.
  
  Cycle 118 papers-lane pivot to comments-lane (12+ consecutive
  blocks). Together with cycle 108's exo-makers.js (the user-
  facing factories), this file completes the exo construction
  + defense surface in the library.
---

> Abstract: `packages/exo/src/exo-tools.js` is the *method-
> defense + prototype-building* surface for Exo classes — *the*
> implementation that cycle 108's exo-makers.js imports
> `defendPrototype` and `defendPrototypeKit` from. The 513-line
> file decomposes into two argument-cluster sections.
>
> Section 1 covers the per-method defense layer: the three
> sentinels (`RawMethodGuard` / `REDACTED_RAW_ARG` /
> `PassableMethodGuard`); `defendSyncArgs` with raw-guard
> redaction; `buildMatchConfig` one-time conversion (slow at
> definition-time, fast at call-time); `defendSyncMethod` with
> concise-method-syntax-via-destructure-pattern for
> `this`-preserving wrapping; `desync` transformer for await-
> arg-guards; `defendAsyncMethod` with *Promise.all(awaitList)*
> + TOCTTOU-aware context lookup (*Get the context after all
> waiting ... Avoid TOCTTOU!*); `defendMethod` callKind dispatch;
> `bindMethod` final wrapper with `name`/`length` defineProperties.
>
> Section 2 covers the prototype-building layer: `defendPrototype`
> with constructor-filter discipline (use `class.prototype`
> directly); interface-guard validation via `getInterfaceGuard-
> Payload`; *deprecated `sloppy: true` aliased to `defaultGuards:
> 'passable'`*; symbol method guards merged via
> `fromEntries(getCopyMapEntries(...))`; *symmetric listDifference
> validation* (methods-not-implemented + methods-not-guarded);
> thisful-vs-shifted-method dual mode via `shiftedMethod(...args)
> { return originalMethod(this, ...args) }` adapter; per-method
> defaultGuards resolution (thisful → PassableMethodGuard / non-
> thisful → RawMethodGuard / `'passable'` / `'raw'`);
> `GET_INTERFACE_GUARD` auto-installation; `Far(tag, prototype)`
> final wrapping. `defendPrototypeKit` rejects single-facet kits
> + does 4-way listDifference validation (facet/interface +
> facet/context, both directions).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [method-defense-with-raw-guards-and-async-await-handling](../sections/endo--packages-exo-src-exo-tools-js--method-defense-with-raw-guards-and-async-await-handling.md) | hardened-javascript, exo | current (cycle 118; per-method defense lens) |
| [defendPrototype-and-defendPrototypeKit-with-interface-guard-validation](../sections/endo--packages-exo-src-exo-tools-js--defendPrototype-and-defendPrototypeKit-with-interface-guard-validation.md) | hardened-javascript, exo | current (cycle 118; prototype-building lens) |
| [fourth-complementary-lens-deprecation-pointers-followed-in-practice](../sections/endo--packages-exo-src-exo-tools-js--fourth-complementary-lens-deprecation-pointers-followed-in-practice.md) | exo, cross-package-substrate, deprecation-discipline | current (cycle 332; complementary-lens re-ingest — fourth instance of librarian discipline after cycles 322/324/330; import-graph cross-package substrate + cycle 326 deprecation pointers followed in practice + three-sentinel-set + zero-copy discipline + pivot-cluster context) |

The 513-line file decomposes into two argument-cluster sections. Lines 1-346 are the per-method defense layer (sync + async + raw-guard handling) → section 1. Lines 348-513 are the prototype-building layer (`defendPrototype` + `defendPrototypeKit` + interface-guard validation) → section 2.

## Provenance

- Fetched 2026-06-02 from `endojs/endo@e56bf00f289ff8484094b785b11636b8bc71d87e` via the local bare-clone.
- Last touched 2025-10-09 by Kris Kowal — same author + same commit as cycle 108's `exo-makers.js`, cycle 110's `copySet.js`, cycle 115's `copyBag.js`, and other coordinated-update files.
- Verified file existence and structure via the local bare-clone: 513 lines / 86 comment lines (~17% comment density).
- **Nineteenth comment-fragment ingest**. Pairs structurally with cycle 108's `exo-makers.js` (the user-facing factories that import from here). Together cycles 108 + 118 complete the *Exo construction + defense surface*.
- Cycle 118 was scheduled for papers-lane (12+ consecutive papers-lane blocks since cycle 97) and pivoted to comments-lane.
- Two-section cohesion-honest count. The 513-line file's substantial structural content (method-defense layer + prototype-building layer with bidirectional validation) warrants the split.
- The §user-call-tree visible across cycles 108 + 118 is: *user calls `defineExoClass` (cycle 108) → calls `defendPrototype` (this section 2) → iterates methods + calls `bindMethod` (this section 1) → calls `defendMethod` → dispatches to `defendSyncMethod` or `defendAsyncMethod` (this section 1)*.
