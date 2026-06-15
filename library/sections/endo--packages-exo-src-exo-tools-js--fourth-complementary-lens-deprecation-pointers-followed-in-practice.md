---
title: "@endo/exo src/exo-tools.js — fourth complementary-lens re-ingest; deprecation-pointers-followed-in-practice (cycle 326 closure); cross-package import-graph fan-out; fifth one-cycle README→source arc 331→332"
source: endo--packages-exo-src-exo-tools-js
url: https://github.com/endojs/endo/blob/master/packages/exo/src/exo-tools.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/exo/src/exo-tools.js
total-lines: 513
ingest-cycle: 332
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-deprecation-pointers-followed-in-practice
  - the-named-deprecation-as-soft-contract-with-followed-pointer
  - the-named-import-graph-from-exo-tools-IS-named-cross-package-substrate
  - the-named-fan-out-import-graph-recurs
  - the-named-listDifference-and-objectMap-from-common-not-patterns
  - the-named-RawMethodGuard-and-PassableMethodGuard-default-guards
  - the-named-REDACTED_RAW_ARG-as-sentinel-string
  - the-named-three-sentinel-set-discipline
  - the-named-raw-vs-passable-distinction-with-two-default-guards
  - the-named-zero-copy-when-possible-discipline
  - the-named-Reflect-destructure-grows-with-adoption
  - the-named-complementary-lens-re-ingest
  - twenty-three-cycles-with-named-pivot-domain-stay
  - four-cycles-with-named-complementary-lens-re-ingest
  - five-cycles-with-named-one-cycle-README-source-arc
  - forty-one-citation-arc-closures-in-pivot-now
  - three-cycles-with-named-Reflect-destructure-at-module-load
---

# `@endo/exo src/exo-tools.js` — fourth complementary-lens re-ingest; deprecation pointers followed in practice

The 513-line exo-tools.js. Cycle 332 is **chat-lane after cycle 331's designs-lane @endo/exo README**. **Twenty-third consecutive non-garden source after the pivot** (cycles 310-332). **§twenty-three-cycles-with-named-pivot-domain-stay**.

**Note on prior ingest**: This file was first ingested in **cycle 118** by a scholar dispatch (comment-fragment, 19th ingest, paired with cycle 108 exo-makers.js). The cycle 118 sections (2 sections; lines 1-346 + lines 348-513) took the *method-defense + prototype-building* lens with focus on TOCTTOU-aware context lookup, chained .catch, raw-guard redaction, buildMatchConfig, defendSyncMethod with concise-method-syntax, desync transformer, callKind dispatch, bindMethod, constructor-filter, symmetric listDifference, thisful-vs-shifted, GET_INTERFACE_GUARD auto-installation, defendPrototypeKit single-facet rejection.

Cycle 332 is a **§the-named-complementary-lens-re-ingest** (librarian discipline first-explicit-observed in cycle 322 for exo-makers.js, applied to atomics.js in cycle 324, then smallcaps.js in cycle 330). **§four-cycles-with-named-complementary-lens-re-ingest** (322 + 324 + 330 + 332) — the discipline now spans **four applications**. The cycle 332 lens emphasizes:

1. **Cross-package import-graph closures** (six citation arcs to cycles in the pivot)
2. **Cycle 326 deprecation-pointers-followed-in-practice** — exo-tools.js demonstrates the *correct* import path that cycle 326's patterns/index.js @deprecated tags pointed to
3. **Three-sentinel-set** at module scope (RawMethodGuard + PassableMethodGuard + REDACTED_RAW_ARG)
4. **Zero-copy-when-possible** performance discipline in defendSyncArgs
5. **Reflect destructure grows with adoption** — cycle 332 expands the pattern from cycle 314/318's single-name to two-name

## The single most structurally interesting move

**§the-named-deprecation-pointers-followed-in-practice** — line 14-15 of exo-tools.js:

```js
import { listDifference } from '@endo/common/list-difference.js';
import { objectMap } from '@endo/common/object-map.js';
```

Cycle 326's @endo/patterns/index.js had these *exact* exports marked **@deprecated** with canonical pointers (line 82-98 of cycle 326's source):

```js
export {
  /**
   * @deprecated
   * Import directly from `@endo/common/list-difference.js` instead.
   */
  listDifference,
} from '@endo/common/list-difference.js';
```

Cycle 332's exo-tools.js **follows the deprecation pointer in practice** — it imports from `@endo/common/list-difference.js` directly, NOT from `@endo/patterns`. The deprecation tag isn't aspirational; sibling code in the same family follows it.

