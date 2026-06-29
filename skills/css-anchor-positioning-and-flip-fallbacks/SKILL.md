---
created: 2026-06-29
updated: 2026-06-29
author: gardener
---

# Skill: css-anchor-positioning-and-flip-fallbacks

Anchor a popover, menu, tooltip, or picker to a control and keep it on-screen.
CSS anchor positioning ties an absolutely- or fixed-positioned element to an
**anchor element** and places/sizes it relative to that anchor with `anchor()`,
`anchor-size()`, and `position-area`; `position-try-fallbacks` then lists the
alternate placements the browser flips into when the element would overflow a
viewport edge, so the popover repositions itself instead of running off-screen.
This is the **positioning** counterpart to the sizing primitive in
[css-intrinsic-and-content-sizing](../css-intrinsic-and-content-sizing/SKILL.md):
that skill makes the box the right size, this one puts it in the right place and
keeps it there.

The technique is grounded in the MDN CSS anchor-positioning reference
(library: `web--mdn-css-anchor-positioning--{overview,anchor-function,anchor-size-function,position-area-grid,position-try-fallbacks-and-flip,position-try-order-and-visibility,browser-support}`),
the CSS Working Group's Anchor Positioning Level 1 draft for the normative
flip semantics (library:
`web--csswg-css-anchor-position-1--{try-tactic-flip-semantics,position-try-order-and-descriptors}`),
and Jake Archibald's customizable-`<select>` essay as the applied walkthrough
(library: `web--goldilocks-select-height--{problem-and-default-sizing,viewport-margin-and-flip-fallbacks}`).

A [web-designer](../../roles/web-designer/AGENT.md) reaches for this when a design
needs a floating element pinned to a control and resilient at the viewport edge;
a [web-builder](../../roles/web-builder/AGENT.md) implements it. The per-feature
`@supports` gating it depends on is the separate discipline
[supports-feature-query-progressive-enhancement](../supports-feature-query-progressive-enhancement/SKILL.md).

## When to use

- A floating element must be **pinned to a control**: a popover to its invoker, a
  dropdown menu to its button, a tooltip to its trigger, an autocomplete list to
  its input, a customizable-`<select>` picker to its `<select>`.
- The element must **stay on-screen**: when the default placement (say, below the
  anchor) would overflow a viewport edge, it should flip to the opposite side
  rather than clip or scroll off.
- You want the popover sized **relative to the anchor** — "at least as wide as the
  button," "no taller than the cell between the anchor and the viewport edge."
- You are reaching for JavaScript position math (measuring `getBoundingClientRect`
  and writing `top`/`left` on scroll/resize, or a positioning library). Anchor
  positioning does this declaratively in CSS, including the on-overflow flip.

If the floating element never risks overflowing and never needs to track an
anchor's geometry, plain static/relative positioning is enough and you do not need
this machinery.

## Establishing the anchor relationship

Two roles, bound by name. The **anchor element** publishes a dashed-ident with
`anchor-name`; the **anchor-positioned element** must be `position: absolute` or
`position: fixed` and binds to that name with `position-anchor`, which makes it the
element's **default anchor**. With a default anchor set, the `anchor()` and
`anchor-size()` functions may omit the name and operate against it.

```css
/* anchor element */
.menu-button {
  anchor-name: --menu-button;
}

/* anchor-positioned element */
.menu {
  position: fixed;            /* or absolute — required, or the anchor fns have nothing to place */
  position-anchor: --menu-button;
  /* placement and sizing below */
}
```

`anchor-scope` limits where an `anchor-name` is visible so the same name can be
reused in different subtrees without collision. The popover API pairs naturally
with this: a `popover` is the top-layer element and anchor positioning is how it
is placed next to its invoker — the same primitive pair a customizable-`<select>`
picker is built from.

## Placement: anchor() and position-area

Two levels. `anchor()` is the low-level, per-side primitive; `position-area` is
the high-level shorthand most designs should reach for first.

**`anchor(<anchor-name>? <anchor-side> , <fallback>?)`** resolves to the position
of one edge/point of the anchor, used as the value of an inset property
(`top`/`bottom`/`left`/`right`, `inset-block-start`, …). Sides: physical
`top`/`bottom`/`left`/`right`; logical `start`/`end`/`self-start`/`self-end`;
`center`; or a `<percentage>` along the side. The inset's axis must match the side
requested (a `top`/`bottom` inset takes a vertical side); a mismatch falls to the
optional `<fallback>` length, or invalidates the declaration if none is given.
Per-side placement is commonly paired with a `translate` to center on an edge:

```css
.tooltip {
  position: absolute;
  position-anchor: --my-button;
  top: anchor(bottom);    /* sit just below the button */
  left: anchor(center);   /* align to the button's horizontal center */
  translate: -50% 0;      /* pull back half the tooltip's width */
}
```

