---
title: See also
source: packages/marshal/src/encodePassable.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodePassable.js
source_line_range: "86-158"
source_commit: e6192056a5d7ff5acb084f6a58dca3663aa9943e
comment_subject: "IEEE-754 double-to-bits encoding with sign-aware bit-complement so the base-16 ASCII of the bytes sorts lexicographically in the same order the floats sort numerically; lockdown-independent NaN canonicalization with a WebIDL-shaped canonical NaN constant"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement
---

- [`endo--packages-marshal-src-encodepassable-js--bigint-encoding-elias-delta-with-sign-aware-alphabets`](endo--packages-marshal-src-encodepassable-js--bigint-encoding-elias-delta-with-sign-aware-alphabets.md) — the bigint encoder applies the same sort-order-preservation discipline at the variable-length-integer level, using a different mechanism (Elias-delta-with-sign-aware alphabets) to achieve the same property.
- [`endo--packages-marshal-src-encodepassable-js--compact-format-string-escapes`](endo--packages-marshal-src-encodepassable-js--compact-format-string-escapes.md) — strings encode under a related discipline: the `!`-prefix escape preserves byte-order, the same way the bit-complement preserves numeric order.
- [`endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table`](endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table.md) — the per-PassStyle prefix table (`v` null, `z` undefined, `f` number, ...) is what coordinates the inter-PassStyle sort order; the `f` prefix used here is one row of that table.
- [`endo--docs-lockdown--regexp-taming`](endo--docs-lockdown--regexp-taming.md) — lockdown's NaN canonicalization happens through the `DataView` taming pass; this section names the alternative the marshal package takes for non-locked-down realms.
- [`endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state`](endo--packages-pass-style-src-passstyleof-js--passstylememo-as-mutable-static-state.md) — the sister "deliberately-breach-mutable-static-state with recorded rationale" pattern from cycle 71; the C-union trick here is a second worked example.
- [[security-as-extreme-modularity]] — the concept page that catalogs the "forbid mutable static state" Table 1 breaches, including the `passStyleMemo` cache; the C-union construction here is a parallel breach with a different operational-safety argument (no observable state retention vs. realm-lifetime amortization).
- [[smallcaps-encoding]] — the sister wire format under `packages/marshal/src/encodeToSmallcaps.js`; smallcaps targets JSON-shaped round-trip rather than sort-order preservation.

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/e6192056a5d7ff5acb084f6a58dca3663aa9943e/packages/marshal/src/encodePassable.js#L86-L158) at commit `e6192056`.