**§the-named-deprecation-as-soft-contract-with-followed-pointer** — first-explicit-observation. The deprecation discipline from cycle 326 wasn't just documentation; it was a *soft contract* that the rest of the family honored. The @deprecated re-export remains in patterns/index.js for *external* consumers; *internal* consumers in @endo/* follow the pointer. **§the-named-internal-consumers-follow-deprecation-pointers** — first-explicit-observation.

This is the *implementation-side closure* of cycle 326's deprecation discipline. Cycle 326 (designs-lane) said *"Import directly from @endo/common"*; cycle 332 (chat-lane) does exactly that, six cycles later. **§the-named-citation-arc-from-cycle-326-takes-6-cycles-to-close** as a deprecation-followed-in-practice arc.

## §the-named-import-graph-from-exo-tools-IS-named-cross-package-substrate

Lines 1-17 of exo-tools.js import from **six @endo packages plus one local file**:

| Import source | Names | Closes arc with |
|---|---|---|
| `@endo/harden` | `harden` | (substrate) |
| `@endo/eventual-send` | `E` | cycle 321 (11 cycles) |
| `@endo/pass-style` | `getRemotableMethodNames`, `toThrowable`, `Far` | cycle 325 (7 cycles) |
| `@endo/patterns` | `mustMatch`, `M`, `isAwaitArgGuard`, `isRawGuard`, `getAwaitArgGuardPayload`, `getMethodGuardPayload`, `getInterfaceGuardPayload`, `getCopyMapEntries` | cycle 327 (5 cycles) |
| `@endo/common/list-difference.js` | `listDifference` | cycle 326 (6 cycles; deprecation-pointer-followed) |
| `@endo/common/object-map.js` | `objectMap` | cycle 326 (6 cycles; deprecation-pointer-followed) |
| `@endo/errors` | `q`, `Fail` | (substrate) |
| `./get-interface.js` | `GET_INTERFACE_GUARD` | cycle 239 (93 cycles) |

**§the-named-fan-out-import-graph-recurs** — cycle 322's exo-makers.js had **§the-named-import-graph-from-exo-IS-named-fan-out** (five external imports + one local); cycle 332's exo-tools.js has *seven* import sources (six external + one local). §two-cycles-with-named-fan-out-import-graph-from-exo (322 + 332). First-explicit-observation as a recurring discipline.

**§six-citation-arc-closures-in-cycle-332** (matching cycles 325 + 328 + 331 records): cycle 118 self via complementary-lens = 214 cycles + cycle 321 eventual-send = 11 + cycle 325 pass-style = 7 + cycle 326 patterns deprecation = 6 (deprecation-followed) + cycle 327 patterns README = 5 + cycle 331 exo README = 1 (fifth one-cycle README↔source arc closure). **§five-cycles-with-named-one-cycle-README-source-arc** (323→324 + 325→326 + 326→327 + 328→329 + 331→332). **§forty-one-citation-arc-closures-in-pivot-now** (35 + 6).

## §the-named-three-sentinel-set-discipline

Lines 29-44 define **three module-scope sentinels** for the method-defense protocol:

```js
const RawMethodGuard = M.call().rest(M.raw()).returns(M.raw());
const REDACTED_RAW_ARG = '<redacted raw arg>';
const PassableMethodGuard = M.call().rest(M.any()).returns(M.any());
```

| Sentinel | Type | Role |
|---|---|---|
| `RawMethodGuard` | MethodGuard | No enforcement; "anything goes" escape hatch |
| `REDACTED_RAW_ARG` | string | Redaction marker for raw-arg pattern-matching |
| `PassableMethodGuard` | MethodGuard | Least non-raw enforcement (passable-only) |

**§the-named-raw-vs-passable-distinction-with-two-default-guards** — RawMethodGuard accepts *anything* (including non-passable); PassableMethodGuard requires *passable* but accepts any shape. The two represent the *minimum-enforcement* end of the enforcement spectrum.

**§the-named-string-sentinel-for-pattern-match-redaction** — REDACTED_RAW_ARG is a *human-readable* sentinel string used as a placeholder when raw arguments are excluded from pattern matching. First-explicit-observation. The string's content (`'<redacted raw arg>'`) makes it *obvious in stack traces or debug output* that the value is a redaction marker, not real data. Compare to cycle 322 exo-makers' use of WeakMap-membership-as-type-predicate (a different sentinel pattern — *absence* from a map, not *presence* of a string value).

**§the-named-three-sentinel-set-discipline** — three orthogonal sentinels at module scope, each serving a distinct role in the method-defense protocol. First-explicit-observation as a recurring pattern for protocol vocabulary.

