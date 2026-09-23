---
title: §the-named-helpers-private-export-single-public
source: endo--packages-promise-kit-src-memo-race-js
url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/memo-race.js
authors: [Brian Kim (original), Endo project (adopted)]
repo: endojs/endo
path: packages/promise-kit/src/memo-race.js
total-lines: 170
ingest-cycle: 336
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-deviation-named-in-the-source-too
  - the-named-implementation-of-the-accommodation
  - the-named-public-domain-license-header-preserved-verbatim
  - the-named-attribution-discipline-when-adopting-public-domain-code
  - the-named-explicit-acknowledgment-of-cross-package-layering-constraint
  - the-named-name-both-the-goal-and-the-obstacle
  - the-named-helpers-private-export-single-public
  - the-named-export-the-noun-not-the-verbs
  - the-named-in-place-transition-for-shared-references
  - the-named-assign-then-freeze-transition
  - the-named-fake-record-honors-real-record-discipline
  - the-named-named-function-via-object-destructure
  - the-named-api-name-vs-impl-name-asymmetry
  - the-named-JSDoc-generic-this-binding
  - the-named-cachedValues-defends-against-one-shot-iterables
  - the-named-complementary-lens-re-ingest
  - the-named-streak-resumes-after-one-cycle-gap
  - five-cycles-with-named-complementary-lens-re-ingest
  - twenty-seven-cycles-with-named-pivot-domain-stay
  - fifty-citation-arc-closures-in-pivot-now
parent: endo--packages-promise-kit-src-memo-race-js--fifth-complementary-lens-deviation-named-in-the-source-too
---

The file declares five top-level names plus the export:

| Name | Visibility | Role |
|---|---|---|
| `isPrimitive` | private | Type predicate (duplicated with @endo/pass-style; named TODO) |
| `markSettled` | private | Atomic-transition helper |
| `knownPromises` | private | Module-scope WeakMap state |
| `getMemoRecord` | private | Memo lookup with primitive bypass |
| `race` (object-destructure) | private name, exported | Public API |
| `memoRace` (export rename) | exported | The package surface |

Five private names; one public export.

**§the-named-helpers-private-export-single-public** — first-explicit-observation. The file exposes a **single function** (`memoRace`); the helpers are private to the module. Compare to:
- Cycle 326 @endo/patterns/index.js: barrel-index aggregator exposing N exports (substrate-package shape)
- Cycle 333 @endo/common/README.md: no-barrel-index with one-file-one-export (collection-package shape)
- **Cycle 336 memo-race.js**: single-file-single-export with private helpers (utility-package shape)

**§the-named-three-shapes-of-export-discipline** — barrel-index (substrate) + one-file-one-export-no-index (collection) + single-file-single-export-with-private-helpers (utility). First-explicit-observation as a refinement of cycle 333's three-way collection/substrate/utility categorization, parameterized by **export shape** in addition to README shape.

**§the-named-export-the-noun-not-the-verbs** — first-explicit-observation. The file's `race` is the noun (a racing function); `markSettled`, `getMemoRecord` are the verbs (helpers that prepare the noun). Only the noun is exported. The verbs are private state-machine bookkeeping. **§the-named-private-state-machine-public-surface** as a related discipline.
