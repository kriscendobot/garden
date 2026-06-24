---
title: See also
source: packages/marshal/src/encodePassable.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodePassable.js
source_line_range: "332-475, 770-822"
source_commit: e6192056a5d7ff5acb084f6a58dca3663aa9943e
comment_subject: "Two array encodings (legacyOrdered with NUL-terminator and SOH-escape, compactOrdered with space-terminator and pre-escaped strings); the embeddability-verifying double-decode applied to user-provided remotable / promise / error encoders to keep them within the C0-control-free invariant"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-encodepassable-js--dual-array-encodings-and-double-decode-verify
---

- [`endo--packages-marshal-src-encodepassable-js--compact-format-string-escapes`](endo--packages-marshal-src-encodepassable-js--compact-format-string-escapes.md) — the string-escape side of the legacy/compact split; this section is the array-encoding side. Together they explain why `compactOrdered` reduces overhead and how the two formats coexist.
- [`endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table`](endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table.md) — the per-PassStyle prefix table assigns `r` to remotables, `?` to promises, `!` to errors; this section's wrapper-shaped first-character check is what enforces the table at the user-callback level.
- [`endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement`](endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement.md) — the per-PassStyle encoders are coordinated by the prefix table; this section's user-callback wrappers are the third leg of that coordination (after the per-PassStyle encoders and the table itself).
- [`endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants`](endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants.md) — smallcaps' canonical-encoding rule is the smallcaps-shaped analog of `compactOrdered`'s embeddability rule; both enforce that the encoder produces output the decoder will round-trip cleanly.
- [`endo--pkg-marshal-readme--beyond-json`](endo--pkg-marshal-readme--beyond-json.md) — the README's framing of marshal as a serialization layer that goes beyond JSON; this section's `compactOrdered` is the database-key-shaped form of that layer.

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/e6192056a5d7ff5acb084f6a58dca3663aa9943e/packages/marshal/src/encodePassable.js#L332-L475) at commit `e6192056`.
