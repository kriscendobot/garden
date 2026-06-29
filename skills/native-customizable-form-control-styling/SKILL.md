---
created: 2026-06-29
updated: 2026-06-29
author: gardener
---

# Skill: native-customizable-form-control-styling

Style the **native** `<select>` — its closed button, drop-down picker, arrow icon,
selection checkmark, and each `<option>` — with HTML and CSS alone, instead of
rebuilding the control as a `<div role="listbox">`-and-JavaScript widget. You opt
in with `appearance: base-select`, add a `<button><selectedcontent></selectedcontent></button>`
first child, and target the parts with their pseudo-elements (`::picker(select)`,
`::picker-icon`, `::checkmark`) and pseudo-classes (`:open`, `:checked`). The
decisive reason to do this rather than hand-roll a widget is everything the
platform keeps owning for free: the accessibility tree, keyboard interaction,
focus management, form participation, and the submittable value. Because support
is partial in mid-2026, the whole thing ships as a **progressive enhancement**
behind an `@supports (appearance: base-select)` gate that falls back to a classic
native `<select>`.

The technique is grounded in MDN's "Customizable select elements" guide and its
reference pages, ingested 2026-06-29
(library concept: `customizable-select`; sections:
`web--mdn-customizable-select--{background-and-feature-inventory,markup-and-opt-in,styling-the-parts,popover-and-anchor-positioning,accessibility-and-browser-support}`;
plus `web--mdn-appearance-base-select`, `web--mdn-selectedcontent`,
`web--mdn-picker-select-pseudo-element`).

A [web-designer](../../roles/web-designer/AGENT.md) reaches for this when a design
needs a styled drop-down and the control is genuinely a single-select `<select>`;
a [web-builder](../../roles/web-builder/AGENT.md) implements it. It composes with
three sibling skills: the picker is positioned and kept on-screen with
[css-anchor-positioning-and-flip-fallbacks](../css-anchor-positioning-and-flip-fallbacks/SKILL.md),
sized with
[css-intrinsic-and-content-sizing](../css-intrinsic-and-content-sizing/SKILL.md),
and gated with
[supports-feature-query-progressive-enhancement](../supports-feature-query-progressive-enhancement/SKILL.md).

## When to use

- A design calls for a **styled drop-down** — custom border, background, fonts,
  icons inside options, a recolored arrow, an animated open/close — and the
  underlying control is a **single-select** picker (display one value, choose one).
- You want to keep the control's native semantics: it must submit a form value,
  be keyboard-operable, expose a correct accessible name, and survive without
  JavaScript.
- You are tempted to build a `<div>`/`<ul>` listbox widget to get the styling.
  Prefer the native customizable `<select>` where support allows; the widget is a
  large accessibility liability you would have to re-implement and keep correct.

Do **not** reach for this when the control is a multi-select **listbox** (display
many options at once, choose one or several) — that is a separate platform guide
("Customizable select listboxes") and a different markup. And weigh the support
reality below: in mid-2026 only Chrome ships it, so the *baseline* a non-supporting
browser falls to (a classic native `<select>`) must itself be acceptable.

## Why the native control over a `<div>` widget

This is the load-bearing argument; lead the design with it. A customizable
`<select>` is **still a real `<select>`**, so the platform keeps providing the
behavior a hand-built widget must otherwise reconstruct and maintain:

- **A submittable form value.** The selected `<option>` participates in form
  submission. When option content is a multi-level DOM sub-tree rather than plain
  text, the value is derived deterministically: the browser takes the selected
  option's `textContent`, runs `trim()`, and uses the result.
- **One control, one focus stop.** The first-child `<button>` (the select button)
  is **inert by default** — interactive children inside it are not separately
  focusable or clickable, so the whole control is a single tab stop, exactly like
  a classic select.
- **Keyboard, focus, and open/closed state are the platform's**, surfaced to CSS
  through `:open` (button while the picker is open) and `:checked` (the selected
  option) rather than re-implemented in script.
- **The accessibility tree is maintained automatically.** A `<div>` listbox needs
  `role`, `aria-expanded`, `aria-activedescendant`, arrow-key handling, type-ahead,
  and focus trapping all written and tested by hand; the native control ships them.

The trade is the support gap, not the semantics. That is why the pattern is
framed as a progressive enhancement, not a replacement.

## Markup and the opt-in

The markup is a classic `<select>` plus two additions: the select button and
richer option content.

