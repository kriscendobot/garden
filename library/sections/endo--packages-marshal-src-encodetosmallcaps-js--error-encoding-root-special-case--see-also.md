---
title: See also
source: packages/marshal/src/encodeToSmallcaps.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodeToSmallcaps.js
source_line_range: "276-293"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Why encodeToSmallcaps pulls error-like values out of the recursion at the root: errors that are not valid Passables (e.g., unfrozen errors) should still be encodable, because reporting their diagnostic information trumps reporting the failure to report"
ingested: 2026-05-15
ingested_by: scholar
topics: [marshal, pass-style, errors]
status: current
parent: endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case
---

- [`endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme`](endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme.md) — the `#error` property name uses the `#` sigil's property-name role, established by the prefix scheme.
- [`endo--pkg-pass-style-readme--passable-values`](endo--pkg-pass-style-readme--passable-values.md) — the definition of passable that errors must satisfy to be valid inside a container.
- [`endo--docs-errors--hiding-revealing-distributed-diagnostic`](endo--docs-errors--hiding-revealing-distributed-diagnostic.md) — the broader Endo discipline of preserving diagnostic context across boundaries.
- [`endo--pkg-marshal-readme--beyond-json`](endo--pkg-marshal-readme--beyond-json.md) — marshal's framing of errors as one of the value categories JSON cannot natively express.
- [[smallcaps-encoding]] — the concept page for smallcaps' wire format.

Source: [packages/marshal/src/encodeToSmallcaps.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/marshal/src/encodeToSmallcaps.js#L276-L293) at commit `e56bf00f`.
