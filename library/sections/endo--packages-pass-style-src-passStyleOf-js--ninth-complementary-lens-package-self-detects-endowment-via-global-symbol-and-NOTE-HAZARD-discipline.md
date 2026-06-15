---
title: "@endo/pass-style src/passStyleOf.js — ninth complementary-lens; package-self-detects-endowment-via-global-symbol; NOTE HAZARD discipline; isFrozen-check-at-the-evolution-points; closes 279-cycle arc to cycle 71"
source: endo--packages-pass-style-src-passStyleOf-js
url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/passStyleOf.js
authors: [Mark S. Miller, Kris Kowal, Endo project (collective)]
repo: endojs/endo
path: packages/pass-style/src/passStyleOf.js
total-lines: 405
ingest-cycle: 350
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-package-self-detects-endowment-via-global-symbol
  - the-named-PassStyleOfEndowmentSymbol-as-canonical-name
  - the-named-NOTE-HAZARD-comment-discipline
  - the-named-liveslots-as-canonical-endower
  - the-named-isFrozen-check-at-the-evolution-points
  - the-named-TypedArrays-get-special-treatment-error-distinction
  - the-named-confirmCanBeValid-then-assertRestValid-two-phase-validation
  - the-named-helper-table-with-assertions-on-table-construction
  - the-named-defensive-init-pattern-for-registries
  - the-named-PASS_STYLE-as-well-known-tag-symbol
  - the-named-complementary-lens-re-ingest
  - nine-cycles-with-named-complementary-lens-re-ingest
  - the-named-citation-arc-from-cycle-71-takes-279-cycles-to-close
  - forty-one-cycles-with-named-pivot-domain-stay
  - one-hundred-forty-two-citation-arc-closures-in-pivot-now
---

# `@endo/pass-style src/passStyleOf.js` — ninth complementary-lens; package self-detects endowment via global symbol

The 405-line canonical pass-style discriminator. Cycle 350 is **chat-lane after cycle 349's designs-lane @endo/ses docs/preparing-for-stabilize.md** — cross-package (ses/docs → pass-style/src). **§forty-one-cycles-with-named-pivot-domain-stay** (310-350).

**§nine-cycles-with-named-complementary-lens-re-ingest** (322 + 324 + 330 + 332 + 336 + 342 + 344 + 348 + **350**) — the librarian discipline now spans **NINE applications**.

**Note on prior ingest**: Cycle 71 ingested passStyleOf.js as the canonical pass-style discriminator surface. Cycle 350's complementary lens emphasizes the **endowment-symbol pattern + NOTE HAZARD discipline + isFrozen-check-at-the-evolution-points** that cycle 349's *preparing-for-stabilize.md* foreshadowed.

## The single most structurally interesting move

**§the-named-package-self-detects-endowment-via-global-symbol** — lines 219 + 236-238:

```js
export const PassStyleOfEndowmentSymbol = Symbol.for('@endo passStyleOf');

export const passStyleOf =
  (globalThis && globalThis[PassStyleOfEndowmentSymbol]) ||
  makePassStyleOf([...]);
```

The package EXPORTS an endowment symbol and CHECKS if a host has installed a custom implementation at that symbol on globalThis. If yes, use the host's; if no, build the default.

**§the-named-package-self-detects-endowment-via-global-symbol** — first-explicit-observation as a tier-3 meta-pattern. The discipline:
1. Define a `Symbol.for('@org name')` as the endowment point
2. Export the symbol so hosts can write to globalThis at that key
3. At module load, check globalThis[symbol] first; fall through to default if absent

**§the-named-PassStyleOfEndowmentSymbol-as-canonical-name** — first-explicit-observation. The symbol's name encodes the package identity (`@endo passStyleOf`).

## §the-named-NOTE-HAZARD-comment-discipline

Lines 222-233 contain a structured comment block:

> If there is already a PassStyleOfEndowmentSymbol property on the global, then presumably it was endowed for us by liveslots with a `passStyleOf` function, so we should use and export that one instead.
> Other software may have left it for us here, but it would require write access to our global, or the ability to provide endowments to our global, both of which seems adequate as a test of whether it is authorized to serve the same role as liveslots.
>
> **NOTE HAZARD**: This use by liveslots does rely on `passStyleOf` being deterministic. If it is not, then in a liveslot-like virtualized environment, it can be used to detect GC.