```html
<form>
  <label for="pet-select">Select pet:</label>
  <select id="pet-select">
    <!-- The select button: shown when the picker is closed. -->
    <button>
      <selectedcontent></selectedcontent>
    </button>

    <option value="">Please select a pet</option>
    <option value="cat">
      <span class="icon" aria-hidden="true">🐱</span
      ><span class="option-label">Cat</span>
    </option>
    <option value="dog">
      <span class="icon" aria-hidden="true">🐶</span
      ><span class="option-label">Dog</span>
    </option>
  </select>
</form>
```

- **The `<button><selectedcontent></selectedcontent></button>` first child** is
  the styleable closed-select button. `<selectedcontent>` holds a `cloneNode()`
  clone of the currently-selected `<option>`'s content, so the closed button shows
  the live selection and you can style that clone independently. Omit this
  structure and the browser renders a default button that is harder to style.
- **Rich `<option>` content.** Options may now contain images, non-interactive
  text-level elements, and `::before`/`::after` generated content (generated
  content is *not* part of the submittable value). Here each option is an icon
  `<span>` + a label `<span>`, styleable separately.
- **Value extraction.** Because option content can be a sub-tree, the value rule
  is `trim(selectedOption.textContent)` — keep that in mind when an option's
  visible text and its intended value differ.

Opt in by setting `appearance: base-select` on **both** the `<select>` and its
`::picker(select)`:

```css
select,
::picker(select) {
  appearance: base-select;
}
```

You may opt in only the `<select>` and leave the picker with OS styling, but
**you cannot opt in the picker without opting in the `<select>`.** Once opted in
the control renders very plainly and is yours to style.

## Styling the parts

Each part has one selector. The catalog:

| Part | Selector | Notes |
|---|---|---|
| Closed select button (open state) | `:open` | matches the button only while the picker is open |
| Selected value in the closed button | `selectedcontent` (and descendants) | the cloned selection; style independently of the picker |
| Drop-down picker container | `::picker(select)` | everything inside `<select>` except the button |
| Arrow icon | `::picker-icon` | decorative; outside the a11y tree |
| Selected option (in the picker) | `option:checked` | |
| Selection checkmark | `::checkmark` | decorative; outside the a11y tree |
| Option groups | `<optgroup>`, `<legend>` | `<legend>` is a styleable group label |

```css
/* The picker icon, rotated when open. */
select::picker-icon { color: #999999; transition: 0.4s rotate; }
select:open::picker-icon { rotate: 180deg; }

/* The picker container. Target one select with #id::picker(select). */
::picker(select) { border: none; border-radius: 8px; }

/* Options are display: flex by default in a customizable select. */
option {
  display: flex;
  justify-content: flex-start;
  gap: 20px;
  padding: 10px;
  transition: 0.4s;
}
option:nth-of-type(odd) { background: white; }    /* zebra-striping */
option:hover, option:focus { background: plum; }
option:checked { font-weight: bold; }

/* The cloned selection in the closed button — hide the icon there only. */
selectedcontent .icon { display: none; }

/* Re-style or move the checkmark. */
option::checkmark { order: 1; margin-left: auto; content: "☑️"; }
```

Notes that bite:

- **`::picker(select)`'s argument names the element type** (`select`). Combine
  with another selector to reach one control: `#pet-select::picker(select)`.
- **`<optgroup>` becomes an ordinary block container** in a customizable select
  and `<legend>` is its styleable label, replacing the `label` attribute with the
  same semantics — so grouping stays announced.
- **Vertical-align option icons with `text-box`** (`text-box: trim-both cap
  alphabetic`) rather than fragile line-height hacks.

## Animating and positioning the picker

The select button and picker are wired up automatically: an **invoker/popover**
relationship (Popover API) and an **implicit anchor reference** (CSS anchor
positioning) you get without writing `anchor-name` / `position-anchor`.

**Animate** between hidden and shown popover states by transitioning the picker
with `allow-discrete` (so the discrete `display` and `overlay` properties the
default styles set also animate) and seeding the entry with `@starting-style`:

```css
::picker(select) {
  opacity: 0;
  transition: all 0.4s allow-discrete;
}
:open::picker(select) { opacity: 1; }
@starting-style {
  :open::picker(select) { opacity: 0; }
}
```

(Animating `display` keeps the other transitions visible across the
`none`↔`block` switch; animating `overlay` defers top-layer removal until the
exit transition finishes.)

**Position** the picker relative to its anchor (the button) with `anchor()`,
since the anchor reference is implicit:

```css
::picker(select) {
  top: calc(anchor(bottom) + 1px);   /* just below the button */
  left: anchor(10%);                 /* 10% across the button's width */
}
```

