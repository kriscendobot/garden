---
id: progressive-enhancement-supports
aliases: [progressive enhancement, "@supports", feature query, "@supports feature query", CSS feature detection, "appearance: base-select fallback", graceful degradation CSS, supports not]
topics: [web-frontend]
---

# progressive-enhancement-supports

**Progressive enhancement with `@supports` feature queries** is the discipline of shipping a baseline that works everywhere and layering a CSS enhancement on top only where the browser supports the required feature, detected at parse time with an `@supports` (or `@supports not`) block. It is the production answer to the partial-support reality of the in-flight CSS used by customizable `<select>` and its picker-sizing toolkit: `appearance: base-select`, `calc-size()`, `stretch`, and `position-try-order` are mid-2026 Chrome-only or Chrome-plus-some, so the same stylesheet must degrade to a usable classic control or a hand-rolled fallback in Firefox and Safari. The pattern pairs a `@supports (feature)` positive query (apply the enhancement) with a `@supports not (feature)` negative query (apply the fallback), sometimes substituting structural detection (`:has()`, `:nth-of-type()`) where a clean feature query is unavailable. This concept is the fallback half of every customizable-select and intrinsic-sizing technique; see [[customizable-select]] and [[css-intrinsic-sizing]] for the features it guards.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Keeping the picker off the viewport edge: margin + flip-* fallbacks](../sections/web--goldilocks-select-height--viewport-margin-and-flip-fallbacks.md) | An `@supports` `stretch` fallback plus flip-* position-try-fallbacks that carry a margin across a flip when the enhanced path is unsupported. |
| [Clamping min/max with calc-size() and intrinsic sizes](../sections/web--goldilocks-select-height--intrinsic-min-max-with-calc-size.md) | `calc-size()` enhancement gated behind `@supports` with a `:has()`/structural fallback for browsers without it. |
| [The complete picker CSS and the browser-support matrix](../sections/web--goldilocks-select-height--final-css-and-browser-support.md) | The full picker CSS showing the enhancement-plus-fallback layering and the per-feature mid-2026 support matrix that motivates it. |
| [Accessibility guarantees and browser-support state](../sections/web--mdn-customizable-select--accessibility-and-browser-support.md) | Customizable select as a progressive enhancement: classic-select fallback in non-supporting browsers, `@supports not (appearance: base-select)` for an explicit fallback notice. |
| [Background and feature inventory](../sections/web--mdn-customizable-select--background-and-feature-inventory.md) | Frames customizable select explicitly as a progressive enhancement that falls back to classic selects where unsupported. |
| [CSS anchor positioning browser-support matrix (mid-2026)](../sections/web--mdn-css-anchor-positioning--browser-support.md) | The per-feature support gate that decides which anchor-positioning enhancements need an `@supports` fallback. |

## See also

- [[customizable-select]] — the native control shipped behind an `@supports (appearance: base-select)` query with a classic-select fallback.
- [[css-intrinsic-sizing]] — `calc-size()` is Chrome-only mid-2026, so its use is `@supports`-gated with a fallback.

## Common confusions

- **`@supports` tests CSS feature support, not viewport or media conditions.** Use `@media` for viewport/device conditions; `@supports` for "does this browser understand this property/value."
- **A positive `@supports` query is not enough on its own.** Pair it with the baseline (unconditional) styles or an explicit `@supports not (…)` fallback, or unsupporting browsers get no styling for that surface.
