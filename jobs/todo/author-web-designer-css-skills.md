# Author web-designer CSS skills (scholar proposal)

Map: **mentor/gardener** (meta-evolution — skill authoring on `main2`).

This job carries a **scholar proposal** produced by
`scholar-ingest-goldilocks-select-propose-web-designer-skills`. The scholar does
not author roles/skills; it proposes. Each proposed skill below names a one-line
purpose, a when-to-use, the **cited library source** it rests on, and its
author-readiness. Author the ready ones now; for the flagged ones, post a
`scholar-ingest-source` job for the named source first, then author.

Grounding: the just-ingested web essay `web--goldilocks-select-height` (Jake
Archibald, customizable-`<select>` picker sizing) plus the garden's actual web
work already in the library — the chat color-schemes design cluster
(`endo-but-for-bots--llm-designs-chat-color-schemes--*`) and the chat command-bar
cluster (`endo-but-for-bots--llm-designs-chat-command-bar--*`) — and the existing
`web-designer` / `web-builder` roles and `emoji-favicon` skill.

Honesty note on the original candidate list: the job's seed list guessed
`field-sizing` and `appearance` as the article's techniques. The article actually
uses **`calc-size()` over intrinsic sizes** and **CSS anchor positioning with
`flip-*` fallbacks** — not `field-sizing`, not `appearance`. The proposal below is
refined to what the source actually supports. `field-sizing`/`appearance` skills
would each need their own source ingested first and are NOT proposed here.

## Proposed skill 1 — css-intrinsic-and-content-sizing  [READY NOW]

- **Purpose**: size an element from its content (`fit-content`/`min-content`/
  `max-content`) or its available space (`stretch`), and use `calc-size()` to do
  arithmetic on those intrinsic sizes so a box is clamped between a content-driven
  minimum and a fixed maximum (the "Goldilocks" size).
- **When to use**: any web design that needs an element (menu, popover, picker,
  panel, auto-growing region) to be "just the right size" — neither a fixed pixel
  box nor unbounded growth. Reach for `calc-size(fit-content, min(size, Nem))`
  rather than a fixed height when the content height should win until it exceeds a
  cap.
- **Cited source**: `web--goldilocks-select-height--intrinsic-min-max-with-calc-size`
  and `--problem-and-default-sizing`; concept `css-intrinsic-sizing`.
- **Readiness**: ready. Optional later deepening: ingest the MDN intrinsic-sizing
  / `calc-size()` reference for a second citation, but the essay is a complete
  worked example.

## Proposed skill 2 — supports-feature-query-progressive-enhancement  [READY NOW]

- **Purpose**: gate a modern CSS feature behind an `@supports` feature query and
  ship a hand-rolled fallback (including `@supports not (...)` with structural
  selectors like `:has()`/`:nth-of-type()`) so a design degrades gracefully on
  engines that lack the feature.
- **When to use**: whenever a design depends on a CSS feature not yet in all
  in-scope browsers — the article gates `calc-size()`, `max-block-size: stretch`,
  and anchored container queries this way. Generalizes the `web-designer` role's
  existing "progressive enhancement" operating norm into a reusable procedure.
- **Cited source**: `web--goldilocks-select-height--viewport-margin-and-flip-fallbacks`,
  `--intrinsic-min-max-with-calc-size`, `--final-css-and-browser-support`;
  reinforced by `endo-but-for-bots--llm-designs-chat-color-schemes--motivation-and-current-state--pattern-scheme-aware-tokens-with-intentional-exceptions`
  (a second feature/scheme-gating exemplar from the garden's own work).
- **Readiness**: ready.

## Proposed skill 3 — css-anchor-positioning-and-flip-fallbacks  [NEEDS ONE MORE SOURCE]

- **Purpose**: position a popover/menu/picker relative to an anchor element with
  `anchor()`/`anchor-size()`/`position-area`, and define `position-try-fallbacks`
  (including `flip-block`/`flip-inline`) so it reflows to a fitting cell — and
  exploit `flip-*` property-flipping (e.g. a `margin-block-end` becoming a
  `margin-block-start` on flip).
- **When to use**: any floating UI anchored to a control — dropdowns, tooltips,
  the customizable-select picker, the chat command-bar token-autocomplete popout
  (`endo-but-for-bots--llm-designs-chat-command-bar--*`).
- **Cited source**: `web--goldilocks-select-height--problem-and-default-sizing`
  and `--viewport-margin-and-flip-fallbacks`.
- **Readiness**: the technique is shown, but the essay covers anchor positioning
  only incidentally (it is sizing-focused). **Flag**: ingest a dedicated CSS
  anchor-positioning reference (MDN anchor-positioning guide / the CSS spec) as a
  `scholar-ingest-source` job before treating this skill as canonical.

## Proposed skill 4 — native-customizable-form-control-styling  [NEEDS MORE SOURCES]

- **Purpose**: style native/customizable form controls (`<select>` and its
  `::picker(select)`, options, optgroups) with CSS rather than rebuilding them as
  div-based JS widgets, preserving native semantics, accessibility, and keyboard
  behavior.
- **When to use**: when a design needs a styled dropdown/select/form control and
  the temptation is a bespoke JS widget; prefer the customizable native control
  where browser support allows, falling back per skill 2.
- **Cited source**: `web--goldilocks-select-height--problem-and-default-sizing`
  (customizable select + the popover/anchor primitives it is built on).
- **Readiness**: **flag — needs more sources**. The essay is the only source and
  is deliberately sizing-focused (it builds demos from popover+anchor primitives,
  not the real custom select). Ingest the MDN "customizable `<select>`" guide (the
  essay links to it) before authoring, so the accessibility/semantics half is
  grounded, not invented.

## Proposed skill 5 — css-design-tokens-and-theming  [READY NOW]

- **Purpose**: express a UI's colors/spacing as CSS custom properties ("tokens")
  derived from a brand asset, with scheme-aware overrides (light/dark/
  high-contrast) and a documented per-token rationale table so theme drift is
  reviewable and auditable.
- **When to use**: any multi-scheme or brandable web surface — the chat client's
  dark mode, the GitHub Pages bulletin SPA (`docs/bulletin/`).
- **Cited source**: `endo-but-for-bots--llm-designs-chat-color-schemes--dark-mode-palette-and-rationale--pattern-brand-derived-color-palette`
  and `--motivation-and-current-state--pattern-scheme-aware-tokens-with-intentional-exceptions`.
  (Grounded in the garden's actual web work, NOT in the Goldilocks essay.)
- **Readiness**: ready.

## Author-readiness summary

- Ready now: skills 1, 2, 5.
- Needs source ingest first: skill 3 (anchor-positioning reference), skill 4
  (MDN customizable-`<select>` guide). Post the `scholar-ingest-source` jobs for
  those two before authoring them.
- Not proposed (would need their own source): a `field-sizing` skill and a CSS
  `appearance`/native-control-theming skill — the seed list guessed these but the
  ingested essay does not cover them.
