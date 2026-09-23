---
title: "Customizable select markup and opting in with appearance: base-select"
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

The markup of a customizable `<select>` and the one-line CSS opt-in (`appearance: base-select`). The markup is nearly identical to a classic `<select>`, with two additions: a first-child `<button><selectedcontent></selectedcontent></button>` structure that becomes the styleable closed-select button, and richer `<option>` content (icons, spans, images) beyond plain text. Both the `<select>` and its `::picker(select)` must be opted in with `appearance: base-select`; you cannot opt in the picker without opting in the select. The design degrades gracefully: non-supporting browsers ignore the button/selectedcontent structure and strip non-text option content, leaving a working classic select.

## The markup

A typical pet-picker `<select>`:

```html
<form>
  <p>
    <label for="pet-select">Select pet:</label>
    <select id="pet-select">
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
      <!-- further options, each a <span class="icon"> + <span class="option-label"> pair -->
    </select>
  </p>
</form>
```

The markup differs from a classic `<select>` in two ways:

- **The `<button><selectedcontent></selectedcontent></button>` structure** represents the select button. Adding `<selectedcontent>` causes the browser to clone the currently-selected `<option>` inside the button, which you can then style. If this structure is omitted, the browser falls back to rendering the selected option's text in a default button you cannot style as easily. You may include arbitrary content inside the `<button>` to render whatever you want in the closed select, but be careful: what you include can alter the accessible value exposed to assistive technology for the `<select>`.
- **Richer `<option>` content.** Traditionally `<option>` could contain only text; in a customizable select it can contain images, other non-interactive text-level semantic elements, and `::before` / `::after` generated content (though generated content is not part of the submittable value). In this example each `<option>` contains an icon `<span>` and a label `<span>`, styleable and positionable independently.

Because `<option>` content can now be a multi-level DOM sub-tree rather than just text nodes, there are rules for how the browser extracts the `<select>` value via JavaScript: the selected `<option>`'s `textContent` is retrieved, `trim()` is run on it, and the result becomes the `<select>` value.

This design lets non-supporting browsers fall back to a classic experience: the `<button><selectedcontent></selectedcontent></button>` structure is ignored completely, and non-text `<option>` content is stripped to its text nodes, but the select still functions.

## Opting in: appearance: base-select

To opt in to the custom-select functionality and minimal browser base styles (removing the OS-provided styling), both the `<select>` element and its drop-down picker (the `::picker(select)` pseudo-element) need `appearance: base-select`:

```css
select,
::picker(select) {
  appearance: base-select;
}
```

You can opt in just the `<select>` and leave the picker with default OS styling, but in most cases you opt in both. **You cannot opt in the picker without opting in the `<select>`.** Once opted in, the result is a very plain rendering that you are then free to style. For instance, the select gets custom border, background (changing on `:hover` / `:focus`), padding, and a transition:

```css
select {
  border: 2px solid #dddddd;
  background: #eeeeee;
  padding: 10px;
  transition: 0.4s;
}

select:hover,
select:focus {
  background: #dddddd;
}
```

Source: [Customizable select elements](https://developer.mozilla.org/en-US/docs/Learn_web_development/Extensions/Forms/Customizable_select) §§ Customizable select markup, Opting in to the custom select rendering, MDN contributors, developer.mozilla.org, last modified 2026-04-06; fetched 2026-06-29 via direct curl, content SHA-256 `013b9f8c`.
