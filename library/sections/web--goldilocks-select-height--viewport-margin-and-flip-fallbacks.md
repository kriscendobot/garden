---
title: "Keeping the picker off the viewport edge: margin, the Firefox stretch fallback, and flip-* position-try-fallbacks"
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

The first UX fix: stop the picker from extending flush to the viewport edge (where it is impossible to tell whether it stopped or overflowed) by adding a margin — then make that margin behave correctly across Firefox (which lacks `max-block-size: stretch`) and Chrome/Safari (where the margin must move to the other side when the picker flips above the button). This section captures the naive attempt, why it fails per-browser, and the two cross-browser workarounds, demonstrating the `@supports` progressive-enhancement and `position-try-fallbacks` flip techniques.

## The naive margin and why it fails

```css
.custom-select::picker(select) {
    margin-block-end: 1em;
}
```

This is wrong in two ways: in **Firefox** it does nothing; in **Chrome & Safari** the margin stays on the bottom even when the picker flips to appear *above* the button, which looks wrong.

## Fixing Firefox: deduct the margin from a percentage max-size under @supports

Firefox does not support `max-block-size: stretch`, so a `max-block-size: 100%` fallback was in play — but with percent heights, margins do **not** subtract from the height, so the picker still reaches the viewport edge with the margin spilling past it. The fix subtracts the margin from the percentage explicitly, and keeps the `stretch`-based solution only where `stretch` is supported:

```css
.custom-select::picker(select) {
    --viewport-margin: 1em;
    max-block-size: calc(100% - var(--viewport-margin));
    @supports (max-block-size: stretch) {
        max-block-size: stretch;
        margin-block-end: var(--viewport-margin);
    }
}
```

This even does the right thing when the picker flips above the button. (It carries a subtle imperfection in the percent path — see the final section.)

## Fixing Chrome & Safari: flip-* fallbacks carry the margin across

Chrome and Safari need the margin to move when the picker flips. **Anchored container queries** could restyle on flip, but Safari does not support them. The better, Safari-supported approach replaces the specific UA `position-try-fallbacks` with the `flip-*` keywords:

```css
.custom-select::picker(select) {
    --viewport-margin: 1em;
    max-block-size: calc(100% - var(--viewport-margin));
    position-try-fallbacks:
        flip-block,
        flip-inline,
        flip-block flip-inline;
    @supports (max-block-size: stretch) {
        max-block-size: stretch;
        margin-block-end: var(--viewport-margin);
    }
}
```

The `flip-*` values come with "dark magic": when a flip takes effect the browser also tries to flip *other* properties. It works for some and not others (see the spec). Margins are among those it flips, so when the picker flips above the button the `margin-block-end` is treated as a `margin-block-start` — exactly what is wanted. The CSS Working Group has resolved to change the default `position-try-fallbacks` for select pickers to something similar, so this override should become unnecessary in future.

Source: [The Goldilocks customizable select height](https://jakearchibald.com/2026/goldilocks-select-height/) §§ Prevent the picker from hitting the viewport edge / Fixing Firefox / Fixing Chrome & Safari, Jake Archibald, jakearchibald.com, posted 2026-06-29; fetched 2026-06-29 via direct curl, content SHA-256 `a73ec7f2`.
