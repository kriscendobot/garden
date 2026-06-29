---
id: css-intrinsic-sizing
aliases: [calc-size, "calc-size()", fit-content, max-content, min-content, stretch, intrinsic sizing, content-based sizing, field-sizing, customizable select, "::picker(select)", anchor-size, position-try-fallbacks, "flip-block", "flip-inline"]
topics: [web-frontend]
---

# css-intrinsic-sizing

CSS **intrinsic / content-based sizing** is sizing a box from its content (`fit-content`, `min-content`, `max-content`) or from its available space (`stretch`) rather than a fixed length. The historical limitation is that `min()` / `max()` / `calc()` cannot take intrinsic keywords as operands. **`calc-size()`** lifts that limitation: its first argument names an intrinsic size and its second performs a calculation in which the `size` keyword stands for that intrinsic size — e.g. `calc-size(fit-content, min(size, 12em))` means "the content height, but never more than 12em." This is the primitive that makes "clamp a box between an intrinsic minimum and a fixed maximum" expressible, and it is the key to sizing a customizable `<select>` picker (`::picker(select)`) to a "Goldilocks" height. As of mid-2026 `calc-size()` is Chrome-only (Firefox/Safari have open tickets), so production use pairs it with `@supports` feature queries and a fallback. Note: the closely-named `field-sizing` property (auto-growing a text input/textarea to its content) is a *related but distinct* feature and is not what this essay uses — see Common confusions.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Clamping min/max with calc-size() and intrinsic sizes](../sections/web--goldilocks-select-height--intrinsic-min-max-with-calc-size.md) | calc-size(fit-content, min(size, 12em)) for the min and calc-size(stretch, min(size, 30em)) for the max, with an @supports fallback. |
| [The Goldilocks problem and default ::picker(select) sizing](../sections/web--goldilocks-select-height--problem-and-default-sizing.md) | UA defaults use intrinsic sizing (max-block-size: stretch, min-inline-size: anchor-size()) as the baseline the technique refines. |
| [The complete picker CSS and the browser-support matrix](../sections/web--goldilocks-select-height--final-css-and-browser-support.md) | Where each intrinsic-sizing primitive is and is not supported in mid-2026. |

## See also

- [[progressive-enhancement-supports]] — `calc-size()`'s Chrome-only status forces an `@supports`-gated fallback; the two concepts are used together.

## Common confusions

- **`calc-size()` is not `field-sizing`.** `field-sizing: content` auto-sizes a form field (input/textarea) to its typed content; `calc-size()` is a general value function for doing arithmetic on any intrinsic size. The Goldilocks-select-height essay uses `calc-size()`, not `field-sizing`.
- **Intrinsic sizing is not anchor positioning.** `anchor-size()` / `position-area` / `position-try-fallbacks` place and bound the picker relative to its anchor; intrinsic sizing decides its content-driven dimensions. The picker technique composes both.
