---
title: Dual-format body discriminator — the `#` first-byte sentinel that lets one decoder handle both capdata and smallcaps wire formats, and why capdata remains the default ("ontogeny does recapitulate phylogeny")
source: packages/marshal/src/marshal.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/marshal.js
source_line_range: "47-60, 219-227, 387-409"
source_commit: da16a78e177904e08bd4603527fef98d68af2bbd
comment_subject: "Why marshal uses '#' as the JSON-illegal first-byte sentinel to discriminate smallcaps from capdata in a single decoder, and the historical reason capdata remains the default serializeBodyFormat"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, captp, ocapn]
status: current
kind: index
section_count: 5
---

Sections:

- [Abstract](endo--packages-marshal-src-marshal-js--dual-format-body-discriminator--abstract.md)
- [Body](endo--packages-marshal-src-marshal-js--dual-format-body-discriminator--body.md)
- [Translation](endo--packages-marshal-src-marshal-js--dual-format-body-discriminator--translation.md)
- [See also](endo--packages-marshal-src-marshal-js--dual-format-body-discriminator--see-also.md)
- [Common confusions](endo--packages-marshal-src-marshal-js--dual-format-body-discriminator--common-confusions.md)

Source: [packages/marshal/src/marshal.js](https://github.com/endojs/endo/blob/da16a78e177904e08bd4603527fef98d68af2bbd/packages/marshal/src/marshal.js#L47-L409) at commit `da16a78e`.
