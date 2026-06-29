---
title: "The <selectedcontent> element: clone semantics, inertness, and styling"
source_kind: web
source_url: https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/selectedcontent
source_content_sha256: 3ebe0744a0997a6c9f6b427b345d2a17afb02e6e88fd2b3be87af47b2afeca60
source_authors: [MDN contributors]
source_date: 2026-04-24
ingested: 2026-06-29
ingested_by: scholar
topics: [web-frontend]
status: current
---

The `<selectedcontent>` HTML element, which displays the contents of a customizable `<select>`'s currently-selected `<option>` inside the closed select's first-child `<button>`. It must be the only child of a `<button>` that is the first child of the `<select>`, with `<option>` elements following the button. Behind the scenes it holds a `cloneNode()` clone of the selected option's content, re-cloned whenever the selection changes (a `change` event); dynamic edits to the selected option after render are not re-cloned and must be updated manually. It is inert (so its content is not focusable), and you can style its content independently of how the same option appears in the picker (the canonical use: hide an icon in the button while keeping it in the drop-down). Without a `<button>`/`<selectedcontent>` pair the browser creates an implicit, un-targetable fallback button.

## What it is and where it goes

`<selectedcontent>` is used inside a `<select>` to display the contents of its currently-selected `<option>` within its first-child `<button>`. This is what enables styling all parts of a `<select>` ("customizable selects"). It must be the **only child of a `<button>`** that is itself the **first child of the `<select>`**; any `<option>` (the only other valid child of `<select>`) must come after the button/selectedcontent pair:

```html
<select>
  <button>
    <selectedcontent></selectedcontent>
  </button>
  <option></option>
  ...
</select>
```

## How it works behind the scenes

`<selectedcontent>` contains a **clone of the content of the currently-selected `<option>`**, rendered with `cloneNode()`. When the selected option changes (for example during a `change` event), the contents are replaced with a clone of the newly-selected option.

Warning: because the browser updates `<selectedcontent>` **only when the selected option changes**, any dynamic modifications to the selected option's content *after* render are not cloned in automatically; you must update `<selectedcontent>` manually. This is a hazard with front-end frameworks that update `<option>` elements dynamically after the initial render.

## Inertness

By default any `<button>` inside a `<select>` is **inert**, so all content inside it (including `<selectedcontent>`) is also inert: users cannot interact with or focus content inside `<selectedcontent>`.

## Styling the selected option's content

You can target the selected option's content as it appears inside the select button and style it **separately** from how the option appears in the drop-down list. Styling the button does not affect the styling of the cloned option content. The canonical use is hiding button-unfriendly content (an icon, image, or video that looks fine in the drop-down but would distort the button):

```css
selectedcontent img {
  display: none;
}
```

If the `<button>` and/or `<selectedcontent>` are not included inside `<select>`, the browser creates an **implicit `<button>`** to display the selected option's contents; this fallback button **cannot be targeted with CSS** using the `button` or `selectedcontent` type selector.

## Technical summary

- **Content categories:** none.
- **Permitted content:** mirrors content from the selected `<option>`.
- **Tag omission:** none; both start and end tags are mandatory.
- **Permitted parents:** a `<button>` that is the first child of a `<select>`.
- **Implicit ARIA role:** none. **Permitted ARIA roles:** none.
- **DOM interface:** `HTMLSelectedContentElement`.

This feature is marked **Experimental** and "Limited availability" (not Baseline).

Source: [`<selectedcontent>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Elements/selectedcontent) §§ Description, Technical summary, MDN contributors, developer.mozilla.org, last modified 2026-04-24; fetched 2026-06-29 via direct curl, content SHA-256 `3ebe0744`.
