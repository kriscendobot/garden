---
title: Readability Invariants
source: packages/marshal/docs/smallcaps-cheatsheet.md
source_repo: endojs/endo
source_commit: b024b06c7b80
source_date: 2026-02-02
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--pkg-marshal-docs-smallcaps-cheatsheet--overview
---

For every JSON encoding with no special strings, the JSON and smallcaps decodings are the same.

If a value `v` round-trips through `JSON.parse(JSON.stringify(v))` and contains no special strings, then the smallcaps encoding of `v` is identical to `JSON.stringify(v)`.

In other words, for these simple values, ***you can ignore the differences between smallcaps and JSON***.

Source: [packages/marshal/docs/smallcaps-cheatsheet.md](https://github.com/endojs/endo/blob/b024b06c7b80/packages/marshal/docs/smallcaps-cheatsheet.md) at commit `b024b06c`.
