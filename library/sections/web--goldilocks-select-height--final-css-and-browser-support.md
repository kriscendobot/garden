---
title: "The complete picker CSS and the browser-support matrix"
source_kind: web-essay
source_url: https://jakearchibald.com/2026/goldilocks-select-height/
source_content_sha256: a73ec7f270b8ba4d87005dabc68aa2442016d528806720ab7d80e61a71fc781a
source_author: Jake Archibald
source_date: 2026-06-29
ingested: 2026-06-29
ingested_by: scholar
topics: [web-frontend]
status: current
---

The complete, copy-paste CSS that combines the viewport margin, the minimum size, and the maximum size, plus the browser-support caveats that determine which code path each engine actually takes as of mid-2026. This is the "just right" Goldilocks result.

## The full CSS

```css
.custom-select::picker(select) {
    --viewport-margin: 1em;
    --min-size: 12em;
    --max-size: 30em;
    min-block-size: var(--min-size);
    max-block-size: min(calc(100% - var(--viewport-margin)), var(--max-size));
    position-try-fallbacks:
        flip-block,
        flip-inline,
        flip-block flip-inline;
    @supports (min-block-size: calc-size(fit-content, min(size, 1px))) {
        min-block-size: calc-size(fit-content, min(size, var(--min-size)));
        max-block-size: calc-size(stretch, min(size, var(--max-size)));
        margin-block-end: var(--viewport-margin);
    }
    @supports not (min-block-size: calc-size(fit-content, min(size, 1px))) {
        &:not(
            :has(:where(option:nth-of-type(4))),
            :has(:where(optgroup:nth-of-type(2)))
        ) {
            min-block-size: 0;
            max-block-size: fit-content;
        }
    }
}
```

## Browser-support matrix (mid-2026)

- **Customizable `<select>` itself** ships in Chrome; Firefox and Safari are actively implementing it but have not released it. The demos are built from popovers + anchor positioning (the same primitives) so they run more widely; the techniques should apply to the real custom select once it ships.
- **`calc-size()`** — Chrome only. Firefox and Safari have open tickets. The `@supports` blocks gate the `calc-size()` path and provide a fallback (fixed min plus a `:has()`/`:nth-of-type()` short-list detector) for engines without it.
- **`max-block-size: stretch`** — not supported in Firefox, which falls back to the `calc(100% - margin)` percentage path.
- **`position-try-order: most-block-size`** — does not work in Firefox or Safari yet (the spec was unclear; both have tickets).
- **Anchored container queries** — not supported in Safari, which is why the margin-on-flip fix uses `flip-*` `position-try-fallbacks` (whose property-flipping carries the margin across) rather than restyling on flip.
- **`flip-*` fallbacks** — supported in Safari; they flip some properties (margins, usefully) and not others.

## The residual imperfection

Because the maximum uses `calc-size()`, which Safari lacks, Safari falls back to the same percentage path as Firefox — "almost perfect, but not quite." On the percentage path, once the picker reaches its minimum height it slides toward the viewport edge *before* flipping, whereas Chrome (using `calc-size()` + `stretch`) flips as soon as the minimum height is hit. A minor difference that resolves once all browsers support `calc-size()`. A forthcoming CSS Working Group change to the default select-picker `position-try-fallbacks` should also remove the need for the explicit `flip-*` override.

Source: [The Goldilocks customizable select height](https://jakearchibald.com/2026/goldilocks-select-height/) § Putting it all together, Jake Archibald, jakearchibald.com, posted 2026-06-29; fetched 2026-06-29 via direct curl, content SHA-256 `a73ec7f2`.