**§the-named-NOTE-HAZARD-comment-discipline** — first-explicit-observation as a tier-3 meta-pattern. The comment NAMES a specific HAZARD that arises from the discipline:
- The **hazard**: non-determinism in passStyleOf can be a GC-detection side-channel
- The **dependency**: liveslots' use relies on determinism
- The **environment**: liveslot-like virtualized environments

Compare to cycle 342 @endo/lockdown/pre.js's NOTE-TO-REVIEWERS-pattern (merge-defense for commented-out options); cycle 350's NOTE-HAZARD is a DIFFERENT shape — it warns the IMPLEMENTOR/MAINTAINER about a property they must preserve (determinism) for safety in a downstream context.

**§two-shapes-of-NOTE-prefix-comment** (cycle 342 NOTE-TO-REVIEWERS-merge-defense + cycle 350 NOTE-HAZARD-determinism-dependency) — first-explicit-observation as a tier-2 multi-cycle pattern.

**§the-named-liveslots-as-canonical-endower** — first-explicit-observation. The comment names **liveslots** as the canonical user of the endowment slot. Liveslots is Agoric's vat-runtime; this passStyleOf interface is one of the integration points.

**§the-named-authorization-via-write-access-to-global** — first-explicit-observation. The comment names the AUTHORIZATION model: *"would require write access to our global, or the ability to provide endowments to our global, both of which seems adequate as a test of whether it is authorized"*. The implicit-authorization-via-capability-of-write-access discipline.

## §the-named-isFrozen-check-at-the-evolution-points

Lines 167 and 201 are the TWO POINTS where passStyleOf currently checks `isFrozen`:

```js
// Line 167 (object case):
if (!isFrozen(inner)) {
  assert.fail(
    isTypedArray(inner)
      ? X`Cannot pass mutable typed arrays like ${inner}.`
      : X`Cannot pass non-frozen objects like ${inner}. Use harden()`,
  );
}

// Line 201 (function case):
isFrozen(inner) ||
  Fail`Cannot pass non-frozen objects like ${inner}. Use harden()`;
```

**§the-named-isFrozen-check-at-the-evolution-points** — first-explicit-observation. Cycle 349's preparing-for-stabilize.md said: *"`passStyleOf` instead checked that each relevant object is frozen... With these changes, even such manual transitive freezing will not make an object passable."* Cycle 350 reveals the **two specific lines** where the change will land — line 167 (objects) and line 201 (functions).

**§the-named-known-future-change-site-named-at-implementation-level** — first-explicit-observation. Cycle 349's design-doc cycle 350's source-level evolution-point identification. Tier-3 framing: when a future change is described at the design level, identifying the SPECIFIC SOURCE LINES that will change is the implementation-level closure.

**§the-named-TypedArrays-get-special-treatment-error-distinction** — first-explicit-observation. Line 169-172 distinguishes the error message: TypedArrays get *"Cannot pass mutable typed arrays like X"* while other non-frozen objects get *"Cannot pass non-frozen objects like X. Use harden()"*. The error message tells the caller WHY harden() won't help (TypedArrays have special treatment in harden()).

**§the-named-error-message-discriminates-by-failure-cause** — first-explicit-observation as a tier-3 meta-pattern. When the same predicate fails for two different structural reasons, the error message should DISCRIMINATE the reason so the caller knows the appropriate remedy.

## §the-named-helper-table-with-assertions-on-table-construction

Lines 46-69 — `makeHelperTable`:

```js
const makeHelperTable = passStyleHelpers => {
  const HelperTable = {
    __proto__: null,
    copyArray: undefined,
    byteArray: undefined,
    copyRecord: undefined,
    tagged: undefined,
    error: undefined,
    remotable: undefined,
  };
  for (const helper of passStyleHelpers) {
    const { styleName } = helper;
    styleName in HelperTable || Fail`Unrecognized helper: ${q(styleName)}`;
    HelperTable[styleName] === undefined ||
      Fail`conflicting helpers for ${q(styleName)}`;
    HelperTable[styleName] = helper;
  }
  for (const styleName of ownKeys(HelperTable)) {
    HelperTable[styleName] !== undefined ||
      Fail`missing helper for ${q(styleName)}`;
  }
  return harden(HelperTable);
};
```

**§the-named-helper-table-with-assertions-on-table-construction** — first-explicit-observation. The table construction asserts THREE invariants:
1. **No unknown helpers**: every helper's styleName must be in the expected set
2. **No duplicates**: no two helpers can claim the same styleName
3. **No missing**: every expected styleName must have a helper

