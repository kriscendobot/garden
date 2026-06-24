---
title: Translation
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
parent: endo--packages-marshal-src-marshal-js--dual-format-body-discriminator
---

| Marshal idiom | Adjacent vocabulary |
|---|---|
| "wire format discriminator" | "envelope type tag" in network protocols; "magic number" in file-format identification |
| "serializeBodyFormat" | the **encoder format option** for marshal; not a "media type" but plays the same role |
| "ontogeny does recapitulate phylogeny" | Haeckel's biological recapitulation theory; here used as a *joke* about defaulting to the historical first-implemented format |
| `fromCapData` | the **dual-format decoder entry point**; named after the older format for historical reasons even though it decodes smallcaps too |

Source: [packages/marshal/src/marshal.js](https://github.com/endojs/endo/blob/da16a78e177904e08bd4603527fef98d68af2bbd/packages/marshal/src/marshal.js#L47-L409) at commit `da16a78e`.
