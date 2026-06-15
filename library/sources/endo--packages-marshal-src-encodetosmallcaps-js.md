---
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodeToSmallcaps.js
source_line_range: "34-293"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Smallcaps wire-format rationale: the reserved special-character prefix scheme, the canonical-encoding invariants (copyRecord key sorting and the canonical-JSON aspiration), and the diagnostic-priority special case that pulls error encoding out of the recursion at the root"
source_authors: [Mark S. Miller, Kris Kowal, Richard Gibson, Michael FIG, Turadg Aleahmad, Mathieu Hofman, Chip Morningstar]
ingested: 2026-05-15
ingested_by: scholar
section_count: 4
status: current
notes: |
  Second comment-fragment ingest (cycle 69), following the
  `handled-promise.js` precedent from cycle 66. Three sections
  distilled from the longform JSDoc and bare-block comments
  bracketing `encodeToSmallcaps​Recur` and the
  `encodeToSmallcaps` wrapper. The three cohesive arguments the
  comments make: (1) why the reserved-character range (`!` 33 to
  `-` 45) is contiguous and how the seven assigned sigils plus
  five reserved positions partition the smallcaps value space;
  (2) why the encoding must be canonical and how copyRecord key
  sorting plus encoder-source-order object literals achieve it
  (with the canonical-JSON TODO the comment names);
  (3) why error-like values get a pre-recursion encoding path,
  rooted in the diagnostic-information-over-validation
  prioritization rule.
---

## Abstract

`packages/marshal/src/encodeToSmallcaps.js` is the smallcaps
encoder for marshal's pass-style serialization. Its longform
comments document three non-obvious design moves the
implementation rests on: the **special-character prefix scheme**
(the contiguous ASCII range `!`-`-` reserved for sigils that turn
JSON strings into tagged values, with seven sigils currently
assigned and five reserved), the **canonical-encoding invariants**
(copyRecord property-name sorting plus encoder-source-order
object-literal traversal, justified by the need to reduce
non-determinism exposed outside a vat, with a canonical-JSON TODO
for the remaining gap), and the **error-encoding root special case**
(the pre-recursion `isErrorLike` branch that lets the encoder
report diagnostic information even when the input error is not a
valid Passable, justified by a diagnostic-priority rule). The
comments are the canonical source for these three claims, which
the marshal package's README and the smallcaps cheatsheet
reference summarily but do not re-explain in depth.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [special-character-prefix-scheme](../sections/endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme.md) | marshal, pass-style | current (cycle 69; wire-format-rationale lens) |
| [canonical-encoding-invariants](../sections/endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants.md) | marshal, pass-style | current (cycle 69; canonical-encoding lens) |
| [error-encoding-root-special-case](../sections/endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case.md) | marshal, pass-style, errors | current (cycle 69; diagnostic-priority lens) |
| [complementary-lens-trivial-Hilbert-Hotel-and-sibling-comparison-with-capdata](../sections/endo--packages-marshal-src-encodetosmallcaps-js--complementary-lens-trivial-Hilbert-Hotel-and-sibling-comparison-with-capdata.md) | marshal, hilbert-hotel, sibling-comparison | current (cycle 330; complementary-lens-re-ingest — trivial-Hilbert-Hotel via character range + sort-order preservation + sibling comparison with cycle 328 capdata) |

## Provenance

- File last modified 2025-10-09 by Kris Kowal (`feat: Adopt @endo/harden`).
- File-specific commit `e56bf00f` (captured 2026-05-15).
- Comments authored across the file's history by Mark S. Miller, Kris Kowal, Richard Gibson, Michael FIG, Turadg Aleahmad, Mathieu Hofman, and Chip Morningstar. The module is described in its own header as based on `encodePassable.js` in `@agoric/store`; the older capdata `@qclass` form is referenced by name as the wire format smallcaps supersedes.

Source: [packages/marshal/src/encodeToSmallcaps.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/marshal/src/encodeToSmallcaps.js) at commit `e56bf00f`.
