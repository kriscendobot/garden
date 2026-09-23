---
title: "Clamping the picker between a minimum and maximum with calc-size() and intrinsic sizes"
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

The core of the technique: clamp the picker's height between a sensible minimum (so it never becomes unusably small near the viewport edge) and a sensible maximum (so it never grows uselessly tall), while still respecting the picker's *intrinsic* content height for short lists. The key primitive is **`calc-size()`**, which is what unlocks doing arithmetic on an intrinsic size — the piece the author was missing until Ian Kilpatrick pointed it out. This section captures the too-small fix, the too-big fix, and the `@supports` fallback for browsers without `calc-size()`.

## Why a plain min-block-size is not enough

Raising Chrome's `min-block-size: 1lh` floor to, say, `12em` stops the picker shrinking to nothing — but it then forces a too-tall box around a picker that has only a few options. What is wanted is `min(fit-content, 12em)`: take the content's natural height, but never exceed 12em as a floor. The problem is that `min()` does **not** accept intrinsic sizes like `fit-content`.

## calc-size(): arithmetic on an intrinsic size

`calc-size()` solves exactly this. Its first argument names an intrinsic size; its second performs a calculation in which the `size` keyword stands for that intrinsic size:

```css
.custom-select::picker(select) {
    min-block-size: calc-size(fit-content, min(size, 12em));
}
```

This reads: take `fit-content`, and use the smaller of (that content size) or 12em as the minimum. It works in Chrome; Firefox and Safari do not yet support `calc-size()` (both have open tickets).

## The @supports fallback for the minimum

Where `calc-size()` is unavailable, fall back to a fixed minimum, but drop it for genuinely short pickers detected structurally with `:has()` + `:nth-of-type()`:

```css
.custom-select::picker(select) {
    --min-size: 12em;
    min-block-size: var(--min-size);
    /* The calc-size way */
    @supports (min-block-size: calc-size(fit-content, min(size, 1px))) {
        min-block-size: calc-size(fit-content, min(size, var(--min-size)));
    }
    /* The hacky fallback */
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

That is: set a 12em minimum; if `calc-size()` is supported use it; otherwise, when the picker has fewer than 4 options and fewer than 2 optgroups, remove the minimum and let it shrink to `fit-content`.

## The maximum, also via calc-size() on stretch

Capping the height needs a second maximum alongside the existing viewport-margin maximum, combined with `min()`. Because one of the two maxima is the intrinsic `stretch` size, `calc-size()` is needed again — this time to let `stretch` participate in the `min()` calculation:

```css
.custom-select::picker(select) {
    --max-size: 30em;
    --viewport-margin: 1em;
    max-block-size: min(calc(100% - var(--viewport-margin)), var(--max-size));
    position-try-fallbacks:
        flip-block,
        flip-inline,
        flip-block flip-inline;
    @supports (max-block-size: calc-size(stretch, min(size, 1px))) {
        max-block-size: calc-size(stretch, min(size, var(--max-size)));
        margin-block-end: var(--viewport-margin);
    }
}
```

Source: [The Goldilocks customizable select height](https://jakearchibald.com/2026/goldilocks-select-height/) §§ Prevent the picker from getting too small / too big, Jake Archibald, jakearchibald.com, posted 2026-06-29; fetched 2026-06-29 via direct curl, content SHA-256 `a73ec7f2`.
