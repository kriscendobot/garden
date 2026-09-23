---
id: customizable-select
aliases: [customizable select, "appearance: base-select", base-select, "<selectedcontent>", selectedcontent, "::picker-icon", "::checkmark", ":open pseudo-class", select button, native form control styling, native customizable form control, stylable select]
topics: [web-frontend]
---

# customizable-select

**Customizable `<select>`** is the web-platform feature that makes the native `<select>` control fully stylable with HTML and CSS (the closed-select button, the drop-down picker, the arrow icon, the selection checkmark, and each `<option>`), without rebuilding it as a `<div>`-and-JavaScript widget. You opt in by setting `appearance: base-select` on both the `<select>` and its `::picker(select)` pseudo-element. The markup gains a first-child `<button>` containing a `<selectedcontent>` element (which holds a `cloneNode()` clone of the selected option, shown in the closed button), and `<option>` elements may contain rich content (icons, spans, images) rather than only text. The stylable parts each have a selector: `::picker(select)` (the picker), `::picker-icon` (the arrow), `::checkmark` (the selection mark), `:open` (button while picker is open), `:checked` (selected option), and `<optgroup>`/`<legend>`. The whole thing is a **progressive enhancement**: in non-supporting browsers it degrades to a classic native `<select>`. Its value over a bespoke widget is that the platform keeps owning the accessibility tree, keyboard interaction, focus, form participation, and the submittable value (derived from the selected option's trimmed `textContent`). As of mid-2026 it is "Limited availability" / not Baseline: Chrome ships it; Firefox and Safari are implementing it but have not released, so production use pairs it with an `@supports (appearance: base-select)` fallback ([[progressive-enhancement-supports]]).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [Background and feature inventory](../sections/web--mdn-customizable-select--background-and-feature-inventory.md) | Why customizable select exists and the full inventory of HTML/CSS features (select button, selectedcontent, ::picker(select), base-select, :open, ::picker-icon, :checked, ::checkmark, implicit anchor). |
| [Customizable select markup and opting in](../sections/web--mdn-customizable-select--markup-and-opt-in.md) | The button/selectedcontent markup, rich option content, textContent value extraction, classic-select fallback, and the `appearance: base-select` opt-in on both select and picker. |
| [Styling the parts](../sections/web--mdn-customizable-select--styling-the-parts.md) | Which selector reaches which part: ::picker-icon, ::picker(select), selectedcontent descendants, :checked, ::checkmark, optgroup/legend. |
| [Animating and positioning the picker](../sections/web--mdn-customizable-select--popover-and-anchor-positioning.md) | The implicit popover relationship (transition + allow-discrete + @starting-style) and the implicit anchor reference (anchor() positioning). |
| [Accessibility guarantees and browser-support state](../sections/web--mdn-customizable-select--accessibility-and-browser-support.md) | The accessibility properties the native control keeps that a div widget would re-implement, and the mid-2026 Limited-availability support state. |
| [appearance: base-select — opting a select into customizable rendering](../sections/web--mdn-appearance-base-select--base-select-value.md) | The appearance property's none/base framing and the base-select value's effects (top-layer popover picker, anchor-positionable, not sized to widest option). |
| [The <selectedcontent> element: clone semantics, inertness, and styling](../sections/web--mdn-selectedcontent--element-semantics-and-cloning.md) | Placement rules, cloneNode() clone-on-change + dynamic-staleness warning, inertness, independent styling, fallback button. |
| [::picker(select): targeting the picker, popover behavior, and default anchor styles](../sections/web--mdn-picker-select-pseudo-element--targeting-and-defaults.md) | What ::picker(select) targets, the base-select precondition, and the browser default picker position / position-try-fallback styles. |

## See also

- [[css-intrinsic-sizing]] — the picker-height sizing toolkit (`calc-size()`, intrinsic sizes, `::picker(select)` defaults); customizable-select is the control whose picker that technique sizes.
- [[progressive-enhancement-supports]] — because support is partial, the customizable control ships behind an `@supports (appearance: base-select)` feature query with a classic-select fallback.

## Common confusions

- **Customizable `<select>` is not `appearance: none` advanced form styling.** `appearance: none` only strips OS styling from the bits that are already styleable and leaves the picker/drop-down un-stylable; `appearance: base-select` makes the whole control (including the picker) stylable while keeping native functionality.
- **It is not a `<div>` widget.** The point is that it remains a real `<select>`: the platform keeps the accessibility tree, keyboard, focus, and form value, which a `<div role="listbox">` widget must re-implement by hand.
- **`::checkmark` / `::picker-icon` content is not announced.** Those pseudo-elements are outside the accessibility tree, so `content` set on them is decorative only.
