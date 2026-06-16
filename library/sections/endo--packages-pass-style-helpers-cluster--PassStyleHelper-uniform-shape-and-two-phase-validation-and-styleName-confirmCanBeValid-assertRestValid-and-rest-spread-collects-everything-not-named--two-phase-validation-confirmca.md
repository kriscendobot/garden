---
title: §Two-phase-validation (confirmCanBeValid + assertRestValid)
source-slug: endo--packages-pass-style-helpers-cluster
section-id: PassStyleHelper-uniform-shape-and-two-phase-validation-and-styleName-confirmCanBeValid-assertRestValid-and-rest-spread-collects-everything-not-named
url: https://github.com/endojs/endo/tree/master/packages/pass-style/src
authors: [Endo contributors]
repo: endojs/endo
path: packages/pass-style/src/{byteArray.js, copyArray.js, copyRecord.js, tagged.js, iter-helpers.js, string.js, makeTagged.js}
status: shipping
ingest-cycle: 227
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-pass-style-helpers-cluster--PassStyleHelper-uniform-shape-and-two-phase-validation-and-styleName-confirmCanBeValid-assertRestValid-and-rest-spread-collects-everything-not-named
---

§The-load-bearing-architectural-move. §The-two-phases-have-different-purposes:

- §confirmCanBeValid — §the-`is-it-this-kind`-check. Cheap; returns boolean via Rejector. Called by passStyleOf to discriminate among kinds.
- §assertRestValid — §the-`is-it-well-formed`-check. May be expensive; throws on invalid. Called once passStyleOf is sure of the kind.

§Borrowable-pattern: §split-validation-into-cheap-discriminator + §deep-well-formedness. §The-cheap-check-runs-on-every-classification; §the-deep-check-runs-only-after-classification-succeeds.

§Sibling to cycle 215 @endo/hex's §two-different-shapes-for-dispatching-to-native (unconditional for encode + dispatch-with-on-failure-polyfill-rerun for decode). §Cycle 215's pattern is at the protocol layer; cycle 227's pattern is at the validation layer.

§Borrowable-pattern: §Rejector-typedef-from-cycle-217 used consistently across all four helpers — `(candidate, reject)` signature in confirmCanBeValid. §The-Rejector-trio-pattern (cycle 217) instantiated in each helper.
