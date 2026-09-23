---
title: Body
source: packages/marshal/src/encodeToSmallcaps.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodeToSmallcaps.js
source_line_range: "34-77"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Smallcaps' reserved special-character range (BANG `!` 33 to DASH `-` 45) and the prefix assignments that turn JSON strings into a tagged representation"
ingested: 2026-05-15
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme
---

### The reserved range and why it is contiguous

```
Smallcaps considers the characters between `!` (ascii code 33, BANG)
and `-` (ascii code 45, DASH) to be special prefixes allowing
representation of JSON-incompatible data using strings.
These characters, in order, are `!"#$%&'()*+,-`
```

The comment names the boundary explicitly: BANG (`!`, code 33) is
the lowest assigned sigil and DASH (`-`, code 45) is the highest.
The code form is:

```js
const BANG = '!'.charCodeAt(0);
const DASH = '-'.charCodeAt(0);

const startsSpecial = encodedStr => {
  if (encodedStr === '') return false;
  const code = encodedStr.charCodeAt(0);
  return BANG <= code && code <= DASH;
};
```

Choosing a *contiguous* range (rather than a scattered set of
sigil characters) is load-bearing for two reasons:

1. **Sort-order preservation.** When a string's leading char is
   in the reserved range, the `!`-prefix Hilbert-hotel quoting
   (covered in the canonical-encoding section) maps the original
   string to a new string whose leading char is also in the
   reserved range, *one position higher than the original*. Order
   between strings whose first char is in the range, and strings
   whose first char is outside the range, is preserved by the
   quote. This matters for the copyRecord key-sort invariant: the
   sort order of property names after encoding agrees with the
   pre-encoding order, so the canonical-JSON property-name
   ordering survives the round-trip.
2. **Single-comparison startsSpecial.** The `BANG <= code && code <= DASH`
   check is one branch with two comparisons. A non-contiguous
   sigil set (e.g., `!` plus `#` plus `+` but not `"`) would
   require either a hash lookup or a chain of `===` comparisons,
   trading the `O(1)` two-comparison form for either an `O(1)`
   table or an `O(k)` linear scan over the assigned sigils.

### Currently-assigned sigils

The JSDoc enumerates the seven sigils smallcaps actively uses:

| Sigil | Code | Meaning | Example encoding |
|-------|------|---------|------------------|
| `!`   | 33   | escaped string (Hilbert hotel) | `"!#foo"` for `"#foo"` |
| `"`   | 34   | (reserved) | |
| `#`   | 35   | manifest constant or tag property-name | `"#undefined"`, `"#tag"` |
| `$`   | 36   | remotable | `"$0"` or `"$0.foo"` |
| `%`   | 37   | passable symbol | `"%foo"` |
| `&`   | 38   | promise | `"&1"` |
| `'`   | 39   | (reserved) | |
| `(`   | 40   | (reserved) | |
| `)`   | 41   | (reserved) | |
| `*`   | 42   | (reserved) | |
| `+`   | 43   | non-negative bigint | `"+7"` |
| `,`   | 44   | (reserved) | |
| `-`   | 45   | negative bigint | `"-3"` |

Five characters in the range are currently reserved-but-unassigned:
`"`, `'`, `(`, `)`, `*`, `,`. Future smallcaps revisions may
assign them. After the range is exhausted, smallcaps would have to
either repurpose existing sigils (a breaking change) or evolve to
a new format version; the comment does not commit to a path here.

### Manifest constants: a sub-scheme under `#`

The `#` sigil hosts two distinct uses: **value-position constants**
and **property-name tags**. The JSDoc enumerates them:

Value-position constants currently used by smallcaps:
- `"#undefined"` (the value `undefined`)
- `"#NaN"`
- `"#Infinity"`
- `"#-Infinity"`

Property-name tags (the analogue of capdata's `@qclass`):
- `"#tag"` — marks a tagged record's tag property
- `"#error"` — marks an error record's message property

```
All other encoded strings beginning with `#` are reserved for
future use.
```

The two uses are disambiguated *positionally*: a `#`-prefixed
string in value position is a manifest constant; a `#`-prefixed
string in property-name position is a tag. The decoder relies on
this positional rule and the small enumeration of currently-valid
constant names to fault on unrecognized `#` strings.

### Relationship to capdata's `@qclass`

The line "for property names analogous to capdata `@qclass`" is a
direct cross-reference to the older marshal wire format that
smallcaps supersedes. Capdata represented a special value as an
object literal `{"@qclass": "NaN"}`; smallcaps represents the
same value as the string `"#NaN"`. The wire bytes for
`JSON.stringify(NaN-encoding)`:

| Format | Wire form | Byte count |
|--------|-----------|------------|
| capdata | `{"@qclass":"NaN"}` | 17 |
| smallcaps | `"#NaN"` | 6 |

The marshal README's `beyond-json` section shows both side by side.
The byte savings are larger for the primitive cases (bigints,
undefined, NaN, Infinity, symbols) than for tagged records where
both formats wrap an object. The wire-compatibility benefit beyond
bytes is that a value JSON can already round-trip (a non-special
string, a number, a boolean, an array of these) is byte-identical
between JSON.stringify and smallcaps; the marshal `smallcaps-cheatsheet`
section calls this the *readability invariant*.

### What the prefix scheme buys, and what it costs

Buys:

- A single-byte tag per JSON-incompatible primitive (vs the
  multi-byte `{"@qclass": "..."}` envelope).
- Round-trip-stable sort order on string property names,
  required for the canonical-JSON encoding invariant.
- Type recovery without a structural type-tag wrapper at every
  node: the decoder branches on the first char of a string, not
  on a wrapper-object shape.

Costs:

- A finite reserved-character budget (13 characters in the
  contiguous range, of which 7 are assigned).
- Strings that happen to start with a reserved character pay one
  byte of overhead from the `!` escape.
- The decoder must read the first byte of every string before it
  knows whether the string is data or a tag, which is *O(1)* but
  not free.

The byte budget is the most-cited tradeoff: a future smallcaps
that needed a new primitive type (e.g., complex numbers, dates as
distinguished types, fixed-precision decimals) would have to spend
one of the remaining five reserved characters. The comment does
not suggest a successor format; the implicit position is that the
budget is adequate for the value categories OCapN cares about.

Source: [packages/marshal/src/encodeToSmallcaps.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/marshal/src/encodeToSmallcaps.js#L34-L77) at commit `e56bf00f`.
