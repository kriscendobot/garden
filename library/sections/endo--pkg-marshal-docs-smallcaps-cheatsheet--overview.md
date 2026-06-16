---
title: Smallcaps Cheatsheet
source: packages/marshal/docs/smallcaps-cheatsheet.md
source_repo: endojs/endo
source_commit: b024b06c7b80
source_date: 2026-02-02
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [marshal, pass-style]
status: current
kind: index
section_count: 3
---

> Abstract: Quick-reference for the smallcaps wire format. Smallcaps extends JSON with **reserved single-character string prefixes** that mark non-JSON values: `#` for special primitives (`#undefined`, `#NaN`, `#Infinity`, `#-Infinity`), `+`/`-` for BigInt (`+7`, `-3`), `%` for passable Symbols (`%foo`), `$` for remotables (`$0.tag` — slot index + optional interface tag), `&` for promises (`&1` — slot index), and `!` as the escape prefix when a real string happens to start with a reserved sigil character (so `!hello` round-trips back to `hello` only when its leading character would otherwise be interpreted). Errors use a tagged-object form. For values JSON can already round-trip with no special-prefix strings, smallcaps output is **byte-identical to JSON** — the wire-compat invariant. Replaces the older `@qclass` tagged-object form with shorter prefix sigils. One-screen lookup card for anyone reading or writing smallcaps-encoded data.

Sections:

- [Smallcaps Cheatsheet](endo--pkg-marshal-docs-smallcaps-cheatsheet--overview--smallcaps-cheatsheet.md)
- [Readability Invariants](endo--pkg-marshal-docs-smallcaps-cheatsheet--overview--readability-invariants.md)
- [See also](endo--pkg-marshal-docs-smallcaps-cheatsheet--overview--see-also.md)

Source: [packages/marshal/docs/smallcaps-cheatsheet.md](https://github.com/endojs/endo/blob/b024b06c7b80/packages/marshal/docs/smallcaps-cheatsheet.md) at commit `b024b06c`.