The browser also ships default `position-try` fallbacks that reposition the
picker if it would overflow the viewport. For non-default placement, sizing, and
flip behavior, this is exactly the
[css-anchor-positioning-and-flip-fallbacks](../css-anchor-positioning-and-flip-fallbacks/SKILL.md)
and [css-intrinsic-and-content-sizing](../css-intrinsic-and-content-sizing/SKILL.md)
toolkit — the customizable `<select>` is the control those skills' picker
examples are built around. To **detach** the implicit anchor, set the picker's
`position-anchor` to a name that does not exist (e.g. `--not-an-anchor-name`).

## Accessibility: what you get, and what you can still break

The native control keeps the accessibility tree, but custom content can corrupt
it. The rules:

- **Don't let button content corrupt the accessible name.** Arbitrary content in
  the `<button>` "can alter the accessible value exposed to assistive technology
  for the `<select>`." Choose button content with the exposed name in mind.
- **Hide decorative content explicitly.** Mark option icons `aria-hidden="true"`
  so they are not announced and the value is not read twice ("cat cat").
- **Pseudo-element `content` is not announced.** `::checkmark` and `::picker-icon`
  sit **outside** the accessibility tree, so a glyph set via `content` is
  decorative only — it must make visual sense on its own and must not be the only
  signal of selection.
- **Group labels stay announced** via `<legend>` inside `<optgroup>`.
- **Keyboard, focus, and open/closed state are the platform's** — do not
  re-implement them; read them in CSS via `:open` / `:checked`.

## Browser support (mid-2026 — re-confirm at authoring time)

MDN labels the feature **"Limited availability" / not Baseline**: "not Baseline
because it does not work in some of the most widely-used browsers." As of the
2026-04-06 capture:

| Capability | Chrome | Firefox | Safari |
|---|---|---|---|
| Customizable `<select>` / `appearance: base-select` | ✅ | implementing | implementing |
| `<selectedcontent>` (also marked **Experimental**) | ✅ | implementing | implementing |
| `::picker(select)`, `::checkmark`, `::picker-icon` | ✅ | implementing | implementing |

So in mid-2026 only **Chrome ships**; Firefox and Safari are actively
implementing but have not released. Two cautions the guide raises:

- **Framework interference.** Some JS frameworks block these features; in others
  they cause **hydration failures** under server-side rendering. Test inside your
  actual framework.
- **Dynamic-content staleness.** `<selectedcontent>` is re-cloned **only when the
  selected option changes** — mutating the selected option's content after render
  does not re-clone automatically; update it manually. This bites frameworks that
  mutate `<option>` nodes after the initial render.

Confirm current support on the building-block reference pages (`<selectedcontent>`,
`::picker(select)`, `::checkmark`) rather than trusting this table at read time.

## Falling back: the `@supports` gate

Ship the enhancement behind the per-feature gate
([supports-feature-query-progressive-enhancement](../supports-feature-query-progressive-enhancement/SKILL.md)).
The baseline a non-supporting browser falls to is a **working classic native
`<select>`**: the `<button><selectedcontent></selectedcontent></button>`
structure is ignored and non-text option content is stripped to its text nodes,
but the control still functions. That graceful degradation is what makes the
pattern a safe progressive enhancement.

```css
/* Baseline: classic native select. Style only what a classic select allows
   (you cannot reach the picker here). Keep it usable on its own. */
select { /* font, color, the styleable bits of a classic select */ }

/* Enhancement: only where appearance: base-select is understood. */
@supports (appearance: base-select) {
  select,
  ::picker(select) { appearance: base-select; }
  /* …all the part styling above… */
}
```

Probe the exact construct (`appearance: base-select`), put the rich part-styling
inside the positive block so non-supporting engines never see selectors they
can't honor, and keep the baseline classic select genuinely usable — it is the
real experience for most browsers until Firefox and Safari ship.

## Procedure

1. **Confirm the control is a single-select `<select>`.** If it is a multi-select
   listbox, this is the wrong guide. If a `<div>` widget is on the table, prefer
   the native control for the accessibility/keyboard/form semantics — state that
   trade in the design.
2. **Write the markup**: the `<button><selectedcontent></selectedcontent></button>`
   first child, plus any rich `<option>` content with decorative parts
   `aria-hidden`. Mind the `trim(textContent)` value rule.
3. **Opt in** with `appearance: base-select` on both `select` and
   `::picker(select)` — **inside the `@supports` block.**
4. **Style the parts** via their selectors (`::picker(select)`, `::picker-icon`,
   `:open`, `:checked`, `::checkmark`, `selectedcontent`, `optgroup`/`legend`).
