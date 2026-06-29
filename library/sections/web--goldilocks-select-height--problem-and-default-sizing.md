---
title: "The Goldilocks picker-height problem and the default UA sizing of ::picker(select)"
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

The "Goldilocks" sizing problem for the **customizable (fully stylable) `<select>`** picker: across nearly every customizable-select demo there is one picker height that is "just right" — not so tall it overflows the viewport, not so short it is unusable, not so large it dwarfs a two-option list — yet expressing that in CSS is hard enough that the author (and several browser engineers he asked) initially failed. The eventual answer rests on `calc-size()`, intrinsic sizes, and anchor-positioning fallbacks (covered in the sibling sections); this section frames the problem and captures the **default user-agent (UA) sizing** that the customization starts from.

## Customizable select and how the demos are built

Customizable `<select>` is the in-progress web platform feature that makes the native select's drop-down (the "picker") fully stylable with CSS. As of mid-2026 Firefox and Safari are actively implementing it but have not shipped; Chrome has it. To make the demos work in more browsers and inspectable in DevTools, the author builds them not from a real custom select but from the **same underlying primitives** custom select uses: the **popover** API and **CSS anchor positioning**. So the sizing technique is really a technique for sizing a popover anchored to a button — the picker is just the most important instance of it.

## The default UA styles for `::picker(select)`

The picker is targeted with the `::picker(select)` pseudo-element. The UA default styles that govern its position and height are:

```css
::picker(select) {
    margin: 0;
    inset: auto;
    min-inline-size: anchor-size(self-inline);
    max-block-size: stretch;
    position-area: self-block-end span-self-inline-end;
    position-try-order: most-block-size;
    position-try-fallbacks:
        self-block-start span-self-inline-end,
        self-block-end span-self-inline-start,
        self-block-start span-self-inline-start;
    /* Not part of the spec, but something Chrome does, so it is included */
    min-block-size: 1lh;
}
```

What each line does:

- `min-inline-size: anchor-size(self-inline)` — the picker is always at least as wide as the `<select>` button (the anchor), via `anchor-size()`.
- `max-block-size: stretch` — the picker never overflows the viewport: its `stretch` size is the full anchor-positioning cell (from the edge of the button to the edge of the viewport).
- `position-area: self-block-end span-self-inline-end` — the default anchor-positioning cell is below the button, spanning from its left edge to the right edge of the viewport.
- `position-try-fallbacks` — alternate cells (above the button, clamped to the button's right edge) the picker may fall back into when it does not fit.
- `position-try-order: most-block-size` — the picker initially appears in whichever fallback cell offers the most block-axis (vertical, in horizontal writing modes) space. This does not currently work in Firefox or Safari (the spec was unclear; both have open tickets).
- `min-block-size: 1lh` — a Chrome-only (non-spec) floor of one line height.

These are a reasonable starting point, but several UX improvements are possible: keeping the picker off the viewport edge, stopping it from becoming unusably small, and stopping it from becoming uselessly tall — the subject of the remaining sections.

Source: [The Goldilocks customizable select height](https://jakearchibald.com/2026/goldilocks-select-height/) § Default sizing, Jake Archibald, jakearchibald.com, posted 2026-06-29; fetched 2026-06-29 via direct curl, content SHA-256 `a73ec7f2`.
