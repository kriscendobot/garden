---
title: See also
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

- [`endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme`](endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme.md) — the smallcaps internal sigil scheme; `#` is one of its sigils, which made it a natural choice for the body discriminator outside the encoding.
- [`endo--pkg-marshal-readme--beyond-json`](endo--pkg-marshal-readme--beyond-json.md) — the README's framing of smallcaps as the wire format that extends JSON; this section is the implementation-level dual-format mechanism that bridges old (capdata) and new (smallcaps) wire encodings.
- [`endo--pkg-marshal-readme--alternative-to-json`](endo--pkg-marshal-readme--alternative-to-json.md) — smallcaps as a direct JSON replacement; the body-prefix `#` is the wire-level signal that you've left strict JSON.
- [`endo--pkg-marshal-docs-smallcaps-cheatsheet--overview`](endo--pkg-marshal-docs-smallcaps-cheatsheet--overview.md) — the cheatsheet's quick reference; mentions the `#`-prefixed body but does not explain the discriminator rationale.
- [`endo--pkg-marshal-readme--usage`](endo--pkg-marshal-readme--usage.md) — calling marshal; the `serializeBodyFormat` option is documented here at a usage level.
- [[smallcaps-encoding]] — the concept page for smallcaps; this section is where the encoder-side choice between capdata and smallcaps is made.

Source: [packages/marshal/src/marshal.js](https://github.com/endojs/endo/blob/da16a78e177904e08bd4603527fef98d68af2bbd/packages/marshal/src/marshal.js#L47-L409) at commit `da16a78e`.
