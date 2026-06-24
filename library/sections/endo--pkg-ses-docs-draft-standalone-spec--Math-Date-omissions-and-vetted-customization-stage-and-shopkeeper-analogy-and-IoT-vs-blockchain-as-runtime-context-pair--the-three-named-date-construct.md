---
title: §the-three-named-Date-constructor-variants-all-block (first-explicit-observation)
section-slug: endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair
source-slug: endo--pkg-ses-docs-draft-standalone-spec
url: https://github.com/endojs/endo/blob/master/packages/ses/docs/draft-standalone-spec.md
authors: [Mark S. Miller (et al.)]
repo: endojs/endo
path: packages/ses/docs/draft-standalone-spec.md
total-lines: 201
ingest-cycle: 291
ingest-date: 2026-06-11
lane: designs
scope: full
parent: endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair
---

The spec names **three named ways the Date constructor can be invoked** + **a defense for each**:

1. `Date.now()` → throws TypeError
2. `new Date()` (no arguments) → throws TypeError
3. `Date(...)` (called without `new`) → throws TypeError

**§the-exhaustive-named-attack-surface enumeration**: the doc doesn't just say "block Date"; it enumerates *each invocation form* and says "this also throws". §the-defense-IS-exhaustive-only-when-the-attack-surface-IS-enumerated.

§the-named-three-named-call-shapes-for-the-same-constructor: function call + constructor call + static method. The defense must cover all three; missing one would be a defect.
