---
source_kind: standards-doc
source_url: https://drafts.csswg.org/css-anchor-position-1/
source_content_sha256: f7a87622d8a8a4009b597f467760799cdfd77e4013bfebf2e7a00bca21c027dc
source_author: CSS Working Group (W3C)
source_date: 2026-06-29
retrieved: 2026-06-29
ingested: 2026-06-29
ingested_by: scholar
section_count: 2
status: current
notes: "The CSS Anchor Positioning Level 1 working draft (a living spec; the content hash is over the live drafts.csswg.org response). Ingested for the normative detail MDN summarizes: exactly what each <try-tactic> flips and what it does not, and the position-try-order sort + @position-try descriptor list. Pairs with the practical reference web--mdn-css-anchor-positioning."
---

The normative CSS Anchor Positioning Level 1 specification, ingested for the two points where the precise spec language matters more than the MDN summary: (1) the geometric definition of the `<try-tactic>` keywords (`flip-block`, `flip-inline`, `flip-start`, `flip-x`, `flip-y`) and the axis-paired property swaps they imply — the normative basis for "a `margin-block-end` becomes a `margin-block-start` on flip" — including the deliberate spec gap (tactics are defined by geometric effect, not an explicit affected-property enumeration); and (2) the `position-try-order` stable-sort rule and the restricted set of descriptors valid inside `@position-try`.

| Section | Topics | Status |
|---------|--------|--------|
| [Try-tactic flip semantics: what flips and what does not](../sections/web--csswg-css-anchor-position-1--try-tactic-flip-semantics.md) | web-frontend | current |
| [position-try-order sorting and @position-try descriptors](../sections/web--csswg-css-anchor-position-1--position-try-order-and-descriptors.md) | web-frontend | current |
