# web-frontend

Web frontend CSS and HTML techniques for building and styling the garden's web surfaces (the GitHub Pages bulletin SPA under `docs/bulletin/`, the inventory-grouping chat UI in `packages/space-chat` and `packages/chat`) and any future web-designer / web-builder work. Covers native/customizable form-control styling, CSS intrinsic and content-based sizing (`fit-content`, `stretch`, `min-content`, `max-content`, and `calc-size()` arithmetic over them), `@supports` feature-query progressive enhancement with hand-rolled fallbacks, and CSS anchor positioning (`anchor-size()`, `position-area`, `position-try-fallbacks`, `flip-*`). This topic is distinct from `chat-ui` (which catalogs the Familiar Chat product's UI invariants and component designs); `web-frontend` collects the cross-cutting browser/CSS *technique* material a web-designer reuses regardless of product.

## Sections

| Section | One-line summary |
|---|---|
| [The Goldilocks problem and default ::picker(select) sizing](../sections/web--goldilocks-select-height--problem-and-default-sizing.md) | The "just right" customizable-select picker-height problem and the UA default sizing (anchor-size, max-block-size: stretch, position-area, position-try-order/fallbacks) it starts from. |
| [Keeping the picker off the viewport edge: margin + flip-* fallbacks](../sections/web--goldilocks-select-height--viewport-margin-and-flip-fallbacks.md) | Adding a viewport margin and making it behave across browsers via an @supports stretch fallback and flip-* position-try-fallbacks that carry the margin across a flip. |
| [Clamping min/max with calc-size() and intrinsic sizes](../sections/web--goldilocks-select-height--intrinsic-min-max-with-calc-size.md) | Using calc-size() to do arithmetic on fit-content/stretch so the picker is clamped between a usable minimum and a sane maximum, with an @supports + :has() fallback. |
| [The complete picker CSS and the browser-support matrix](../sections/web--goldilocks-select-height--final-css-and-browser-support.md) | The full copy-paste CSS plus the mid-2026 support matrix (calc-size Chrome-only, stretch absent in Firefox, position-try-order absent in Firefox/Safari, no anchored container queries in Safari). |

## See also

- chat-ui — the garden's web-based Familiar Chat UI; web-frontend collects the CSS technique material that product work reuses.
