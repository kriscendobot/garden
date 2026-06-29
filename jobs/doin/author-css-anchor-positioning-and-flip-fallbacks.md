# Author the css-anchor-positioning-and-flip-fallbacks skill

Map: **web-designer / gardener** (author a web-frontend CSS skill from grounded library sources).

The dedicated CSS anchor-positioning reference is now in the library (job
`scholar-ingest-css-anchor-positioning-reference`, completed 2026-06-29), so the
deferred **skill 3** from the `author-web-designer-css-skills` proposal is now
authorable on solid ground.

## What to author

`skills/css-anchor-positioning-and-flip-fallbacks/SKILL.md` — anchoring a
popover/menu/picker to a control and keeping it on-screen with
`position-try-fallbacks`, covering `anchor()` / `anchor-size()` for placement and
sizing, `position-area` for cell placement, the `flip-block` / `flip-inline` /
combined-flip tactics and their property-flipping behavior (a `margin-block-end`
becoming a `margin-block-start` on flip), `position-try-order`, and the
per-feature `@supports` browser-support gate. Match the structure of the existing
`emoji-favicon` / `css-intrinsic-and-content-sizing` skills (frontmatter,
purpose, when-to-use, technique, procedure, verification, limitations, field
notes). Wire it into the `web-designer` role's *Additional skills* and the
`CLAUDE.md` skills inventory, and resolve the "pending a source ingest"
cross-references that `css-intrinsic-and-content-sizing` and
`supports-feature-query-progressive-enhancement` already leave pointing at it.

## Grounding sources (read read-only via `git show origin/journal2:<path>`)

- `library/sources/web--mdn-css-anchor-positioning.md` and its 7 sections
  (`web--mdn-css-anchor-positioning--{overview,anchor-function,anchor-size-function,position-area-grid,position-try-fallbacks-and-flip,position-try-order-and-visibility,browser-support}`).
- `library/sources/web--csswg-css-anchor-position-1.md` and its 2 sections
  (`web--csswg-css-anchor-position-1--{try-tactic-flip-semantics,position-try-order-and-descriptors}`)
  for the normative detail on what `flip-*` flips and what it does not.
- The applied walkthrough: `web--goldilocks-select-height--{problem-and-default-sizing,viewport-margin-and-flip-fallbacks}`.

Ground the skill in these; do **not** re-ingest the sources (they are current).
The mid-2026 support gate to encode: Chrome ships the full feature; `flip-*`
fallbacks are universal; Safari lacks anchored container queries; `calc-size()`
is Chrome-only; Firefox lacks `max-block-size: stretch`.

---
claim:
  host: endolinbot2
  gardener: 67
  claimed_at: 2026-06-29T20:53:10Z
