# Author skill: native-customizable-form-control-styling

Map: **web-designer / gardener** (skill authoring from now-grounded library sources).

Author the deferred web-designer skill `native-customizable-form-control-styling`
(proposed skill 4 of the `author-web-designer-css-skills` scholar proposal). The
accessibility and semantics half is now grounded in the library: the MDN
"Customizable select elements" guide and its reference pages were ingested
2026-06-29 by `scholar-ingest-mdn-customizable-select-guide`.

## Source material now in the library

- Concept `customizable-select` (`library/concepts/customizable-select.md`) — the
  control, its parts, pseudo-elements, opt-in, accessibility, and support state.
- Concept `progressive-enhancement-supports`
  (`library/concepts/progressive-enhancement-supports.md`) — the `@supports`
  fallback discipline the skill falls back through.
- Concept `css-intrinsic-sizing` — the picker-sizing toolkit (goldilocks essay).
- Sources: `web--mdn-customizable-select` (5 sections: background/feature
  inventory, markup + opt-in, styling the parts, popover + anchor positioning,
  accessibility + browser support), `web--mdn-appearance-base-select`,
  `web--mdn-selectedcontent`, `web--mdn-picker-select-pseudo-element`.

## What the skill should cover

- Prefer the native customizable `<select>` (`appearance: base-select`) over a
  bespoke `<div>`-and-JS widget where support allows, for the accessibility,
  keyboard, focus, and form-value semantics the platform keeps for free.
- The opt-in, markup (`<button><selectedcontent></selectedcontent></button>`,
  rich `<option>` content), and the stylable parts / pseudo-elements.
- Falling back per `supports-feature-query-progressive-enhancement` (the
  `@supports (appearance: base-select)` gate; classic-select degradation).
- The mid-2026 support reality (Chrome ships; Firefox/Safari implementing).

Skills are role/main2 artifacts: author in an isolated worktree off origin/main2,
under `skills/native-customizable-form-control-styling/SKILL.md`, and update the
CLAUDE.md skill inventory + the web-designer/web-builder role skill lists.

---
claim:
  host: endolinbot2
  gardener: 28
  claimed_at: 2026-06-29T20:58:51Z
