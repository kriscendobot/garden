---
title: Synthesis-target
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

Slot machine library **§`@game/marshal/README.md`** — game-state marshalling between subsystems:

1. **Opening sentence defines the term** ("Marshalling refers to...")
2. **Side-by-side format comparison** — if the library has multiple wire formats, show the same input encoded in each
3. **Two-callback parameterization pair** (convertValToSlot equivalent for game-side identifiers)
4. **CapData structure named** (`{ body, slots }`); side table pattern for identifiers
5. **Frozen objects only** with named hardening function
6. **Pass-by-presence vs pass-by-copy with distinguishing criteria** + rejected-mixed-objects edge case
7. **Empty objects default with Far escape hatch** for identity-comparison use cases
8. **Rights amplification pattern** named as canonical (Far objects as WeakMap keys)
9. **More-tolerant-and-less-tolerant** symmetric comparison with JSON
10. **Throw-not-skip discipline** for unsupported input
11. **No replacer/reviver** — explicitly name functionality not supported
12. **PR link as design record** for historical default
13. **Intra-document cross-section anchoring** for related sections
14. **Default vs preferred distinction** if the default has diverged from the preferred
