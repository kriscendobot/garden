---
title: Content editable: a contenteditable="plaintext-only" editing surface
source_kind: web
source_url: https://dbushell.com/2026/09/01/text-editor/
source_content_sha256: 3ab555a041ecba3f68f8a791498911288079554457b7b26ddc478e0dd7630e20
source_authors: [David Bushell]
source_date: 2026-09-01
ingested: 2026-09-30
ingested_by: scholar
topics: [web-text-editors, web-frontend]
status: current
---

**Abstract.** The second approach: render the text natively in the overflow `<div>` and make it editable with `contenteditable="plaintext-only"` (all content stays in a single text node, well suited to code), disabling `spellcheck`, `autocorrect`, `autocapitalize`, and `translate` — `spellcheck` in particular causes input-latency spikes. The browser then supplies native selection, undo history, and "so much accessibility goodness" for free; the Selection API supplies metrics for a custom-drawn cursor, `::selection` styles the selection, and native `caret-color` is made transparent. The drawback: unpredictable performance degradation past a certain character count, worse in Chromium than in WebKit or Firefox.

Instead of rendering text on the `<canvas>` I can just render it natively in the overflow `<div>` and make it editable with a [contenteditable attribute](https://developer.mozilla.org/en-US/docs/Web/HTML/Reference/Global_attributes/contenteditable). That attribute has a `plaintext-only` value that is perfect for code. All content remains within a single text node.

```html
<div
  contenteditable="plaintext-only"
  autocapitalize="off"
  autocorrect="off"
  spellcheck="false"
  translate="no">
  <!-- text goes here -->
</div>
```

Attributes like `spellcheck` must be disabled to avoid input latency spikes. Want to guess how many days it took me to discover that fix? Days!

Using `contenteditable` gives native text selection and undo history etc. So much accessibility goodness is wired up for free by the browser.

The [Selection API](https://developer.mozilla.org/en-US/docs/Web/API/Selection) provides metrics I use to continue rendering a custom text cursor. `::selection` is available so I can style that too. I've set the native [caret-color](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Properties/caret-color) invisible, which is probably a no-no.

The `contenteditable` technique is promising but I've noticed strange performance issues beyond a certain character count. Chromium browsers perform worse than WebKit and whatever Firefox is now but it's unpredictable.

**Also from the post.** The author's original syntax-highlighting plan targeted this substrate: the [CSS Custom Highlight API (`::highlight`)](https://developer.mozilla.org/en-US/docs/Web/CSS/Reference/Selectors/::highlight) works on a `contenteditable` element's text ranges without wrapping text in extra elements. He later notes he could return to `contenteditable` because the file sizes he edits never hit its performance wall (see [textarea](web--dbushell-text-editor--textarea.md)).

**Tradeoff summary (scholar).** Native selection, undo, and accessibility with a real DOM text node and CSS highlight support, at the cost of an unpredictable, browser-dependent performance ceiling on large documents and the need to switch off text-assist attributes by hand.

Source: [Fine, I’ll build my own text editor!](https://dbushell.com/2026/09/01/text-editor/) by David Bushell, 2026-09-01 (content SHA-256 `3ab555a0`, retrieved 2026-09-30).