**`position-area`** is the shorthand: it names a cell (or span of cells) of a 3×3
grid centered on the anchor, and the element is placed in that region. Two
keywords pick a cell (a single keyword implies `center` on the other axis); the
anchor occupies the center. Region keywords are physical (`top`/`bottom`/`left`/
`right`/`center`) or logical (`block-start`/`block-end`/`inline-start`/
`inline-end`, `start`/`end`, and `self-*` forms) — **do not mix physical and
logical in one `position-area`**. The `span-*` keywords (`span-block-end`,
`span-inline-start`, …, and `span-all`) widen the placement across more of the
grid.

```css
.menu {
  position: fixed;
  position-anchor: --menu-button;
  position-area: block-end span-inline-end;  /* below the button, spanning to the inline-end edge */
}
```

The chosen region is also the element's **inset-modified containing block**, which
is what makes `max-block-size: stretch` mean "fill the cell, anchor edge to
viewport edge" — the hook that ties placement to sizing.

## Sizing: anchor-size()

**`anchor-size(<anchor-name>? <anchor-size>? , <fallback>?)`** resolves to one
dimension of the anchor, valid in sizing properties (`width`/`height`, `min-*`,
`max-*`, `inline-size`/`block-size`) and inside `calc()`. Dimensions: physical
`width`/`height`; logical `inline`/`block`; and `self-*` variants measured against
the positioned element's own writing mode. This is what makes a popover "always at
least as wide as its button":

```css
.menu {
  min-inline-size: anchor-size(self-inline);          /* never narrower than the anchor */
  width: calc(anchor-size(self-inline) + 2rem);       /* or derive a size in calc() */
}
```

`anchor-size()` composes with the intrinsic-size + `calc-size()` clamping toolkit
([css-intrinsic-and-content-sizing](../css-intrinsic-and-content-sizing/SKILL.md)):
the anchor's dimension sets a floor or ceiling while `calc-size()` arithmetic on
`fit-content`/`stretch` clamps the rest.

## Keeping it on-screen: position-try-fallbacks and the flip tactics

`position-try-fallbacks` lists alternative placements the browser tries, **in
order**, when the element would overflow in its initial position. Each entry is one
of three forms: a predefined **try tactic** (`flip-block`, `flip-inline`,
`flip-start`), a `position-area` value, or a named `@position-try` option.

A **try tactic** mirrors the placement across an axis:

- **`flip-block`** — mirror across the block axis (an element placed above the
  anchor that overflows the top is re-placed below it).
- **`flip-inline`** — mirror across the inline axis (to the opposite horizontal
  side in horizontal writing modes).
- **`flip-start`** — mirror diagonally, swapping the block and inline axes.

Multiple tactics may be **space-combined** in one entry; the browser composes them
left-to-right, useful when the element nears two edges at once:

```css
.menu {
  position: fixed;
  position-anchor: --menu-button;
  position-area: block-start span-inline-end;
  position-try-fallbacks:
    flip-block,
    flip-inline,
    flip-block flip-inline;   /* composed: the diagonal-opposite cell */
}
```

A `position-area` value can be a fallback entry directly (`position-try-fallbacks:
top, top right, right, …`), but unlike the flip tactics, `position-area` values
**cannot** be space-combined within one entry. For a fallback that changes more
than placement, define a named `@position-try --name { … }` option and reference
it; its declarations override while active and unset when a later scroll selects a
different option.

### What a flip flips — the "dark magic"

The decisive behavior, and the reason the flip tactics are preferred over other
fallback-conditional styling: a tactic does not only move the element — it also
**swaps the values of the axis-paired properties** that came with the placement.
The CSSWG draft defines each tactic geometrically as a mirroring, and the mirror
swaps the corresponding pair. For `flip-block` that means:

- the block-axis inset pair (`inset-block-start` ↔ `inset-block-end`, i.e.
  `top` ↔ `bottom` in horizontal writing modes);
- the block-axis **margin** pair (`margin-block-start` ↔ `margin-block-end`);
- the block component of `position-area` (a `block-start` region becomes
  `block-end`);
- the block-axis self-alignment.

So a `margin-block-end` set to hold the popover off the viewport edge in the
below-anchor case is treated as a `margin-block-start` once `flip-block` puts the
popover **above** the anchor — exactly the desired behavior. `flip-inline` does
the same on the inline axis; `flip-start` swaps the start-pair and end-pair across
the diagonal (`margin-block-start` ↔ `margin-inline-start`). The tactics operate
on the **logical** properties; `flip-x`/`flip-y` are the physical-axis
equivalents. Logical directions resolve against the containing block's writing
mode.

