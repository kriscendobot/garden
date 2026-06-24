---
title: Other key moves
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

- **§the-named-marshalling-IS-named-conversion-of-structured-data** (line 3-4) — opening sentence defines the term: *"Marshalling refers to the conversion of structured data (a tree or graph of objects) into a string, and back again."* §the-named-define-the-term-first-discipline.

- **§the-named-capability-bearing-data-IS-named-special-data** (line 6-9) — marshal specializes in *"capability-bearing data"* (vs generic JSON). The capability vocabulary names the package's distinctive scope.

- **§the-named-slot-identifier-as-named-indirection-mechanism** + **§the-named-CapData-structure-IS-named-body-plus-slots** — `{ body: '...', slots: [...] }` is the canonical CapData format. The README *defines* what cycle 328's encodeToCapData.js produces. §the-named-side-table-pattern (slots array as side table outside the body string).

- **§the-named-parameterized-with-two-functions-discipline** — `convertValToSlot` + `convertSlotToVal` is the host-environment-binding pair. **§the-named-convertValToSlot-and-convertSlotToVal-named-pair** — symmetric callback pair (encoder/decoder). §the-named-each-callback-defaults-to-identity-function (line 25-26).

- **§the-named-makePassableKit-as-alternative-API** (line 44-62) — a *second* exported factory for direct-serialization format (string comparison corresponds with value comparison). Different from the `makeMarshal` slot-based API. Closes citation arc with cycle 81 encodePassable.js (which is the implementation this kit exposes).

- **§the-named-legacyOrdered-vs-compactOrdered** (line 55-61) — two format variations of the rank-order encoding. Legacy is the historical default; compact is preferred. **§the-named-PR-citation-for-historical-context** — the README cites a specific PR (#1594) for the historical background; **§the-named-PR-link-as-design-record**. First-explicit-observation.

- **§the-named-format-variation-with-named-historical-default** — *"former is the default for historical reasons (see ... for background) but the latter is preferred"*. The legacy is *named* as legacy; the preferred is *named* as preferred; the default is *not* preferred. **§the-named-default-vs-preferred-distinction** — the README acknowledges that the default and the preferred have diverged. Sibling to cycle 326's @deprecated-but-still-working.

- **§the-named-Frozen-Objects-Only-section** (line 63-67) — *"The entire object graph must be 'hardened' (recursively frozen), such as done by the `harden` function installed when importing `@endo/init`."* Names the hardening requirement and cites `@endo/init` as the installer. **§the-named-toCapData-refuses-non-frozen** — first-explicit-observation.

- **§the-named-pass-by-presence-vs-pass-by-copy-with-distinguishing-criteria** (line 91-110) — the README *defines* the criteria: pass-by-presence = all methods; pass-by-copy = all data + frozen + inherits-from-Object.prototype + enumerable + string-named. **§the-named-rejected-mixed-objects** (line 110) — *"Mixed objects having both methods and data properties are rejected."* First-explicit-observation. Closes citation arc with cycle 325 pass-style README (which named the categories).

- **§the-named-Empty-Objects-are-pass-by-copy-with-Far-as-alternative** (line 112-116) — vacuous case named explicitly: empty objects could be either, chosen to be pass-by-copy by default; `Far` (from `@endo/far`) for opting into pass-by-presence. **§the-named-Far-IS-named-empty-marker-for-identity-comparison**. First-explicit-observation.

- **§the-named-rights-amplification-IS-named-canonical-pattern** (line 116) — *"the 'rights amplification' pattern"*. Capability-security vocabulary cited casually as canonical. §the-named-rights-amplification-IS-named-WeakMap-key-pattern (Far objects as WeakMap keys for identity-based access control). Closes citation arc with cycle 322 @endo/exo (amplify capability).

- **§the-named-no-slots-IS-named-no-presence-discipline** — stringify is *string-only output*; without slots, it can't represent remotables or promises. Throws on encounter. **§the-named-shape-determines-which-types-supported** — the output shape (string vs body+slots) dictates which pass-style categories the function can handle.

- **§the-named-intra-document-cross-section-anchoring** (line 187-188) — *"per the original encoding described [above](#beyond-json)"* — Markdown anchor link from the "Direct alternative to JSON" section back to the "Beyond JSON" section. **§the-named-self-referential-anchor-within-README** — first-explicit-observation. The reader can navigate the README itself as a small hypertext.
