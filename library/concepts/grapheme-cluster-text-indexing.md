---
id: grapheme-cluster-text-indexing
aliases: ["grapheme cluster", "grapheme clusters", "UTF-16 code units", "UTF-16 string length", "Intl.Segmenter", "`Intl.Segmenter`", "grapheme segmentation", "ZWJ emoji length", "code units vs code points vs graphemes"]
topics: [web-text-editors]
status: current
---

# grapheme-cluster-text-indexing

JavaScript strings and DOM text ranges index by **UTF-16 code units**; string iteration yields **code points**; a user perceives **extended grapheme clusters**. A ZWJ emoji such as `🍋‍🟩` is 5 code units, 3 code points, 1 grapheme. Editors must move cursors and delete by grapheme cluster (`Intl.Segmenter` with `granularity: "grapheme"`) while still passing code-unit offsets to Selection/Range/`selectionStart` APIs.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [utf-16-and-grapheme-clusters](../sections/web--dbushell-text-editor--utf-16-and-grapheme-clusters.md) | The 5 / 3 / 1 worked example: `.length`, spread, and `Intl.Segmenter` on a ZWJ emoji. |

## See also

- [web-text-editor-approaches](web-text-editor-approaches.md) — every custom-editor substrate inherits this pitfall.
- Topic: [web-text-editors](../topics/web-text-editors.md).