**What is NOT flipped is a deliberate spec gap.** The draft defines tactics by
their geometric effect and does not enumerate every affected property;
implementations derive the set from the geometry, so the flip "works for some
properties and not others." The reliable, portable subset is the directional
logical pairs — insets, margins, `position-area`, self-alignment. A single-value
`width`/`block-size`, a non-directional `background`, a `translate` are **not**
mirrored. Verify anything outside the logical-pair subset per-engine rather than
assuming it flips.

### Proactive selection: position-try-order

By default a fallback is applied only when the initial position overflows.
`position-try-order` instead picks, at initial display, the fallback that
**maximizes** a dimension: `most-width`, `most-height`, `most-block-size`,
`most-inline-size` (or `normal`, the default). The candidate list is **stably
sorted** by the available dimension, largest first, so the `position-try-fallbacks`
order is the tiebreak among equal-space options. If no fallback offers more space
than the initial position, the property has no effect. The `position-try`
shorthand bundles order plus fallbacks: `position-try: most-height --a, flip-block`.

Note the support gap: `position-try-order: most-*` does **not** work in Firefox or
Safari as of mid-2026, so treat proactive selection as an enhancement, not a load-
bearing behavior.

### The applied exemplar: the picker margin that survives a flip

The UA default `::picker(select)` sizes and places the picker entirely with these
primitives (`min-inline-size: anchor-size(self-inline)`, `max-block-size:
stretch`, `position-area: self-block-end span-self-inline-end`,
`position-try-order: most-block-size`, a `position-try-fallbacks` cell list). The
goldilocks essay's UX fix — keep the picker off the viewport edge with a margin
that behaves correctly when it flips above the button — is the canonical small
example of the whole technique:

