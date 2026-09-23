---
title: "Styling the parts: picker icon, picker, selected content, options, checkmark, optgroups"
source_kind: web
source_url: https://developer.mozilla.org/en-US/docs/Learn_web_development/Extensions/Forms/Customizable_select
source_content_sha256: 013b9f8cf029d2b06c209edfe5692bffc182e5751bc03e362b1edea36f01e997
source_authors: [MDN contributors]
source_date: 2026-04-06
ingested: 2026-06-29
ingested_by: scholar
topics: [web-frontend]
status: current
---

The catalog of stylable parts of a customizable `<select>` and the pseudo-element / pseudo-class that targets each: the picker icon (`::picker-icon`, plus `:open` for the open state), the drop-down picker container (`::picker(select)`), the selected-option content in the closed button (`<selectedcontent>` descendants), the currently-selected option (`:checked`), the selection checkmark (`::checkmark`), and option groups (`<optgroup>` and its child `<legend>`). Each is styled with ordinary CSS once `appearance: base-select` is set. This is the hands-on reference for which selector reaches which part.

## Styling the picker icon (`::picker-icon`, `:open`)

The arrow icon inside the select button is targeted with `::picker-icon`. Give it a custom color and animate its rotation:

```css
select::picker-icon {
  color: #999999;
  transition: 0.4s rotate;
}
```

Combine `::picker-icon` with the `:open` pseudo-class (which targets the select button only while the picker is open) to rotate the icon 180° when the select is open:

```css
select:open::picker-icon {
  rotate: 180deg;
}
```

## Styling the drop-down picker (`::picker(select)`)

The drop-down picker is targeted with `::picker(select)`; it contains everything inside the `<select>` that is not the button and the `<selectedcontent>` (in the example, all the `<option>` elements). Remove its default black border:

```css
::picker(select) {
  border: none;
}
```

The `::picker()` argument names the element type whose picker you target (`select`). To target one specific select's picker, combine with another selector, for example `#pet-select::picker(select) { ... }`.

The options are laid out with flexbox and given consistent border / background / padding / transition. Border-radius is applied to the first and last options and the outer picker, and bottom borders are removed from all but the last option:

```css
option {
  display: flex;
  justify-content: flex-start;
  gap: 20px;
  border: 2px solid #dddddd;
  background: #eeeeee;
  padding: 10px;
  transition: 0.4s;
}

option:first-of-type { border-radius: 8px 8px 0 0; }
option:last-of-type  { border-radius: 0 0 8px 8px; }
::picker(select)     { border-radius: 8px; }
option:not(option:last-of-type) { border-bottom: none; }
```

Customizable `<select>` options have `display: flex` set by default. Zebra-striping and hover/focus highlight use `:nth-of-type(odd)` and `:hover` / `:focus`:

```css
option:nth-of-type(odd) { background: white; }
option:hover,
option:focus { background: plum; }
```

Option icons can be enlarged and vertically aligned with the `text-box` property:

```css
option .icon {
  font-size: 1.6rem;
  text-box: trim-both cap alphabetic;
}
```

## Adjusting the selected content in the closed button (`<selectedcontent>`)

When an option with an icon is selected, the icon clones into the closed select button, changing its height and the icon position. Because `<selectedcontent>` represents the cloned content of the selected option as it appears inside the button, you can style it independently of the picker. Here the icon is hidden in the button only:

```css
selectedcontent .icon {
  display: none;
}
```

This does not affect how the option content appears inside the drop-down picker.

## Styling the currently-selected option (`:checked`)

To style the selected `<option>` as it appears inside the picker, target it with `:checked`:

```css
option:checked {
  font-weight: bold;
}
```

## Styling the selection checkmark (`::checkmark`)

When the picker is open, the currently-selected option has a checkmark at its inline-start end, targetable with `::checkmark`. You can hide it (`display: none`) or restyle it. Here it is moved to the row's end with `order` and an auto margin, and its glyph changed via `content`:

```css
option::checkmark {
  order: 1;
  margin-left: auto;
  content: "☑️";
}
```

The `::checkmark` and `::picker-icon` pseudo-elements are **not** included in the accessibility tree, so generated content set on them is not announced by assistive technology; still make sure any new icon makes visual sense.

## Styling option groups (`<optgroup>`, `<legend>`)

By default `<optgroup>` renders as in classic selects (bolded, indented). In customizable selects, option groups behave like any other block-level container and can be styled as such. The `<legend>` element is allowed as a child of `<optgroup>` to provide an easy-to-target, styleable label; it replaces any `label` attribute text and has the same semantics:

```html
<select id="animal-select">
  <optgroup>
    <legend>Domestic</legend>
    <option value="cat">Cat</option>
    <option value="dog">Dog</option>
  </optgroup>
  <optgroup>
    <legend>Farm</legend>
    <option value="chicken">Chicken</option>
    <option value="cow">Cow</option>
  </optgroup>
</select>
```

```css
optgroup {
  border: 2px solid #dddddd;
  border-radius: 8px;
  background: #eeeeee;
  padding: 10px 0 0 0;
  margin-top: 5px;
}

optgroup legend {
  text-align: center;
  margin-bottom: 10px;
}
```

Source: [Customizable select elements](https://developer.mozilla.org/en-US/docs/Learn_web_development/Extensions/Forms/Customizable_select) §§ Styling the picker icon … Styling optgroup elements, MDN contributors, developer.mozilla.org, last modified 2026-04-06; fetched 2026-06-29 via direct curl, content SHA-256 `013b9f8c`.
