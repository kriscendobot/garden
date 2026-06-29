# web-frontend

Web frontend CSS and HTML techniques for building and styling the garden's web surfaces (the GitHub Pages bulletin SPA under `docs/bulletin/`, the inventory-grouping chat UI in `packages/space-chat` and `packages/chat`) and any future web-designer / web-builder work. Covers native/customizable form-control styling, CSS intrinsic and content-based sizing (`fit-content`, `stretch`, `min-content`, `max-content`, and `calc-size()` arithmetic over them), `@supports` feature-query progressive enhancement with hand-rolled fallbacks, and CSS anchor positioning (`anchor-size()`, `position-area`, `position-try-fallbacks`, `flip-*`). This topic is distinct from `chat-ui` (which catalogs the Familiar Chat product's UI invariants and component designs); `web-frontend` collects the cross-cutting browser/CSS *technique* material a web-designer reuses regardless of product.

## Sections

| Section | One-line summary |
|---|---|
| [The Goldilocks problem and default ::picker(select) sizing](../sections/web--goldilocks-select-height--problem-and-default-sizing.md) | The "just right" customizable-select picker-height problem and the UA default sizing (anchor-size, max-block-size: stretch, position-area, position-try-order/fallbacks) it starts from. |
| [Keeping the picker off the viewport edge: margin + flip-* fallbacks](../sections/web--goldilocks-select-height--viewport-margin-and-flip-fallbacks.md) | Adding a viewport margin and making it behave across browsers via an @supports stretch fallback and flip-* position-try-fallbacks that carry the margin across a flip. |
| [Clamping min/max with calc-size() and intrinsic sizes](../sections/web--goldilocks-select-height--intrinsic-min-max-with-calc-size.md) | Using calc-size() to do arithmetic on fit-content/stretch so the picker is clamped between a usable minimum and a sane maximum, with an @supports + :has() fallback. |
| [The complete picker CSS and the browser-support matrix](../sections/web--goldilocks-select-height--final-css-and-browser-support.md) | The full copy-paste CSS plus the mid-2026 support matrix (calc-size Chrome-only, stretch absent in Firefox, position-try-order absent in Firefox/Safari, no anchored container queries in Safari). |
| [CSS anchor positioning: anchor elements, anchor-name, position-anchor](../sections/web--mdn-css-anchor-positioning--overview.md) | The fundamentals: an anchor element (anchor-name) tied to absolutely/fixed-positioned elements that bind via position-anchor (or the default anchor). |
| [The anchor() function](../sections/web--mdn-css-anchor-positioning--anchor-function.md) | Positioning an element to an anchor's edges/center/percentage via anchor() in inset properties, with side keywords and a fallback length. |
| [The anchor-size() function](../sections/web--mdn-css-anchor-positioning--anchor-size-function.md) | Sizing an element to an anchor's width/height/inline/block (and self-* variants) via anchor-size(), composable in calc(). |
| [position-area and the 3×3 region grid](../sections/web--mdn-css-anchor-positioning--position-area-grid.md) | The shorthand placement grid: pick a cell of the 3×3 region grid around the anchor with physical/logical region keywords and span-* keywords. |
| [position-try-fallbacks: flip-* tactics and @position-try](../sections/web--mdn-css-anchor-positioning--position-try-fallbacks-and-flip.md) | The overflow toolkit: flip-block/flip-inline/flip-start tactics (and their property-flipping), position-area fallbacks, and custom @position-try options. |
| [position-try-order, position-visibility, anchored container queries](../sections/web--mdn-css-anchor-positioning--position-try-order-and-visibility.md) | Proactive most-* fallback selection, the position-try shorthand, hiding on overflow, and restyling descendants on the active fallback. |
| [CSS anchor positioning browser-support matrix (mid-2026)](../sections/web--mdn-css-anchor-positioning--browser-support.md) | The per-feature support gate: Chrome ships all; flip-* fallbacks universal; Safari lacks anchored container queries; calc-size() Chrome-only; Firefox lacks stretch. |
| [Normative try-tactic flip semantics: what flips and what does not](../sections/web--csswg-css-anchor-position-1--try-tactic-flip-semantics.md) | The CSSWG spec's geometric definition of flip-block/inline/start (axis-paired swaps of insets, margins, position-area) and the deliberate gap on the affected-property enumeration. |
| [Normative position-try-order sorting and @position-try descriptors](../sections/web--csswg-css-anchor-position-1--position-try-order-and-descriptors.md) | The spec's stable-sort most-* rule and the restricted descriptor set valid inside @position-try (insets, margins, sizing, self-alignment, position-anchor, position-area). |

## See also

- chat-ui — the garden's web-based Familiar Chat UI; web-frontend collects the CSS technique material that product work reuses.