```css
.custom-select::picker(select) {
  --viewport-margin: 1em;
  /* Firefox lacks max-block-size: stretch — subtract the margin from a percentage */
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

Because margins are in the flipped set, when the picker flips above the button the
`margin-block-end` is honored as a `margin-block-start` — the gap stays on the
correct side. (The CSS Working Group has resolved to change the default
`position-try-fallbacks` for select pickers to something similar, so this explicit
override should become unnecessary in future.) The essay chose `flip-*`
property-flipping over an **anchored container query** precisely because Safari
lacks anchored container queries but supports the flip tactics — see Limitations.

## Browser support (mid-2026 — re-confirm at authoring time)

The headline: **Chrome ships the full feature; Firefox and Safari support the core
and the `flip-*` fallbacks but lag on the newer pieces.** Because the gaps are
per-feature, the gate is per-feature too — `@supports` around the specific
construct, not one "supports anchor positioning" check.

| Capability | Chrome | Firefox | Safari |
|---|---|---|---|
| Core (`anchor-name`, `position-anchor`, `anchor()`, `anchor-size()`, `position-area`) | ✅ | ✅ | ✅ |
| `position-try-fallbacks` with `flip-*` tactics | ✅ | ✅ | ✅ |
| `position-try-order: most-*` | ✅ | ❌ | ❌ |
| `position-visibility` | ✅ | partial | partial |
| Anchored container queries (`container-type: anchored`, `@container anchored()`) | ✅ | in progress | ❌ |
| `calc-size()` (to clamp anchored sizes) | ✅ | ❌ | ❌ |
| `max-block-size: stretch` (fill the cell) | ✅ | ❌ (use `calc(100% - margin)`) | ✅ |
| Customizable `<select>` / `::picker(select)` | ✅ | implementing | implementing |

The durable rules behind the table:

- **`flip-*` fallbacks are universal** — a popover that only flips on overflow
  works everywhere with no gate.
- **`calc-size()` is Chrome-only** — any anchored-size clamping must
  `@supports`-gate and ship a fallback.
- **Firefox lacks `max-block-size: stretch`** — fall back to `max-block-size:
  calc(100% - var(--viewport-margin))`.
- **Safari lacks anchored container queries** — prefer `flip-*` property-flipping
  over `@container anchored()` for fallback-conditional margins/insets.

## Procedure

1. **Name the anchor relationship.** Put `anchor-name: --x` on the control and
   `position: fixed|absolute` + `position-anchor: --x` on the floating element.
2. **Choose placement.** Reach for `position-area` (a cell of the 3×3 grid) first;
   drop to per-side `anchor()` (plus `translate` for centering) only when you need
   finer control. Keep physical and logical keywords un-mixed.
3. **Size from the anchor where the design calls for it.** `min-inline-size:
   anchor-size(self-inline)` for "at least as wide as the control";
   `max-block-size: stretch` (with the Firefox fallback) for "fill the cell."
   Clamp the rest with `calc-size()` per
   [css-intrinsic-and-content-sizing](../css-intrinsic-and-content-sizing/SKILL.md).
4. **List the overflow fallbacks.** `position-try-fallbacks` with the `flip-*`
   tactics (space-combine for two-edge cases), or `position-area` entries, or named
   `@position-try` options. Order matters — it is the tiebreak.
5. **Let directional properties ride the flip.** Express edge-margins and insets as
   the **logical block/inline pairs** (`margin-block-end`, `inset-block-start`) so a
   `flip-*` carries them to the correct side automatically; do not hand-write a
   per-fallback margin for anything in the flipped subset.
6. **Gate per-feature.** `@supports`-gate `calc-size()`, `max-block-size: stretch`,
   `position-try-order`, and anchored container queries with fallbacks, per
   [supports-feature-query-progressive-enhancement](../supports-feature-query-progressive-enhancement/SKILL.md).
   Leave `flip-*` ungated.
7. **Verify** across a full-feature engine (Chrome) and a lagging engine
   (Firefox/Safari) per the checklist.

## Verification

- **Placement.** The element appears in the intended cell relative to the anchor
  (below the button, centered, etc.) at rest.
- **Flip on overflow.** Scroll or shrink the viewport so the default placement
  would clip; confirm the element flips to a fallback cell instead of overflowing,
  and that **directional properties followed it** — an edge-margin/inset stays on
  the side facing the viewport edge, not stranded on the original side.
- **Two-edge case.** Drive the element toward a corner; confirm a space-combined
  tactic (`flip-block flip-inline`) lands it in the diagonal-opposite cell.
- **Sizing from anchor.** `anchor-size()`-derived bounds track the anchor (resize
  the control; the popover's min-width follows).
- **Per-engine gates.** On a `calc-size()`/`stretch` engine the enhanced path is
  active; on Firefox the `calc(100% - margin)` fallback keeps the element off the
  viewport edge; on Safari `flip-*` (not anchored container queries) carries the
  flip-conditional styling.
- **Writing mode.** If the surface supports right-to-left or vertical text, confirm
  the logical placement and the flip behave under a non-default writing mode.

## Limitations (call these out in the design)

- **The flip set is not fully enumerated.** Only the directional logical pairs
  (insets, margins, `position-area`, self-alignment) reliably flip. A bare
  `width`/`block-size`, a `translate`, a non-directional property are carried
  through unchanged. Do not rely on a flip moving anything outside the logical-pair
  subset without per-engine verification.
- **Per-feature support, not a single gate.** `flip-*` is universal but
  `position-try-order` (Firefox/Safari), anchored container queries (Safari),
  `calc-size()` (Chrome-only), and `max-block-size: stretch` (not Firefox) each have
  their own gap. Gate each construct separately; a single "anchor positioning"
  capability check is wrong.
- **Prefer flip-* over anchored container queries for flip-conditional styling.**
  Anchored container queries are the cleaner abstraction but Safari does not support
  them; property-flipping via `flip-*` is the portable path for fallback-conditional
  margins/insets.
- **The positioned element must be `position: absolute`/`fixed`.** Anchor functions
  have nothing to place on a statically positioned element.
- **This is the positioning half.** Sizing the box (content-or-space clamping with
  `calc-size()`) is
  [css-intrinsic-and-content-sizing](../css-intrinsic-and-content-sizing/SKILL.md);
  the `@supports` discipline is
  [supports-feature-query-progressive-enhancement](../supports-feature-query-progressive-enhancement/SKILL.md).
  This skill assumes both.

## Output

The deliverable is the anchor-positioning CSS landed on the floating element: the
`anchor-name`/`position-anchor` binding, the `position-area` (or `anchor()`)
placement, any `anchor-size()`-derived bounds, the `position-try-fallbacks` list
(flip tactics expressed so directional margins/insets ride the flip), and the
per-feature `@supports` gates with fallbacks — plus a design note recording the
anchor relationship, the placement and its fallbacks, which directional properties
are relied on to flip, and the per-feature browser-support caveats.

## Notes from the field

(Append; terse and dated.)

- _2026-06-29_: initial write (job `author-css-anchor-positioning-and-flip-fallbacks`).
  Grounded in the MDN anchor-positioning reference (7 sections), the CSSWG Anchor
  Position Level 1 draft (the normative flip-semantics: tactics are defined
  geometrically as axis-mirrors that swap logical pairs, with the affected set left
  to implementations — so the portable subset is insets/margins/`position-area`/
  self-alignment), and the goldilocks-select essay's margin-that-survives-a-flip as
  the applied exemplar. Encodes the mid-2026 gate: Chrome full; `flip-*` universal;
  Safari no anchored container queries; `calc-size()` Chrome-only; Firefox no
  `max-block-size: stretch`. The deferred third skill from the
  `author-web-designer-css-skills` proposal, now authorable after the dedicated
  source ingest. Pairs with
  [css-intrinsic-and-content-sizing](../css-intrinsic-and-content-sizing/SKILL.md)
  (sizing) and
  [supports-feature-query-progressive-enhancement](../supports-feature-query-progressive-enhancement/SKILL.md)
  (gating).
