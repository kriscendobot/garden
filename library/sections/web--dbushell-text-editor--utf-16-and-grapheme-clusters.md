---
title: UTF-16 code units versus grapheme clusters in editor text ranges
source_kind: web
source_url: https://dbushell.com/2026/09/01/text-editor/
source_content_sha256: 3ab555a041ecba3f68f8a791498911288079554457b7b26ddc478e0dd7630e20
source_authors: [David Bushell]
source_date: 2026-09-01
ingested: 2026-09-30
ingested_by: scholar
topics: [web-text-editors]
status: current
---

**Abstract.** The post's closing caution: JavaScript strings and DOM text ranges (Selection, Range, `<textarea>` `selectionStart`/`selectionEnd`) index by UTF-16 code units, so an editor that moves a cursor or deletes "one character" by index is easy to get wrong. The worked example is the lime emoji `🍋‍🟩` (a ZWJ sequence): `.length` is 5 (code units), spreading into an array yields 3 (code points), and only `Intl.Segmenter` with `granularity: "grapheme"` yields the 1 user-perceived character a cursor should step over.

JavaScript strings and text ranges work with UTF-16 code units. It's easy to naively introduce bugs. I'm sure my demos are full of them. I'll leave with a code example to nerd snipe.

```js
"🍋‍🟩".length; // 5

[..."🍋‍🟩"].length; // 3

const segmenter = new Intl.Segmenter("en", {granularity: "grapheme"});
[...segmenter.segment("🍋‍🟩")].length; // 1
```

**Scholar note.** The three counts are code units (UTF-16), code points (string iterator), and extended grapheme clusters (`Intl.Segmenter`). Cursor movement, backspace, and selection-extension in a custom editor should step by grapheme cluster, while offsets passed to DOM/range APIs remain code-unit indices — the conversion between the two is where the bugs live.

Source: [Fine, I’ll build my own text editor!](https://dbushell.com/2026/09/01/text-editor/) by David Bushell, 2026-09-01 (content SHA-256 `3ab555a0`, retrieved 2026-09-30).