5. **Animate/position the picker** if the design calls for it: `allow-discrete` +
   `@starting-style` for the open/close transition; `anchor()` (the reference is
   implicit) for placement, deferring to
   [css-anchor-positioning-and-flip-fallbacks](../css-anchor-positioning-and-flip-fallbacks/SKILL.md)
   and [css-intrinsic-and-content-sizing](../css-intrinsic-and-content-sizing/SKILL.md)
   for non-default placement and sizing.
6. **Write the baseline** classic-select styling outside the gate, and confirm it
   is a usable control on its own.
7. **Guard the accessible name and decorative content**, then **verify** per the
   checklist on both a supporting and a non-supporting engine, and inside the
   target framework.

## Verification

- **Native semantics survive.** The control submits the right value (check
  `trim(textContent)` for rich options); it is one tab stop; keyboard open/close
  and option navigation work without custom script.
- **Accessible name is correct.** A screen reader announces the intended name,
  not duplicated icon text ("cat cat") and not a corrupted name from button
  content; decorative icons/checkmark/arrow are silent.
- **Parts render as designed** on a supporting engine (Chrome): closed button,
  picker, arrow rotation on `:open`, `:checked` styling, checkmark, optgroups.
- **The fallback is usable** on a non-supporting engine (mid-2026
  Firefox/Safari): a working classic native `<select>`, not a broken one — the
  `@supports` block is inert and the baseline carries the experience.
- **Framework interaction.** Verify inside the real framework: no hydration
  failure under SSR, and `<selectedcontent>` is not stale after any post-render
  mutation of the selected option (update it manually if so).
- **The probe is load-bearing.** Temporarily misspell `base-select` in the
  `@supports` test and confirm the control drops to the classic fallback (guards
  against a gate that always passes).

## Limitations (call these out in the design)

- **Mid-2026 support is Chrome-only.** Treat the styled control as enhancement;
  the design must state that most users get the classic-select baseline until
  Firefox and Safari ship, and that baseline must be acceptable on its own.
- **Single-select only.** Multi-select listboxes are a separate platform feature
  with different markup; do not stretch this guide onto them.
- **`<selectedcontent>` is not live.** It re-clones only on selection change;
  dynamic edits to the selected option's content need manual updates — a real
  hazard with mutate-after-render frameworks.
- **You can break the accessible name.** Custom button content and missing
  `aria-hidden` on decorative parts corrupt what assistive technology announces;
  this is on you, not the platform.
- **Pseudo-element glyphs are decorative.** `::checkmark` / `::picker-icon`
  `content` is outside the accessibility tree; never make it the sole carrier of
  meaning (selection state, required-ness).
- **`@supports` tests syntax, not correctness.** An engine can parse
  `appearance: base-select` and still render parts subtly differently; verify
  per-engine, do not assume the gate guarantees pixel parity.

## Output

The deliverable is the customizable-`<select>` markup (button + `<selectedcontent>`,
rich options with `aria-hidden` decoration) and its CSS: the `@supports
(appearance: base-select)` gate with the opt-in and part-styling inside, the
animation/positioning, and a usable classic-select baseline outside the gate —
plus a design note recording the single-select scope, the native-over-widget
accessibility rationale, the mid-2026 support reality and what the fallback
delivers, and the accessible-name / decorative-content cautions.

## Notes from the field

(Append; terse and dated.)

- _2026-06-29_: initial write (job
  `author-native-customizable-form-control-styling-skill`; skill 4 of the
  `author-web-designer-css-skills` scholar proposal, deferred until the
  accessibility/semantics half was grounded). Grounded in MDN's "Customizable
  select elements" guide (5 sections: background/inventory, markup + opt-in,
  styling the parts, popover + anchor positioning, accessibility + browser
  support) plus the `appearance: base-select`, `<selectedcontent>`, and
  `::picker(select)` reference pages, ingested 2026-06-29 by
  `scholar-ingest-mdn-customizable-select-guide`. The load-bearing thesis: prefer
  the native control for the accessibility/keyboard/form semantics the platform
  keeps for free; ship it as a progressive enhancement behind `@supports
  (appearance: base-select)` because mid-2026 support is Chrome-only. Composes
  with [css-anchor-positioning-and-flip-fallbacks](../css-anchor-positioning-and-flip-fallbacks/SKILL.md)
  (the picker is the canonical anchored popover),
  [css-intrinsic-and-content-sizing](../css-intrinsic-and-content-sizing/SKILL.md)
  (picker sizing), and
  [supports-feature-query-progressive-enhancement](../supports-feature-query-progressive-enhancement/SKILL.md)
  (the gate).
</content>
</invoke>
