---
title: Tier-3 borrowing (meta-patterns)
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

- **§the-named-side-by-side-format-comparison-discipline** — pedagogical: show the same input in both formats so the reader sees both at once
- **§the-named-honesty-about-API-tradeoffs** with five named subtypes (low-utility + relaxed-security + functionality-elsewhere + documentation-language-cannot-express + functionality-not-supported-at-all)
- **§the-named-symmetric-comparison-via-both-directions** — when comparing two alternatives, name BOTH directions of difference (more tolerant of X, less tolerant of Y)
- **§the-named-throw-not-skip-discipline** — explicit errors vs silent omission; the same data invalid in both becomes a *signal* in one and *invisible* in the other
- **§the-named-PR-link-as-design-record** — cite historical PR (#1594) for design rationale
- **§the-named-default-vs-preferred-distinction** — when the default and the preferred have diverged, acknowledge the gap rather than silently shifting