**§the-named-defensive-init-pattern-for-registries** — first-explicit-observation as a tier-3 meta-pattern. When a module's correctness depends on a registry being complete and unambiguous, the init code should ASSERT all invariants at construction time.

**§the-named-null-prototype-table** — first-explicit-observation. `{ __proto__: null }` creates an object with no prototype chain — defends against Object.prototype pollution. Each named entry is pre-declared as `undefined` so the `in` check is sound.

## §the-named-confirmCanBeValid-then-assertRestValid-two-phase-validation

The helpers implement a two-phase validation:
- `helper.confirmCanBeValid(inner, reject)` — checks structural applicability (silent or throwing depending on `reject`)
- `helper.assertRestValid(inner, passStyleOfRecur)` — checks the remaining requirements

```js
for (const helper of passStyleHelpers) {
  if (helper.confirmCanBeValid(inner, false)) {
    helper.assertRestValid(inner, passStyleOfRecur);
    return helper.styleName;
  }
}
```

**§the-named-confirmCanBeValid-then-assertRestValid-two-phase-validation** — first-explicit-observation. The discipline:
1. **Phase 1**: silent check whether the helper APPLIES to this candidate
2. **Phase 2**: assert the REMAINING requirements (throws on failure)

If phase 1 returns false, try the next helper. If phase 2 throws, the entire passStyleOf throws (no fallback).

**§the-named-two-phase-validation-with-silent-applicability-then-throwing-completeness** — first-explicit-observation as a tier-3 meta-pattern. Sibling to cycle 102 @endo/patterns/checkKey.js's §the-named-trio-pattern (Confirm/Is/Assert); cycle 350's two-phase pattern is the DISPATCH version where the question is "which helper applies?".

## §the-named-PASS_STYLE-as-well-known-tag-symbol

Line 182: `const passStyleTag = inner[PASS_STYLE];`

The PASS_STYLE symbol (imported from `./passStyle-helpers.js`) is the canonical TAG marker on objects that have explicitly declared their pass-style. The object can carry its own tag.

**§the-named-PASS_STYLE-as-well-known-tag-symbol** — first-explicit-observation. Compare to cycle 337 @endo/harden's `Object[Symbol.for('harden')]` (intrinsic-over-endowment); cycle 350's PASS_STYLE is the OBJECT-LEVEL counterpart (per-object tag rather than per-realm intrinsic).

**§two-shapes-of-symbol-coordination** (cycle 337 intrinsic-symbol + cycle 350 per-object-symbol) — first-explicit-observation as a tier-3 meta-pattern. Symbols serve as coordination points at different scopes:
- **Intrinsic scope**: `Object[Symbol.for('harden')]` — one well-known symbol on Object
- **Per-object scope**: `obj[PASS_STYLE]` — a well-known symbol that any object can carry
- **Endowment scope (cycle 350)**: `globalThis[PassStyleOfEndowmentSymbol]` — global-level override point

**§three-shapes-of-symbol-coordination** (intrinsic + per-object + endowment) — first-explicit-observation as a tier-3 meta-pattern.

## Closes citation arcs

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 349 (@endo/ses docs/preparing-for-stabilize.md) | 1 cycle | Cross-package §the-named-isFrozen-check-at-the-evolution-points |
| **Cycle 71 (passStyleOf.js first ingest)** | **279 cycles** | **NINTH complementary-lens re-ingest; new pivot-record longest arc** (previous record: 261 from cycle 69 → 330) |
| Cycle 87 (pass-style/error.js) | 263 cycles | Sibling pass-style file; error handling |
| Cycle 102 (patterns/checkKey.js Rejector trio) | 248 cycles | §two-phase-validation sibling to trio pattern |
| Cycle 322 (exo-makers complementary-lens) | 28 cycles | §state-sealed-not-frozen hardening discipline |
| Cycle 337 (@endo/harden README) | 13 cycles | §two-shapes-of-symbol-coordination |
| Cycle 342 (@endo/lockdown pre.js NOTE-TO-REVIEWERS) | 8 cycles | §two-shapes-of-NOTE-prefix-comment |

**§seven-citation-arc-closures-in-cycle-350**. **§one-hundred-forty-two-citation-arc-closures-in-pivot-now** (135 + 7 net new).

**§the-named-NEW-LONGEST-PIVOT-ARC-at-279-cycles** — first-explicit-observation. The cycle 71 → 350 arc at **279 cycles** surpasses the previous record (261 cycles from cycle 69 → 330). The pivot's citation-arc-distance record is now 279 cycles.

## Patterns the cycle extends

