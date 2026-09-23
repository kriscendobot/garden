---
title: "@endo/marshal README.md — adjacent-reverse pair with cycle 328; side-by-side smallcaps/original format comparison; fifth honesty-about-API-tradeoffs subtype (functionality-not-supported)"
source-slug: endo--packages-marshal-README-md
url: https://github.com/endojs/endo/blob/master/packages/marshal/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/marshal/README.md
total-lines: 188
ingest-cycle: 329
ingest-date: 2026-06-15
lane: designs
---

# `@endo/marshal README.md`

The 188-line README for `@endo/marshal`. **Twentieth consecutive non-garden source after the pivot** (cycles 310-329). **§twenty-cycles-with-named-pivot-domain-stay**. **Eleventh package extends** (marshal; source → README adjacent-reverse pair, mirroring lp32 315-316 and patterns 326-327). **§four-cycles-with-named-one-cycle-README-source-arc** (323→324, 325→326, 326→327, 328→329).

Cycle 329 closes **three citation arcs**:
- Cycle 328 (encodeToCapData.js) → 329 (1 cycle; fourth one-cycle arc)
- Cycle 160 (marshal-stringify.js) → 329 (169 cycles; explicit naming of stringify/parse)
- Cycle 81 (encodePassable.js) → 329 (248 cycles; makePassableKit uses encodePassable internals)

**§twenty-five-citation-arc-closures-in-pivot-now** (22 + 3).

## Key moves

- **§the-named-side-by-side-format-comparison-discipline** — line 80-89 shows the SAME NaN input encoded in *both* smallcaps (`#"#NaN"`) AND original (`{"@qclass":"NaN"}`) formats side-by-side. **Single most structurally interesting move**. §the-named-comparison-by-side-by-side-output as a documentation discipline. First-explicit-observation.
- **§the-named-honesty-about-API-tradeoffs-gains-fifth-subtype** — §the-named-functionality-not-supported-at-all-subtype: marshal-stringify/parse explicitly does NOT support replacer/reviver. §five-cycles-with-named-honesty-about-API-tradeoffs (321 low-utility + 323 relaxed-security + 325 functionality-elsewhere + 326 documentation-language-cannot-express + 329 functionality-not-supported-at-all).
- **§the-named-more-tolerant-and-less-tolerant-IS-named-symmetric-comparison-discipline** — README names BOTH directions of how marshal stringify differs from JSON.stringify (more tolerant of NaN/Infinity/bigints/undefined; less tolerant of non-pass-by-copy data). §the-named-symmetric-comparison-via-both-directions. First-explicit-observation.
- **§the-named-explicit-error-vs-silent-omission-discipline** — *"JSON.stringify handles unserializable data by skipping it, but marshal's stringify rejects it by throwing an error"*; §the-named-throw-not-skip-discipline.
- **§the-named-marshalling-IS-named-conversion-of-structured-data** — opening sentence defines the term; §the-named-define-the-term-first-discipline.
- **§the-named-capability-bearing-data-IS-named-special-data** — marshal specializes in capability-bearing data.
- **§the-named-CapData-structure-IS-named-body-plus-slots** — `{ body, slots }` is the canonical CapData format; §the-named-slot-identifier-as-named-indirection-mechanism; §the-named-side-table-pattern (slots array as side table).
- **§the-named-parameterized-with-two-functions-discipline** — convertValToSlot + convertSlotToVal pair binds marshaller to host environment; §the-named-convertValToSlot-and-convertSlotToVal-named-pair.
- **§the-named-makePassableKit-as-alternative-API** — second exported factory for direct-serialization format (closes cycle 81 encodePassable arc).
- **§the-named-legacyOrdered-vs-compactOrdered** — two format variations of rank-order encoding; §the-named-PR-citation-for-historical-context (PR #1594 cited for legacy background); §the-named-PR-link-as-design-record; §the-named-default-vs-preferred-distinction (the default has diverged from the preferred).
- **§the-named-Frozen-Objects-Only-section** — toCapData refuses non-frozen object graphs.
- **§the-named-pass-by-presence-vs-pass-by-copy-with-distinguishing-criteria** with **§the-named-rejected-mixed-objects** edge case explicitly named.
- **§the-named-Empty-Objects-are-pass-by-copy-with-Far-as-alternative** — vacuous case named explicitly; §the-named-Far-IS-named-empty-marker-for-identity-comparison.
- **§the-named-rights-amplification-IS-named-canonical-pattern** — capability-security vocabulary; Far objects as WeakMap keys; §the-named-rights-amplification-IS-named-WeakMap-key-pattern.
- **§the-named-no-slots-IS-named-no-presence-discipline** — stringify throws on remotables/promises because no slots means no indirection mechanism.
- **§the-named-intra-document-cross-section-anchoring** — `[above](#beyond-json)` self-referential Markdown anchor; §the-named-self-referential-anchor-within-README.
- **§twenty-cycles-with-named-pivot-domain-stay**, **§twenty-five-citation-arc-closures-in-pivot-now**, **§four-cycles-with-named-one-cycle-README-source-arc**, **§five-cycles-with-named-honesty-about-API-tradeoffs**.

## Section files

- [§the-named-side-by-side-format-comparison-discipline + §the-named-honesty-about-API-tradeoffs-gains-fifth-subtype + §the-named-more-tolerant-and-less-tolerant-IS-named-symmetric-comparison-discipline + 20+ more first-explicit-observations](../sections/endo--packages-marshal-README-md--side-by-side-format-comparison-and-fifth-honesty-subtype.md) — full 188-line README in scope.

## Ingest scope

Cycle 329 (designs-lane after cycle 328's chat-lane @endo/marshal src/encodeToCapData.js). Full 188-line README in scope. Twentieth consecutive @endo/* source; eleventh package extends (marshal; source → README adjacent-reverse pair). Closes cycle 328 → 329 in 1 cycle (fourth one-cycle README↔source arc); also closes cycle 160 marshal-stringify (169 cycles) and cycle 81 encodePassable via makePassableKit (248 cycles). **First-explicit-observations** including §the-named-side-by-side-format-comparison-discipline, §the-named-functionality-not-supported-at-all-subtype, §the-named-symmetric-comparison-via-both-directions, §the-named-throw-not-skip-discipline, §the-named-define-the-term-first-discipline, §the-named-PR-link-as-design-record, §the-named-default-vs-preferred-distinction, §the-named-intra-document-cross-section-anchoring, §the-named-rejected-mixed-objects, §the-named-Far-IS-named-empty-marker-for-identity-comparison, §the-named-rights-amplification-IS-named-canonical-pattern, §the-named-no-slots-IS-named-no-presence-discipline. Multi-cycle: §twenty-cycles-with-named-pivot-domain-stay, §twenty-five-citation-arc-closures-in-pivot-now, §four-cycles-with-named-one-cycle-README-source-arc (323→324 + 325→326 + 326→327 + 328→329), §five-cycles-with-named-honesty-about-API-tradeoffs (321 + 323 + 325 + 326 + 329; five named subtypes).
