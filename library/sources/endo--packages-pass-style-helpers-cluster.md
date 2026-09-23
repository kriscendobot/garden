---
title: "@endo/pass-style helpers cluster (byteArray + copyArray + copyRecord + tagged + iter-helpers + string + makeTagged) — uniform PassStyleHelper shape across pass-style kinds"
source-slug: endo--packages-pass-style-helpers-cluster
url: https://github.com/endojs/endo/tree/master/packages/pass-style/src
authors: [Endo contributors]
repo: endojs/endo
path: packages/pass-style/src/{byteArray.js, copyArray.js, copyRecord.js, tagged.js, iter-helpers.js, string.js, makeTagged.js}
total-lines: 399 (38 copyArray + 49 tagged + 60 iter-helpers + 68 byteArray + 70 copyRecord + 83 string + 31 makeTagged)
status: shipping
ingest-cycle: 227
ingest-date: 2026-06-08
lane: chat
---

# @endo/pass-style helpers cluster

§Seven-file-cluster in `packages/pass-style/src/`. §Code-file-cluster-with-uniform-shape, parallel to cycle 226's design-document-cluster.

## Key design moves

- **§PassStyleHelper uniform shape** across four helpers (byteArray + copyArray + copyRecord + tagged): styleName + confirmCanBeValid + assertRestValid.
- **§Two-phase-validation** — cheap discriminator (`confirmCanBeValid`) + deep well-formedness (`assertRestValid`).
- **§Rejector-typedef-from-cycle-217** used consistently across all four helpers.
- **§rest-spread-collects-everything-not-named** (tagged.js) — destructure known properties + rest-spread + assert-rest-is-empty.
- **§Length-vs-ownKeys-check** (copyArray.js) — §invariant-on-own-keys-count.
- **§adapt-feature-detection** (byteArray.js) — feature-detection-returns-bindings-that-deny-when-the-feature-is-missing (sibling to cycle 215's ponyfill-with-load-time-dispatch).
- **§Reflect.apply-as-the-defensive-uncurry** — fifth instance in library (cycles 199 + 207 + 211 + 215 + 227).
- **§don't-coerce-input** (string.js) — pre-typeof-check before platform method; cites the `isNaN` precedent.
- **§env-option-gated-strictness** (`ONLY_WELL_FORMED_STRINGS_PASSABLE`) with §named-three-phase-plan (disabled → enabled → switch-removed).
- **§Lazy-iterator-utility-that-returns-Far-wrapped-objects** (iter-helpers.js mapIterable / filterIterable).
- **§The-completion-value-is-passed-through-not-transformed** in mapIterable.
- **§Pair-the-constructor-with-the-validator** in adjacent files (makeTagged.js + tagged.js).

## Section files

- [§PassStyleHelper uniform shape + §two-phase-validation + §rest-spread-collects-everything-not-named](../sections/endo--packages-pass-style-helpers-cluster--PassStyleHelper-uniform-shape-and-two-phase-validation-and-styleName-confirmCanBeValid-assertRestValid-and-rest-spread-collects-everything-not-named.md) — full cluster ingest.

## Ingest scope

Cycle 227 (chat-lane): §cluster-ingest-as-one-section of seven sibling files in `packages/pass-style/src/`. §Third-code-file-cluster in library (cycles 199 + 211 + 227); §parallel-shape to cycle 226's design-document-cluster.
