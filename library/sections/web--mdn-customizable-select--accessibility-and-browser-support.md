---
title: "Accessibility guarantees the native control keeps, and browser-support state"
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

The accessibility properties a customizable `<select>` keeps for free (the ones a div-and-JavaScript widget would have to re-implement by hand), and the mid-2026 browser-support state. The whole point of styling the **native** control rather than rebuilding it is that the platform still owns keyboard interaction, focus management, the accessibility tree, form participation, and the submittable value. This section gathers the accessibility statements the guide makes across its sections into one reference, and records that the feature is "Limited availability" / not Baseline (Chrome ships it; Firefox and Safari are implementing it but have not released). It is the grounding for choosing the native customizable control over a bespoke widget where support allows, behind an `[[progressive-enhancement-supports]]` fallback.

## Accessibility guarantees the native control keeps

Because a customizable `<select>` is still a real `<select>`, the platform continues to provide the accessibility and interaction behavior that a hand-built `<div>` widget would otherwise have to reconstruct:

- **It stays a form control with a submittable value.** The selected `<option>`'s value participates in form submission as normal. When `<option>` content is a multi-level DOM sub-tree rather than plain text, the browser derives the value deterministically: it reads the selected option's `textContent`, runs `trim()`, and uses the result as the `<select>` value.
- **The select button is inert by default.** Any interactive children placed inside the first-child `<button>` (or inside `<selectedcontent>`) are not focusable or clickable; the button is treated as a single button for interaction purposes. This preserves the "one control, one focus stop" model of a native select.
- **The accessible value is exposed automatically**, but you can break it. The guide warns that arbitrary content inside the `<button>` "can alter the accessible value exposed to assistive technology for the `<select>` element," so custom button content must be chosen with the exposed name in mind.
- **Decorative content must be hidden from assistive technology explicitly.** In the example, each option's icon `<span>` carries `aria-hidden="true"` so the icon is not announced and option values are not read twice (for example "cat cat").
- **Generated pseudo-element content is outside the accessibility tree.** The `::checkmark` and `::picker-icon` pseudo-elements are not in the accessibility tree, so `content` set on them is not announced; a restyled checkmark or arrow must still make visual sense on its own.
- **`<legend>` inside `<optgroup>` carries the group's label semantics.** It replaces the `optgroup` `label` attribute and has the same semantics, so grouping remains announced.
- **Keyboard behavior, focus, and the open/closed picker state are the platform's**, surfaced to CSS through `:open` (button while picker is open) and `:checked` (selected option) rather than re-implemented in script.

The control degrades safely: in non-supporting browsers the `<button><selectedcontent></selectedcontent></button>` structure is ignored and non-text option content is stripped to its text nodes, but the select still functions as a classic native select. This is why customizable `<select>` is framed as a **progressive enhancement** rather than a replacement.

## Browser-support state (mid-2026)

MDN labels the feature **"Limited availability"**: "This feature is not Baseline because it does not work in some of the most widely-used browsers." As of this capture (page last modified 2026-04-06), Chrome ships customizable `<select>`; Firefox and Safari are actively implementing it but have not released. The related building-block reference pages (`<selectedcontent>`, `::picker(select)`, `::checkmark`) carry the same "Limited availability" / experimental banner, and `<selectedcontent>` is additionally marked **Experimental**.

Two practical cautions the guide raises:

- **Framework interference.** Some JavaScript frameworks block these features; in others they cause hydration failures when Server-Side Rendering (SSR) is enabled.
- **Dynamic-content staleness.** `<selectedcontent>` is updated only when the *selected* option changes; dynamic modifications to the selected option's content after render are not re-cloned automatically and must be updated manually (a hazard with frameworks that mutate `<option>` elements after the initial render).

Because support is partial, production use pairs the feature with an `@supports` feature query and a fallback (for example `@supports not (appearance: base-select) { ... }`), per `[[progressive-enhancement-supports]]`.

Source: [Customizable select elements](https://developer.mozilla.org/en-US/docs/Learn_web_development/Extensions/Forms/Customizable_select) §§ Background, Customizable select markup, Styling the current selection checkmark, Browser compatibility (notes consolidated across the guide), MDN contributors, developer.mozilla.org, last modified 2026-04-06; fetched 2026-06-29 via direct curl, content SHA-256 `013b9f8c`.