## §the-named-zero-copy-when-possible-discipline

Lines 52-94 (`defendSyncArgs`) implement a **zero-copy-when-possible** discipline for the matchable-args construction:

```js
// Use syncArgs if possible, but copy it when necessary to implement redactions.
let matchableArgs = syncArgs;
if (restArgGuardIsRaw && syncArgs.length > declaredLen) {
  // copy + redact
  ...
} else if (redactedIndices.length > 0 && redactedIndices[0] < syncArgs.length) {
  // copy the array, avoiding hardening the redacted ones
  matchableArgs = [...syncArgs];
}
```

The function tries to **reuse the original syncArgs array** if no redaction is needed; only copies when redaction must happen. **§the-named-zero-copy-when-possible-discipline** — first-explicit-observation as a performance discipline. The cost of a copy is paid only when necessary.

**§the-named-avoiding-hardening-the-redacted-ones** (line 72-73 comment) — *"avoiding hardening the redacted ones (which are trivially matched using REDACTED_RAW_ARG as a sentinel value)"*. The redacted slot is replaced by the sentinel *before* `harden()` is called; this avoids freezing the original value through the wrapped array. **§the-named-redact-before-harden-discipline** — first-explicit-observation.

## §the-named-Reflect-destructure-grows-with-adoption

Line 26: `const { apply, ownKeys } = Reflect;`

Compare to:
- Cycle 314 hex encode.js: `const { apply } = Reflect;` (one name)
- Cycle 318 hex decode.js: `const { apply } = Reflect;` (same one name)
- **Cycle 332 exo-tools.js**: `const { apply, ownKeys } = Reflect;` (two names)

**§three-cycles-with-named-Reflect-destructure-at-module-load** (314 + 318 + 332). The discipline grows with adoption: more files use it; some files destructure more names. **§the-named-Reflect-destructure-grows-with-adoption** — first-explicit-observation as a pivot-spanning discipline that scales by adoption rate.

## Other key moves (complementary to cycle 118's two sections)

- **§the-named-PassableMethodGuard-IS-named-implied-by-all-non-raw-guards** (line 40-43 comment) — *"This is the least possible non-raw enforcement for a method guard, and is implied by all other non-raw method guards."* PassableMethodGuard is the **bottom** of the non-raw enforcement lattice. First-explicit-observation.

- **§the-named-import-from-common-not-patterns-IS-named-canonical-after-deprecation** — exo-tools.js demonstrates the canonical post-deprecation import path; cycle 326's @deprecated re-exports remain for backward compatibility but the canonical path is the direct import. §the-named-canonical-path-vs-backward-compatibility-path-distinction.

- **§the-named-eight-named-imports-from-patterns** — exo-tools.js imports eight names from @endo/patterns (mustMatch + M + isAwaitArgGuard + isRawGuard + getAwaitArgGuardPayload + getMethodGuardPayload + getInterfaceGuardPayload + getCopyMapEntries). The eight names span four different categorical groups: assertion (mustMatch) + builder (M) + predicates (isAwait/isRaw) + extractors (getAwait/getMethod/getInterface/getCopyMap). **§the-named-multi-categorical-import-from-one-package** — first-explicit-observation.

- **§the-named-three-names-from-pass-style** (line 3) — `getRemotableMethodNames`, `toThrowable`, `Far` — three orthogonal names from pass-style: introspection + error-handling + remotable-creation. First-explicit-observation as a *narrow-import-vs-broad-import* example (cycle 325 pass-style README named `Far` + `passStyleOf` + `passableSymbolForName` as the canonical surface; exo-tools uses three but not all).

- **§the-named-only-one-local-import** — `import { GET_INTERFACE_GUARD } from './get-interface.js';` is the *only* local import (line 17). Compare to cycle 322 exo-makers.js which had one local import (defendPrototype + defendPrototypeKit from exo-tools.js). exo-tools is the *bottom* of the exo internal layer; it doesn't import from other exo files except get-interface.js (a tiny 28-line constant file from cycle 239). **§the-named-substrate-file-has-minimal-local-imports** — first-explicit-observation.

## Patterns the cycle extends

