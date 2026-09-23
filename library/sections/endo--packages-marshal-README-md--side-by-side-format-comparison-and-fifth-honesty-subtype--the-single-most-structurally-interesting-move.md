---
title: The single most structurally interesting move
source: endo--packages-marshal-README-md
url: https://github.com/endojs/endo/blob/master/packages/marshal/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/marshal/README.md
total-lines: 188
ingest-cycle: 329
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-side-by-side-format-comparison-discipline
  - the-named-marshalling-IS-named-conversion-of-structured-data
  - the-named-capability-bearing-data-IS-named-special-data
  - the-named-slot-identifier-as-named-indirection-mechanism
  - the-named-CapData-structure-IS-named-body-plus-slots
  - the-named-parameterized-with-two-functions-discipline
  - the-named-convertValToSlot-and-convertSlotToVal-named-pair
  - the-named-side-table-pattern
  - the-named-makePassableKit-as-alternative-API
  - the-named-legacyOrdered-vs-compactOrdered
  - the-named-PR-citation-for-historical-context
  - the-named-format-variation-with-named-historical-default
  - the-named-rejected-mixed-objects
  - the-named-Empty-Objects-are-pass-by-copy-with-Far-as-alternative
  - the-named-Far-IS-named-empty-marker-for-identity-comparison
  - the-named-rights-amplification-IS-named-canonical-pattern
  - the-named-more-tolerant-and-less-tolerant-IS-named-symmetric-comparison-discipline
  - the-named-explicit-error-vs-silent-omission-discipline
  - the-named-no-replacer-or-reviver-customization
  - the-named-honesty-about-API-tradeoffs-gains-fifth-subtype
  - the-named-functionality-not-supported-at-all-subtype
  - the-named-stringify-vs-toCapData-with-no-slots
  - the-named-intra-document-cross-section-anchoring
  - twenty-cycles-with-named-pivot-domain-stay
  - twenty-five-citation-arc-closures-in-pivot-now
  - four-cycles-with-named-one-cycle-README-source-arc
  - five-cycles-with-named-honesty-about-API-tradeoffs
parent: endo--packages-marshal-README-md--side-by-side-format-comparison-and-fifth-honesty-subtype
---

**§the-named-side-by-side-format-comparison-discipline** — the "Beyond JSON" section (line 69-89) shows the SAME input encoded in *both* formats side-by-side:

```js
// Smallcaps encoding.
const m1 = makeMarshal(undefined, undefined, { serializeBodyFormat: 'smallcaps' });
console.log(m1.toCapData(NaN));
// { body: '#"#NaN"', slots: [] }

// Original encoding.
const m2 = makeMarshal();
console.log(m2.toCapData(NaN));
// { body: '{"@qclass":"NaN"}', slots: [] }
```

The reader sees *both* the compact-prefix smallcaps format AND the verbose `@qclass` original format for the *same* NaN input. **§the-named-side-by-side-format-comparison-discipline** — first-explicit-observation. The pedagogical move makes the format-evolution narrative concrete: cycle 328's source-side §the-named-CapData-vs-smallcaps-format-evolution is now visible at the README level as *two outputs for one input*.

Sibling to cycle 327's @endo/patterns README's three Why-X sections (which compared chosen design vs natural alternative); here the comparison is between two equally-supported alternatives within the same package. **§the-named-comparison-by-side-by-side-output** as a documentation discipline.
