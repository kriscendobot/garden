---
title: §The styleName field and the PassStyleHelper export discipline
source-slug: endo--packages-pass-style-src-byteArray-js
section-slug: ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/byteArray.js
source-repo: endojs/endo
source-path: packages/pass-style/src/byteArray.js
source-author: Endo project (collective)
total-lines: 68
ingest-cycle: 260
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline
---

Line 51: `styleName: 'byteArray'` — the helper declares the pass-style it implements. Per the cycle 249 helpers-cluster page, the `passStyleOf` core iterates the helpers in order and asks each one `confirmCanBeValid`; the matching helper's `styleName` becomes the result. §the-styleName-IS-the-protocol-tag-the-marshal-layer-emits-on-the-wire.

Lines 50, 68: `export const ByteArrayHelper = harden({ ... });` — §the-helper-is-named-exported and §harden-wrapped-at-construction. §three-disciplines-in-one-line:
- §the-export-is-`const`-not-`let` (no rebinding allowed).
- §the-value-is-`harden`-wrapped (no mutation possible).
- §the-binding-name-is-`<StyleName>Helper`-PascalCase (consistent with sibling helpers).

§the-binding-name-convention (PascalCase-with-`Helper`-suffix) is one half of the §two-phase-name-convention across the helpers cluster (the other half: §`styleName`-field-is-lowercase-camelCase-noun matching the on-the-wire tag).
