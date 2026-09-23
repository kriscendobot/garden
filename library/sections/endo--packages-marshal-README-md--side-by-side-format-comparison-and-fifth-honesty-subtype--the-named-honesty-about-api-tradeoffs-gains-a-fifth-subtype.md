---
title: §the-named-honesty-about-API-tradeoffs gains a fifth subtype
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

**§the-named-honesty-about-API-tradeoffs** now has **five named subtypes**:

| Subtype | Cycle | Phrase |
|---|---|---|
| Low-utility-paths | 321 | "Most users don't need this" |
| Relaxed-security-models | 323 | "Not for mutually-suspicious parties" |
| Functionality-elsewhere | 325 | "For validation, see @endo/exo" |
| Documentation-language-cannot-express | 326 | "JSDoc cannot express these" |
| **Functionality-not-supported-at-all** | **329** | **"The marshal-based alternatives do not"** (no replacer/reviver) |

**§five-cycles-with-named-honesty-about-API-tradeoffs** (321 + 323 + 325 + 326 + 329) — the parameterized meta-pattern now spans five cycles with five distinct subtypes. The marshal stringify/parse pair documents what it deliberately *doesn't* provide that JSON.stringify/parse does: *"The JSON functions have parameters for customizing serialization and deserialization, for example with a *replacer* or *reviver*. The marshal-based alternatives do not."*

**§the-named-functionality-not-supported-at-all-subtype** — different from cycle 325's *functionality-elsewhere* because the missing functionality isn't available in any sibling package; the package simply chose not to include it. First-explicit-observation.