- §forty-one-cycles-with-named-pivot-domain-stay (310-350)
- §nineteen-named-packages-in-the-pivot-cluster
- §one-hundred-forty-two-citation-arc-closures-in-pivot-now (135 + 7 net new)
- **§nine-cycles-with-named-complementary-lens-re-ingest** (322 + 324 + 330 + 332 + 336 + 342 + 344 + 348 + 350)
- §two-shapes-of-NOTE-prefix-comment (342 + 350)
- §three-shapes-of-symbol-coordination (intrinsic + per-object + endowment)
- §the-named-NEW-LONGEST-PIVOT-ARC-at-279-cycles

## Tier-1 borrowing (twelve-plus first-explicit-observations)

- **§the-named-package-self-detects-endowment-via-global-symbol**
- **§the-named-PassStyleOfEndowmentSymbol-as-canonical-name**
- **§the-named-NOTE-HAZARD-comment-discipline**
- **§the-named-liveslots-as-canonical-endower**
- **§the-named-authorization-via-write-access-to-global**
- **§the-named-isFrozen-check-at-the-evolution-points**
- **§the-named-known-future-change-site-named-at-implementation-level**
- **§the-named-TypedArrays-get-special-treatment-error-distinction**
- **§the-named-error-message-discriminates-by-failure-cause**
- **§the-named-helper-table-with-assertions-on-table-construction**
- **§the-named-defensive-init-pattern-for-registries**
- **§the-named-null-prototype-table**
- **§the-named-confirmCanBeValid-then-assertRestValid-two-phase-validation**
- **§the-named-two-phase-validation-with-silent-applicability-then-throwing-completeness**
- **§the-named-PASS_STYLE-as-well-known-tag-symbol**
- **§two-shapes-of-symbol-coordination** → **§three-shapes-of-symbol-coordination**
- **§the-named-NEW-LONGEST-PIVOT-ARC-at-279-cycles**

## Tier-3 borrowing (meta-patterns)

- **§the-named-package-self-detects-endowment-via-global-symbol** — substrate packages can support being overridden at runtime via a global endowment symbol
- **§the-named-NOTE-HAZARD-comment-discipline** — when an implementation relies on a property (like determinism), name the hazard if it's not preserved
- **§the-named-error-message-discriminates-by-failure-cause** — when same predicate fails for different reasons, error message names the reason
- **§the-named-defensive-init-pattern-for-registries** — assert table invariants at construction
- **§the-named-two-phase-validation-with-silent-applicability-then-throwing-completeness**
- **§three-shapes-of-symbol-coordination** — intrinsic + per-object + endowment scopes
- **§the-named-known-future-change-site-named-at-implementation-level** — design-doc + source pair identifies specific lines that will evolve

## Synthesis-target

Slot machine library **§`@game/pass-style/src/passStyleOf.js`** — canonical type discriminator:

1. **Package self-detects endowment via global symbol** for runtime override
2. **NOTE HAZARD comment discipline** — name properties the impl relies on
3. **Defensive init pattern for registries** — assert all invariants at table construction
4. **Two-phase validation** — silent applicability + throwing completeness
5. **Error message discriminates by failure cause** — name WHY the predicate failed
6. **Three shapes of symbol coordination** — intrinsic + per-object + endowment

## Library state after cycle 350

- §library-reaches-862-sections from 393 source documents (source count unchanged; complementary-lens re-ingest)
- §one-hundred-and-eighty-third consecutive designs-chat alternation
- §forty-one-cycles-with-named-pivot-domain-stay (310-350)
- §nineteen-named-packages-in-the-pivot-cluster
- §one-hundred-forty-two-citation-arc-closures-in-pivot-now (135 + 7 net new)
- **§nine-cycles-with-named-complementary-lens-re-ingest** — librarian discipline confirmed across NINE applications
- **§the-named-NEW-LONGEST-PIVOT-ARC-at-279-cycles** (cycle 71 → 350)
- §the-named-package-self-detects-endowment-via-global-symbol established as tier-3 meta-pattern
- §the-named-NOTE-HAZARD-comment-discipline established as tier-3 meta-pattern
- §the-named-defensive-init-pattern-for-registries established as tier-3 meta-pattern
- §the-named-two-phase-validation-with-silent-applicability-then-throwing-completeness established as tier-3 meta-pattern
- §three-shapes-of-symbol-coordination established as tier-3 meta-pattern
- §the-named-known-future-change-site-named-at-implementation-level established as tier-3 meta-pattern
