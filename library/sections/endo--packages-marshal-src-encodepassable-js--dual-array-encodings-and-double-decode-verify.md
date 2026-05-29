---
title: The legacyOrdered and compactOrdered array encodings, the wire-byte tradeoffs, and the embeddability-verifying double-decode check on user-supplied remotable / promise / error encodings
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
---

## Abstract

`encodePassable.js` carries **two parallel array encodings**: the
`legacyOrdered` format uses `[` as the start-of-array marker, U+0000
NULL as the element terminator, and U+0001 START OF HEADING as the
escape prefix for embedded U+0000 or U+0001 bytes; the
`compactOrdered` format uses `^` as the start-of-array marker and a
literal space (U+0020) as the element terminator. The `compactOrdered`
format omits per-element escaping at the array level because each
element's string-encoded form has already had the reserved characters
escaped at the string level (sister section). The wire-bytes tradeoff:
`compactOrdered` pays string-level overhead only for characters that
actually appear, while `legacyOrdered` paid array-level overhead on
every element's encoded bytes regardless of content. The encoder
*additionally* applies a **double-decode verification step** to the
output of every user-provided `encodeRemotable` / `encodePromise` /
`encodeError` callback in the `compactOrdered` format: it wraps the
candidate encoding inside a synthetic three-element array between
`null` markers, decodes it back, and confirms the round trip matches.
That check enforces the invariant that user-provided encodings must
remain free of C0 controls and must be safely embeddable inside an
encoded array — i.e., the user cannot accidentally inject an
array-element terminator or escape prefix and break the framing.

In code quotations below, U+0000 is rendered as `<NUL>` and U+0001
as `<SOH>` to keep the file readable; the upstream source uses
the literal control characters.

## Body

### Encoding an array: legacyOrdered

The `legacyOrdered` array encoder wraps every encoded element in a
per-byte escape pass:

```js
const encodeLegacyArray = (array, encodePassable) => {
  const chars = ['['];
  for (const element of array) {
    const enc = encodePassable(element);
    for (const c of enc) {
      if (c === '<NUL>' || c === '<SOH>') {
        chars.push('<SOH>');
      }
      chars.push(c);
    }
    chars.push('<NUL>');
  }
  return chars.join('');
};
```

For each element, the encoder emits the element's encoded string
character by character. If a character is U+0000 (the terminator)
or U+0001 (the escape prefix itself), the encoder emits U+0001
followed by the character. After the last character of the element,
the encoder emits U+0000 as the terminator. The leading `[` marks
the start of the array.

The decoder reverses this:

```js
const decodeLegacyArray = (encoded, decodePassable, skip = 0) => {
  const elements = [];
  const elemChars = [];
  let stillToSkip = skip + 1;
  let inEscape = false;
  for (const c of encoded) {
    if (stillToSkip > 0) {
      stillToSkip -= 1;
      if (stillToSkip === 0) {
        c === '[' || Fail`Encoded array expected: ${getSuffix(encoded, skip)}`;
      }
    } else if (inEscape) {
      c === '<NUL>' ||
        c === '<SOH>' ||
        Fail`Unexpected character after u0001 escape: ${c}`;
      elemChars.push(c);
    } else if (c === '<NUL>') {
      const encodedElement = elemChars.join('');
      elemChars.length = 0;
      const element = decodePassable(encodedElement);
      elements.push(element);
    } else if (c === '<SOH>') {
      inEscape = true;
      continue;
    } else {
      elemChars.push(c);
    }
    inEscape = false;
  }
  // ...
};
```

The decoder tracks an `inEscape` flag. When it sees U+0001, it sets
the flag; the next character is added verbatim (no terminator
semantics). When it sees U+0000 without the flag, it treats it as
the element terminator and feeds the accumulated `elemChars` to
the inner `decodePassable`.

### Encoding an array: compactOrdered

```js
const encodeCompactArray = (array, encodePassable) => {
  const chars = ['^'];
  for (const element of array) {
    const enc = encodePassable(element);
    chars.push(enc, ' ');
  }
  return chars.join('');
};
```

Each element's encoded string is appended verbatim, followed by a
space terminator. No per-byte escape pass: the per-element string
content has already been escaped at the string encoder level. The
leading `^` marks the start of the array.

The decoder uses `String.matchAll(/[\^ ]/g)` to find every array-
start and array-element-terminator in one pass:

```js
const decodeCompactArray = (encoded, decodePassable, skip = 0) => {
  const elements = [];
  let depth = 0;
  let nextIndex = skip + 1;
  let currentElementStart = skip + 1;
  for (const { 0: ch, index: i } of encoded.matchAll(/[\^ ]/g)) {
    const index = i;
    if (index <= skip) {
      if (index === skip) {
        ch === '^' || Fail`Encoded array expected: ${getSuffix(encoded, skip)}`;
      }
    } else if (ch === '^') {
      // This is the start of a nested array.
      // TODO: Since the syntax of nested arrays must be validated
      // as part of decoding the outer one, consider decoding them
      // here into a shared cache rather than discarding information
      // about their contents until the later decodePassable.
      depth += 1;
    } else {
      // This is a terminated element.
      if (index === nextIndex) {
        // A terminator after `[` or an another terminator indicates that an array is done.
        depth -= 1;
        depth >= 0 ||
          Fail`unexpected array element terminator: ${encoded.slice(skip, index + 2)}`;
      }
      if (depth === 0) {
        // We have a complete element of the topmost array.
        elements.push(
          decodePassable(encoded.slice(currentElementStart, index)),
        );
        currentElementStart = index + 1;
      }
    }
    nextIndex = index + 1;
  }
  // ...
};
```

The decoder uses `depth` to track nested arrays. When it sees `^`,
depth increases; when it sees a space that immediately follows the
end of a nested array (the `index === nextIndex` check), depth
decreases. When depth returns to zero, the accumulated bytes
between the previous element's start and the current space are an
element of the outermost array.

The inline TODO is a hint at a future optimization: nested arrays
are parsed twice (once during outer decoding to find their
boundaries, once again during the recursive `decodePassable` of
the outer element). A future revision could cache the inner parse.
The library section preserves the TODO as upstream-acknowledged
future work.

### Why two formats exist

The JSDoc above `encodeLegacyArray` explains the motivation for
having a second format:

```
Performs the original array encoding, which escapes all encoded
array elements rather than just strings (U+0000 as the element
terminator and U+0001 as the escape prefix for U+0000 or U+0001).
This necessitated an undesirable amount of iteration and
expansion; see https://github.com/endojs/endo/pull/1260#discussion_r960369826
```

The `legacyOrdered` array encoder iterates over every character
of every element's encoded form and escapes the two reserved
control bytes. For long encoded arrays of long strings, that is a
substantial amount of per-character work and, statistically, every
encoded byte has some probability of being escaped (since C0
controls can appear in any string).

The `compactOrdered` format pushes that work out of the array
encoder and into the string encoder, where the escape table is
designed to escape only the small contiguous range `[0x00..0x21]`
plus the two array-marker characters `^` and `_`. The vast
majority of bytes in a typical encoded string pass through the
string encoder unchanged. The array encoder then needs no per-byte
escape pass; it just concatenates pre-escaped elements with space
terminators.

### Format-selection on the wire: the `~` discriminator

Both formats coexist on the same database without colliding because
`compactOrdered`-encoded keys carry a literal leading `~` byte that
`legacyOrdered`-encoded keys do not:

```js
if (format === 'compactOrdered') {
  // ...
  encodePassable = passable => `~${encodeCompact(passable)}`;
} else if (format === 'legacyOrdered') {
  encodePassable = makeInnerEncode(
    encodeLegacyStringSuffix,
    encodeLegacyArray,
    encodeOptions,
  );
}
```

```js
const decodePassable = encoded => {
  // A leading "~" indicates the v2 encoding (with escaping in strings rather than arrays).
  // Skip it inside `decodeCompact` to avoid slow `substring` in XS.
  if (encoded.charAt(0) === '~') {
    return decodeCompact(encoded, 1);
  }
  return decodeLegacy(encoded);
};
```

The XS-related comment recurs throughout the file: avoid
`substring` because XS's implementation is slow. Several `skip`
parameters across the encode/decode functions exist specifically
to let the call chain pass an index into a shared input string
rather than allocating new substrings for each recursive call. The
XS performance constraint shapes the API more than a typical
performance polish would.

### The double-decode embeddability check

The most subtle invariant `compactOrdered` enforces is on
**user-provided encoders** for remotables, promises, and errors.
These three pass styles cannot be encoded fully by `encodePassable`
because their identity is application-specific: the application
provides a callback `encodeRemotable: (r, encodeRecur) => string`
that returns a unique key for each remotable. The library wraps
each user-provided callback in a sanity-check that confirms the
output is *embeddable*: free of C0 controls, free of bare spaces,
free of bare `^`, etc. — anything that could break array framing
or string-escape semantics.

The wrapper construction:

```js
const verifyEncoding = (encoding, label) => {
  !encoding.match(rC0) ||
    Fail`${b(label)} encoding must not contain a C0 control character: ${encoding}`;
  const decoded = decodeCompactArray(`^v ${encoding} v `, liberalDecode);
  (isArray(decoded) &&
    decoded.length === 3 &&
    decoded[0] === null &&
    decoded[2] === null) ||
    Fail`${b(label)} encoding must be embeddable: ${encoding}`;
};
```

The first check is direct: a regex match against C0 controls
(`/[\x00-\x1F]/`) fails the encoding if any byte is below U+0020.

The second check is the **double-decode**. The wrapper constructs
a synthetic encoded array containing three elements:

- `v` (the encoding for `null`)
- the candidate encoding from the user-provided callback
- `v` (another `null`)

The array is `` `^v ${encoding} v ` `` — a `^`, `v` `null`, space,
the candidate, space, `v`, space. If the candidate encoding is
well-formed (does not contain any bare space, bare `^`, or other
characters that would change array framing), the synthetic array
decodes to `[null, <decoded candidate>, null]` — three elements
with the candidate in the middle. The wrapper asserts the result
is an array of length 3 with `null` bookends. If the candidate
contained a bare space, the array would have more than three
elements; if it contained a bare `^`, the decoder would see a
nested-array start where there should be a value.

The candidate is decoded under `liberalDecode`, a permissive
decoder that resolves remotable / promise / error encodings to
`undefined` rather than calling back into the application's
decoders. The decode is for *framing-validation* only; the
substantive decode is what the application's decoders do when the
encoding is actually used.

### Why the verify happens only in compactOrdered

The `verifyEncoding` callback is wired only in the
`compactOrdered` branch of `makePassableKit`. The `legacyOrdered`
branch passes user-provided encoders through unchanged. The
`legacyOrdered` format does its own per-byte escape pass when it
encounters U+0000 or U+0001 inside any element (including user-
provided ones), so the framing-corruption risk that
`verifyEncoding` defends against does not apply: bytes that would
otherwise break framing get escaped at array-encode time
regardless of where they came from.

In `compactOrdered`, the per-byte escape pass is at the *string*
encoder level, not the array encoder level. User-provided
encoders bypass the string encoder entirely (they emit their own
strings directly), so framing-breaking bytes in those strings
would be passed through unchecked. The double-decode is the
defense for that case.

### The three callback wrappers

The three callback wrappers all share the same shape:

```js
const makeEncodeRemotable = (unsafeEncodeRemotable, verifyEncoding) => {
  const encodeRemotable = (r, innerEncode) => {
    const encoding = unsafeEncodeRemotable(r, innerEncode);
    (typeof encoding === 'string' && encoding.charAt(0) === 'r') ||
      Fail`Remotable encoding must start with "r": ${encoding}`;
    verifyEncoding(encoding, 'Remotable');
    return encoding;
  };
  return encodeRemotable;
};
```

Each wrapper:

1. Calls the user-provided encoder.
2. Confirms the first character matches the type prefix expected
   by `passStylePrefixes` (`r` for remotable, `?` for promise,
   `!` for error). This is what coordinates per-PassStyle sort
   order: remotables sort under `r`, promises under `?`, errors
   under `!`, and the prefix-table ordering keeps them in the
   right slot.
3. Calls `verifyEncoding` (which is the double-decode check above,
   only in `compactOrdered`; a no-op in `legacyOrdered`).
4. Returns the encoding.

The user-provided encoders are wrapped once at `makePassableKit`
construction time; the wrappers are then what the rest of the
encoder pipeline sees. Application code that supplies callbacks
gets the defensive checks applied transparently.

## Translation

| encodePassable idiom | Adjacent vocabulary |
|---|---|
| "legacyOrdered" | the v1 array-escaped format; preserved for wire-compat |
| "compactOrdered" | the v2 string-escaped format introduced in PR #1260 |
| "verifyEncoding" | the double-decode framing-check applied in compactOrdered to user-provided encoders |
| "liberal decode" | the framing-validation decode that resolves remotable / promise / error to `undefined` |
| "embeddable" | safely placeable inside an encoded array element; free of C0 controls and reserved markers |
| "C0 controls" | U+0000 through U+001F; rejected by the regex in verifyEncoding |
| "depth tracking" | the decoder's mechanism for skipping nested arrays during outer-array element extraction |

## See also

- [`endo--packages-marshal-src-encodepassable-js--compact-format-string-escapes`](endo--packages-marshal-src-encodepassable-js--compact-format-string-escapes.md) — the string-escape side of the legacy/compact split; this section is the array-encoding side. Together they explain why `compactOrdered` reduces overhead and how the two formats coexist.
- [`endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table`](endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table.md) — the per-PassStyle prefix table assigns `r` to remotables, `?` to promises, `!` to errors; this section's wrapper-shaped first-character check is what enforces the table at the user-callback level.
- [`endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement`](endo--packages-marshal-src-encodepassable-js--number-encoding-binary64-bit-complement.md) — the per-PassStyle encoders are coordinated by the prefix table; this section's user-callback wrappers are the third leg of that coordination (after the per-PassStyle encoders and the table itself).
- [`endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants`](endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants.md) — smallcaps' canonical-encoding rule is the smallcaps-shaped analog of `compactOrdered`'s embeddability rule; both enforce that the encoder produces output the decoder will round-trip cleanly.
- [`endo--pkg-marshal-readme--beyond-json`](endo--pkg-marshal-readme--beyond-json.md) — the README's framing of marshal as a serialization layer that goes beyond JSON; this section's `compactOrdered` is the database-key-shaped form of that layer.

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/e6192056a5d7ff5acb084f6a58dca3663aa9943e/packages/marshal/src/encodePassable.js#L332-L475) at commit `e6192056`.
