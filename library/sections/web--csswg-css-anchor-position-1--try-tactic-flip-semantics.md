---
title: "Normative try-tactic semantics: what flip-block / flip-inline / flip-start flip, and what they do not"
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

The normative account, from the CSS Anchor Positioning Level 1 working draft, of what a `<try-tactic>` actually transforms. The spec defines each tactic **geometrically** — as a mirroring across an axis — and the rule is that the mirror swaps the values of the corresponding axis-paired properties. This is the precise basis for the goldilocks essay's observation that a `margin-block-end` becomes a `margin-block-start` on `flip-block` (`web--goldilocks-select-height--viewport-margin-and-flip-fallbacks`): margin-block-start and margin-block-end are a block-axis pair, so `flip-block` swaps them.

## The five tactic keywords (verbatim definitions)

- **`flip-block`** — "swaps the values in the block axis (between, for example, `margin-block-start` and `margin-block-end`), essentially mirroring across an inline-axis line."
- **`flip-inline`** — "swaps the values in the inline axis, essentially mirroring across a block-axis line."
- **`flip-start`** — "swaps the values of the start properties with each other, and the end properties with each other (between, for example, `margin-block-start` and `margin-inline-start`), essentially mirroring across a diagonal drawn from the start-start corner to the end-end corner."
- **`flip-x`** — "swaps the values in the horizontal axis (between, for example, `margin-left` and `margin-right`), essentially mirroring across a vertical-axis line."
- **`flip-y`** — "swaps the values in the vertical axis, essentially mirroring across a horizontal-axis line."

## What gets flipped

The tactic mirrors a placement, so it swaps the values of every property that comes as an **axis-paired pair** on the flipped axis. Concretely, `flip-block` swaps:

- the block-axis inset pair (`inset-block-start` ↔ `inset-block-end`, hence `top` ↔ `bottom` in horizontal writing modes);
- the block-axis margin pair (`margin-block-start` ↔ `margin-block-end`);
- the block component of `position-area` (a `block-start` region becomes `block-end`);
- the block-axis self-alignment.

`flip-inline` does the same on the inline axis; `flip-start` swaps the start-pair and end-pair across the block/inline diagonal (so block-axis and inline-axis values trade places — `margin-block-start` ↔ `margin-inline-start`). The transformation operates on the **logical** properties; `flip-x` / `flip-y` are the physical-axis equivalents.

## Composition

"If multiple keywords are given, the transformations are composed in order to produce a single position option. Logical directions are resolved against the writing mode of the containing block." So `flip-block flip-inline` mirrors on both axes (the diagonal-opposite cell), composed left-to-right.

## What is NOT flipped — a deliberate spec gap

The draft defines the tactics by their **geometric effect** (axis swaps and mirrorings) and does **not** give an explicit algorithmic enumeration of every affected property; implementations derive the affected set from the geometry. The practical consequence, flagged by the goldilocks essay: the flip "works for some properties and not others." Properties that are **not** part of an axis-paired set on the flipped axis are carried through unchanged — a single-value `width`/`block-size`, a non-directional `background`, a `translate` are not mirrored. The reliable, portable subset is the directional logical pairs (insets, margins, `position-area`, self-alignment); anything else should be verified per-engine rather than assumed to flip. (The CSS Working Group has also resolved to change the **default** `position-try-fallbacks` for `::picker(select)` so an explicit `flip-*` override becomes unnecessary in future — see `web--goldilocks-select-height--final-css-and-browser-support`.)

Source: [CSS Anchor Positioning Level 1 — Position Try Fallbacks / try tactics](https://drafts.csswg.org/css-anchor-position-1/), CSS Working Group, drafts.csswg.org; fetched 2026-06-29 via direct curl, content SHA-256 `f7a87622`.
