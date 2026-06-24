---
title: Body
source: packages/marshal/src/encodePassable.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodePassable.js
source_line_range: "249-330"
source_commit: e6192056a5d7ff5acb084f6a58dca3663aa9943e
comment_subject: "The compactOrdered encoding moves array element-terminator escaping from per-element to per-string: control characters and the array-element terminator are escaped at the string level via a contiguous-range mapping that preserves lexicographic order"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-encodepassable-js--compact-format-string-escapes
---

### Why strings need escaping when arrays do not (in compactOrdered)

The two encoded array formats differ in how they delimit elements:

- `legacyOrdered` uses `[` to start an array, U+0000 NULL to
  terminate each element, and U+0001 START OF HEADING as an escape
  prefix for U+0000 or U+0001 inside an element. Strings themselves
  pass through unmodified.
- `compactOrdered` uses `^` to start an array and a space (` `)
  to terminate each element. To make space-as-terminator safe, the
  string encoder escapes every space inside a string. To make
  `^`-as-array-start safe, it escapes every `^` inside a string.

In `compactOrdered`, by moving the escaping responsibility from
per-element (`legacyOrdered`'s U+0001 escape on each array
element's already-encoded bytes) to per-string (this scheme's
`!`-escape on the string encoder's output bytes), the expansion
overhead is paid only when strings actually contain reserved
characters. The bare-block comment above `stringEscapes` names the
benefit:

```
Performs the original array encoding, which escapes all encoded
array elements rather than just strings (`U+0000` as the element
terminator and `U+0001` as the escape prefix for `U+0000` or
`U+0001`). This necessitated an undesirable amount of iteration
and expansion; see https://github.com/endojs/endo/pull/1260#discussion_r960369826
```

(The quote is from the `encodeLegacyArray` JSDoc, which describes
the format `compactOrdered` exists to replace.)

### The escape table: `!`-prefix with [0x21..0x40] payload

The bare-block comment above the `stringEscapes` table:

```
A sparse array for which every present index maps a code point in
the ASCII range to a corresponding escape sequence.

Escapes all characters from U+0000 NULL to U+001F INFORMATION
SEPARATOR ONE like `!<character offset by 0x21>` to avoid
JSON.stringify expansion as `\uHHHH`, and specially escapes
U+0020 SPACE (the array element terminator) as `!_` and U+0021
EXCLAMATION MARK (the escape prefix) as `!|` (both chosen for
visual approximation).
Relative lexicographic ordering is preserved by this mapping of
any character at or before `!` in the contiguous range
[0x00..0x21] to a respective character in [0x21..0x40, 0x5F, 0x7C]
preceded by `!` (which is itself in the replaced range).
Similarly, escapes `^` as `_@` and `_` as `__` because `^`
indicates the start of an encoded array.
```

The construction in the code:

```js
const stringEscapes = Array(0x22)
  .fill(undefined)
  .map((_, cp) => {
    switch (String.fromCharCode(cp)) {
      case ' ':
        return '!_';
      case '!':
        return '!|';
      default:
        return `!${String.fromCharCode(cp + 0x21)}`;
    }
  });
stringEscapes['^'.charCodeAt(0)] = '_@';
stringEscapes['_'.charCodeAt(0)] = '__';
```

For each code point in `[0x00..0x21]` (i.e., NULL through
EXCLAMATION):

- Space (`0x20`) is special-cased to `!_`. The `_` is chosen for
  visual approximation of "space" (an underscore is the visual
  echo of a space).
- Exclamation (`0x21`) is special-cased to `!|`. The `|` is chosen
  for visual approximation of the exclamation's vertical stroke.
- Every other character `cp` in the range maps to `!` followed by
  the character at `cp + 0x21`. So U+0000 NULL → `!!` (0x21),
  U+0001 → `!"` (0x22), ..., U+001F → `!@` (0x40).

Outside that range, `^` (0x5E) and `_` (0x5F) are special-cased
*after* the array construction: `^` → `_@`, `_` → `__`. These
two need separate handling because they are outside `[0x00..0x21]`
but still need escaping to preserve the array-marker semantics
(`^` starts an array, `_` is the array-end escape prefix).

### Why the mapping preserves lexicographic order

The bare-block comment names the property: *relative lexicographic
ordering is preserved* by the mapping. To see why: the original
characters in `[0x00..0x21]` are mapped to a contiguous range
`[0x21..0x42]` (with two special cases at `_` `0x5F` and `|` `0x7C`).
The mapping is monotone within `[0x00..0x1F]` because each `cp`
maps to `cp + 0x21`, an order-preserving translation. Space and
exclamation fall outside this strict translation but their special
cases (`!_` and `!|`) sort correctly relative to the rest:

- `_` (0x5F) sorts above all the offset-by-0x21 characters
  (`0x21..0x40`), so `!_` (space-escape) sorts above `!@` (the
  escape of U+001F). The character originally at 0x20 (space)
  should sort above all characters in `[0x00..0x1F]`, and the
  escape sorts the same way.
- `|` (0x7C) sorts above `_` (0x5F), so `!|` (exclamation escape)
  sorts above `!_` (space escape). Originally `0x21 > 0x20`, and
  the escape preserves the order.

For unescaped characters (those outside `[0x00..0x21]` and not
equal to `^` or `_`), the byte sorts directly. To preserve the
boundary between escaped and unescaped: every escape sequence
starts with `!` (0x21). Any unescaped character is `>= 0x22` (the
characters `0x22..` ARE potentially unescaped; the unescaped
characters that survive are everything not in the escape table).
The escape sequence `!<x>` where `x >= 0x21` is two bytes; an
unescaped character `c >= 0x22` is one byte. Comparing `!x` and
`c` byte-by-byte: the first comparison is `0x21` vs `c`. Since
`c >= 0x22 > 0x21`, the unescaped `c` sorts above `!x`. That
matches the original semantic: the unescaped `c` was originally
some code point `>= 0x22`, and the escaped character was in
`[0x00..0x21]`, so `c` should sort above the escape, which it
does.

The result: the encoded string preserves byte-order with the
original string in all comparisons, both within the escaped range
and across the escaped/unescaped boundary.

### The `^` and `_` post-array-construction patch

After the loop constructs the [0x00..0x21] table, two trailing
assignments handle `^` and `_`:

```js
stringEscapes['^'.charCodeAt(0)] = '_@';
stringEscapes['_'.charCodeAt(0)] = '__';
```

These are outside the loop range but still need escaping for
unambiguous decoding:

- `^` starts an array in `compactOrdered`. If a string contained
  `^` without escape, the decoder would parse it as a nested
  array start.
- `_` is the prefix for `^`'s escape (`_@`). If a string contained
  `_` without escape, a `_` followed by `@` could be mis-parsed as
  the escape of `^`.

The chosen escapes `_@` and `__` both start with `_` (0x5F), which
is above the `!`-prefix range. The result is that escaped `^` and
`_` sort *above* every character that the `!`-prefix scheme
covers, matching the original order: `^` (0x5E) and `_` (0x5F)
are both above 0x21 (the boundary of the escape range), so they
should and do sort above all escaped characters.

### The `legacyOrdered` identity passthrough

For backward compatibility with the prior format, `legacyOrdered`
encodes strings with no transformation:

```js
const encodeLegacyStringSuffix = str => str;
const decodeLegacyStringSuffix = encoded => encoded;
```

Documented as:

```
Trivially identity-encodes a string for use in the "legacyOrdered"
format.
```

The escaping work in `legacyOrdered` happens at the array level
instead, via `encodeLegacyArray`'s U+0001 escape over the
already-encoded element bytes. The split between the two formats
preserves a wire-compatibility path (old decoders can still read
new encoders' `legacyOrdered` output) while letting new code opt
into the lower-expansion `compactOrdered` form.

### The `~`-prefix discriminator that distinguishes the two formats

A `compactOrdered`-encoded passable starts with a literal `~`
prefix that the decoder strips:

```js
encodePassable = passable => `~${encodeCompact(passable)}`;
```

```js
const decodePassable = encoded => {
  // A leading "~" indicates the v2 encoding (with escaping in
  // strings rather than arrays).
  if (encoded.charAt(0) === '~') {
    return decodeCompact(encoded, 1);
  }
  return decodeLegacy(encoded);
};
```

The `~` discriminator is the wire-side mechanism that lets both
encodings coexist on the same store. The character `~` (0x7E) sorts
*above* all `compactOrdered` and `legacyOrdered` outputs (since
those output type-character ranges are in `[!..z]`), so a
`compactOrdered`-encoded key sorts above all `legacyOrdered`-
encoded keys, preserving the format-level "namespace" without
breaking either format's internal sort order.

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/e6192056a5d7ff5acb084f6a58dca3663aa9943e/packages/marshal/src/encodePassable.js#L249-L330) at commit `e6192056`.
