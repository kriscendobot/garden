---
id: smallcaps-encoding
aliases: ["smallcaps", "smallcaps wire format", "smallcaps encoding", "Smallcaps Encoding", "`encodeToSmallcaps`", "`decodeFromSmallcaps`", "smallcaps prefix scheme", "smallcaps special characters", "smallcaps cheatsheet", "BANG to DASH range", "smallcaps vs capdata", "`@qclass`", "qclass", "manifest constant", "#undefined", "#NaN", "#Infinity", "#tag", "#error", "Hilbert hotel string escape"]
topics: [marshal, pass-style, ocapn]
---

# smallcaps-encoding

Smallcaps is marshal's JSON-representable wire format for passables: every smallcaps encoding is plain JSON, and a string-position value is either a literal string (when its first character is outside the reserved range `!`-`-`, ASCII 33-45) or a tagged value (when its first character is one of the seven assigned sigils: `!` for an escaped string, `+`/`-` for non-negative/negative bigint, `#` for manifest constants and tag property-names, `%` for passable symbol, `$` for remotable, `&` for promise). The contiguous-range design preserves byte-string sort order across the Hilbert-hotel escape that quotes data strings whose leading character would otherwise collide with a sigil, which in turn lets copyRecord key sorting produce a canonical encoding without breaking on escaped keys. Smallcaps replaces the older capdata `@qclass` tagged-object form, halving wire bytes for primitives at the cost of a finite reserved-character budget (five of the thirteen reserved characters remain unassigned).

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [special-character-prefix-scheme](../sections/endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme.md) | The longform-comment rationale for the contiguous BANG-to-DASH range, the seven assigned sigils, the five reserved characters, and the wire-byte comparison with capdata. |
| [canonical-encoding-invariants](../sections/endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants.md) | Why encodeToSmallcaps must produce a canonical encoding, how copyRecord key sorting plus encoder-source-order object literals achieve it, and the canonical-JSON aspiration the comment names as a TODO. |
| [error-encoding-root-special-case](../sections/endo--packages-marshal-src-encodetosmallcaps-js--error-encoding-root-special-case.md) | Why error-like values get a pre-recursion encoding path; the diagnostic-information-over-validation prioritization rule. |
| [smallcaps cheatsheet](../sections/endo--pkg-marshal-docs-smallcaps-cheatsheet--overview.md) | The reference table of JS values to smallcaps encodings; the readability-invariant rule (no-special-string values are byte-identical to JSON). |
| [beyond JSON](../sections/endo--pkg-marshal-readme--beyond-json.md) | The marshal README's framing of smallcaps as the wire format that extends JSON for capability transport, with a side-by-side capdata comparison. |
| [alternative to JSON](../sections/endo--pkg-marshal-readme--alternative-to-json.md) | Smallcaps as a direct JSON replacement when capability values are not in play. |
| [ocapn json-invariants](../sections/ocapn--draft-specifications-model--json-invariants.md) | The upstream protocol's specification of how Model values relate to JSON; smallcaps is the JS realization of that invariant. |
| [endo--packages-marshal-src-marshal-js--dual-format-body-discriminator](../sections/endo--packages-marshal-src-marshal-js--dual-format-body-discriminator.md) | How `makeMarshal` lets capdata and smallcaps coexist on the same wire via a `#` first-byte JSON-illegal sentinel; capdata remains the default `serializeBodyFormat` for backward compatibility ("ontogeny does recapitulate phylogeny"). The constructor-level mechanism that makes the migration to smallcaps tractable. |
| [endo--packages-marshal-src-marshal-js--slot-typing-security-hazard](../sections/endo--packages-marshal-src-marshal-js--slot-typing-security-hazard.md) | Smallcaps' `$` (remotable) and `&` (promise) sigils partially mitigate the wire-level slot-kind ambiguity, but the kind information doesn't reach the application's `convertSlotToVal` callback, so smallcaps does not fully close the hazard. The TODO on `decodeSlotCommon` remains open in the smallcaps path as well. |

## See also

- [[pass-invariant-handle-equality]] — the broader pass-invariant equality discipline that round-tripped values preserve identity; smallcaps' canonicity is one of the bytes-level mechanisms.
- [[rank-order-preserving-encoding]] — `encodePassable`, the sister encoder in the same package. Smallcaps targets JSON-shape round-trip; encodePassable targets rank-order-preserving database keys. Both encoders share the diagnostic-priority error-special-case at the encoding root; their other moves diverge.
- [[syrup-record-positionality]] — a sibling-format design decision in OCapN's Syrup encoding (record field names are positional bindings, not on the wire); smallcaps takes a different path (property names *are* on the wire, in sorted order, escaped through Hilbert hotel when they collide with sigils).
- [[shape-not-content]] — the discipline of capturing shape rather than rows; smallcaps' wire format is a shape-typed encoding (the first byte of every string answers "what kind is this").

Source provenance for each section is recorded in the section frontmatter; the comment-fragment rationale sections all pin to `e56bf00f` (2025-10-09) of `packages/marshal/src/encodeToSmallcaps.js`. The cheatsheet pins to `b024b06c` (2026-02-02); the README sections pin to `70bcca3d` (2024-02-05).
