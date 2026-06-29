---
title: "Normative position-try-order sorting and the @position-try accepted-descriptor list"
source_kind: standards-doc
source_url: https://drafts.csswg.org/css-anchor-position-1/
source_content_sha256: f7a87622d8a8a4009b597f467760799cdfd77e4013bfebf2e7a00bca21c027dc
source_author: CSS Working Group (W3C)
source_date: 2026-06-29
ingested: 2026-06-29
ingested_by: scholar
topics: [web-frontend]
status: current
---

The normative detail behind two `position-try-*` surfaces: how `position-try-order` sorts the position-option list, and exactly which properties are valid inside a `@position-try` rule. This complements the practical MDN view (`web--mdn-css-anchor-positioning--position-try-fallbacks-and-flip`, `web--mdn-css-anchor-positioning--position-try-order-and-visibility`).

## position-try-order sorting

Each `most-*` value sorts the candidate position-option list by an available dimension and applies the largest:

- **`most-width`** — sort by available **width** in the inset-modified containing block.
- **`most-height`** — sort by available **height** in the inset-modified containing block.
- **`most-block-size`** — sort by available **block** dimension.
- **`most-inline-size`** — sort by available **inline** dimension.

For each: "Stably sort the position options list according to this size, with the largest coming first." The sort is **stable**, so options of equal available size keep their authored order — making the `position-try-fallbacks` list order the tiebreak.

## @position-try accepted descriptors

The spec restricts the declarations valid inside a `@position-try` rule to:

- Inset properties (`top`, `bottom`, `left`, `right`, `inset-block-start`, …)
- Margin properties (`margin-*`)
- Sizing properties (`width`, `height`, `block-size`, `inline-size`, `min-*`, `max-*`)
- Self-alignment properties (`align-self`, `justify-self`, and `anchor-center`)
- `position-anchor`
- `position-area`

Any other property in the rule is ignored. `!important` is invalid on these declarations: "It is invalid to use `!important` on the properties in the `<declaration-list>`. Doing so causes the property it is used on to become invalid, but does not invalidate the `@property-try` rule as a whole." This accepted set is the same set a `<try-tactic>` flip operates over — which is why a custom `@position-try` option and a `flip-*` tactic are interchangeable entries in one `position-try-fallbacks` list.

Source: [CSS Anchor Positioning Level 1 — position-try-order / @position-try](https://drafts.csswg.org/css-anchor-position-1/), CSS Working Group, drafts.csswg.org; fetched 2026-06-29 via direct curl, content SHA-256 `f7a87622`.