- §twenty-three-cycles-with-named-pivot-domain-stay (310-332)
- §four-cycles-with-named-complementary-lens-re-ingest (322 exo-makers + 324 atomics + 330 smallcaps + 332 exo-tools) — librarian discipline confirmed across four applications
- §five-cycles-with-named-one-cycle-README-source-arc (323→324 + 325→326 + 326→327 + 328→329 + 331→332)
- §forty-one-citation-arc-closures-in-pivot-now (35 + 6)
- §three-cycles-with-named-Reflect-destructure-at-module-load (314 + 318 + 332)
- §two-cycles-with-named-fan-out-import-graph-from-exo (322 + 332)
- §the-named-citation-arc-from-cycle-118-self-takes-214-cycles-to-close (matches cycle 322's 214-cycle exo-makers self-arc; second-equal-longest self-arc)

## Tier-1 borrowing (twenty-plus first-explicit-observations)

All §-tags above marked first-explicit-observation. Highest-portability:

- **§the-named-deprecation-pointers-followed-in-practice** — the discipline that deprecation pointers are *honored* by sibling code, not just documented
- **§the-named-deprecation-as-soft-contract-with-followed-pointer**
- **§the-named-internal-consumers-follow-deprecation-pointers**
- **§the-named-three-sentinel-set-discipline** (RawMethodGuard + REDACTED_RAW_ARG + PassableMethodGuard)
- **§the-named-string-sentinel-for-pattern-match-redaction** (human-readable sentinel string visible in debug output)
- **§the-named-zero-copy-when-possible-discipline** + **§the-named-redact-before-harden-discipline**
- **§the-named-Reflect-destructure-grows-with-adoption**
- **§the-named-multi-categorical-import-from-one-package**
- **§the-named-substrate-file-has-minimal-local-imports**

## Tier-2 borrowing (multi-cycle patterns extended)

- §twenty-three-cycles-with-named-pivot-domain-stay
- §four-cycles-with-named-complementary-lens-re-ingest (322 + 324 + 330 + 332)
- §five-cycles-with-named-one-cycle-README-source-arc
- §forty-one-citation-arc-closures-in-pivot-now
- §three-cycles-with-named-Reflect-destructure-at-module-load (314 + 318 + 332)
- §two-cycles-with-named-fan-out-import-graph-from-exo (322 + 332)
- §the-named-citation-arc-from-cycle-118-self-takes-214-cycles-to-close

## Tier-3 borrowing (meta-patterns)

- **§the-named-deprecation-as-soft-contract-with-followed-pointer** — when a deprecation tag points to a canonical location, sibling code SHOULD use that location; the deprecation tag is a soft contract honored by internal consumers
- **§the-named-canonical-path-vs-backward-compatibility-path-distinction** — the deprecated re-export remains for external consumers; the canonical direct-import is for internal consumers; the two paths coexist
- **§the-named-three-sentinel-set-discipline** — three orthogonal sentinels at module scope for protocol vocabulary
- **§the-named-zero-copy-when-possible-discipline** — pay copy cost only when necessary; check the cheap condition first
- **§the-named-Reflect-destructure-grows-with-adoption** — substrate disciplines scale by *how many files adopt them* and *how aggressively each file uses them*
- **§the-named-substrate-file-has-minimal-local-imports** — the bottom-most file in a module's local dependency graph imports almost nothing locally

## Synthesis-target

Slot machine library **§`@game/exo/src/exo-tools.js`** — method-defense substrate:

1. **Follow deprecation pointers in practice** — if the project deprecates a re-export, sibling code in the same family imports from the canonical location directly.
2. **Three-sentinel set** at module scope for protocol vocabulary (e.g., GameRawMethodGuard + GAME_REDACTED_ARG + GamePassableMethodGuard).
3. **Zero-copy-when-possible discipline** — check the cheap condition first; copy only when necessary.
4. **Redact before harden** — replace sensitive slots with sentinels *before* calling harden, so the original values stay unfrozen.
5. **Reflect destructure** at module load for tamper resistance; expand the destructure as the file's needs grow.
6. **Multi-categorical import from one package** — when a package's API has multiple functional categories, name them deliberately at import time.
7. **Substrate file has minimal local imports** — the bottom-most file imports almost nothing local; it depends only on language primitives and same-org packages.
8. **Canonical-path-vs-backward-compatibility-path distinction** — internal consumers use canonical paths; external consumers use the deprecated-but-still-working surface.

## Library state after cycle 332

- §library-reaches-844-sections from 378 source documents (source count unchanged because exo-tools was already counted from cycle 118)
- §one-hundred-and-sixty-fifth consecutive designs-chat alternation
- §twenty-three-cycles-with-named-pivot-domain-stay
- §eleven-named-packages-in-the-pivot-cluster
- §forty-one-citation-arc-closures-in-pivot-now (35 + 6)
- §four-cycles-with-named-complementary-lens-re-ingest (librarian discipline confirmed across four applications)
- §five-cycles-with-named-one-cycle-README-source-arc (dense pair-landing discipline across five applications)
