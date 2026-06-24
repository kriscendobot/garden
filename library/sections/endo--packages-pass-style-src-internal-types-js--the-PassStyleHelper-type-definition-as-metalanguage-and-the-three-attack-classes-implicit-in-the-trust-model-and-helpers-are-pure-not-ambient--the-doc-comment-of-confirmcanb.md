---
title: §The doc comment of `confirmCanBeValid` is itself a §two-phase-protocol-documentation
source-slug: endo--packages-pass-style-src-internal-types-js
section-slug: the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/internal-types.js
source-repo: endojs/endo
source-path: packages/pass-style/src/internal-types.js
source-author: Endo project (collective)
total-lines: 30
ingest-cycle: 266
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-internal-types-js--the-PassStyleHelper-type-definition-as-metalanguage-and-the-three-attack-classes-implicit-in-the-trust-model-and-helpers-are-pure-not-ambient
---

The property description for `confirmCanBeValid` (lines 22-25) is **multi-paragraph**, even though property descriptions in JSDoc are conventionally single-line. The author chose to use multi-line JSDoc property descriptions to encode the §two-phase-protocol — §the-typedef-DOCUMENTS-the-cluster-invariant-in-the-property-description.

§First-explicit-observation in library: **§multi-paragraph-JSDoc-property-descriptions-encode-protocol-invariants-as-named-discipline — §when-the-property's-shape-isn't-enough-to-encode-the-invariant, §use-multi-paragraph-prose-in-the-`@property`-description**.

§Sibling-pattern to cycle 265's CLAUDE.md spec — both files use prose to encode invariants the structure can't express. §two-cycles-with-prose-encoded-invariants-where-structure-cannot-express (265 design-doc-template + 266 PassStyleHelper-mutual-exclusivity).
