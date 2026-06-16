---
title: See also
source: packages/marshal/src/encodePassable.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodePassable.js
source_line_range: "584-665, 869-911"
source_commit: e6192056a5d7ff5acb084f6a58dca3663aa9943e
comment_subject: "Why `encodePassable` extracts an error-special-case before the per-PassStyle switch (diagnostic-priority over Passable-validation); the canonical `passStylePrefixes` table whose ordering matches the rankOrder PassStyle order; the `|` ordinal-mapping prefix reserved outside the cover range; the Array.prototype.sort-driven choice to put `undefined` last"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table
---

- [`endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement`](endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement.md) — the per-style number encoder; its `f` prefix is one row of the table this section catalogs.
- [`endo--packages-marshal-src-encodepassable-js--bigint-encoding-elias-delta-with-sign-aware-alphabets`](endo--packages-marshal-src-encodepassable-js--bigint-encoding-elias-delta-with-sign-aware-alphabets.md) — the per-style bigint encoder; the `bigint: 'np'` row of the table is two characters because of the sign-aware alphabet split this section explains.
- [`endo--packages-marshal-src-encodepassable-js--compact-format-string-escapes`](endo--packages-marshal-src-encodepassable-js--compact-format-string-escapes.md) — the per-style string-escape mechanism; the `string: 's'` row of the table pairs with the `~`-format-discriminator that distinguishes compactOrdered output.
- [`endo--packages-marshal-src-encodepassable-js--dual-array-encodings-and-double-decode-verify`](endo--packages-marshal-src-encodepassable-js--dual-array-encodings-and-double-decode-verify.md) — the array encoders; `copyArray: '[^'` is two characters because of the legacy-vs-compact split this section explains; the wrapper-shaped first-character check for user-callbacks coordinates with `remotable: 'r'`, `promise: '?'`, `error: '!'`.
- [`endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case`](endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case.md) — the sister diagnostic-priority special case from cycle 69; the same shape applied in the smallcaps wire format.
- [`endo--packages-marshal-src-marshal-js--error-diagnostic-priority`](endo--packages-marshal-src-marshal-js--error-diagnostic-priority.md) — the cycle-74 ingest of the marshal-level error-encoding shape; the third instance of the diagnostic-priority rule.
- [[smallcaps-encoding]] — the concept page for smallcaps' wire format; both encoders share the diagnostic-priority special case under different framings.

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/e6192056a5d7ff5acb084f6a58dca3663aa9943e/packages/marshal/src/encodePassable.js#L598-L911) at commit `e6192056`.
