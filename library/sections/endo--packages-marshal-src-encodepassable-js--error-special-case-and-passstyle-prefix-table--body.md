---
title: Body
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

### The isErrorLike fast-path

The inner encoder opens with this branch before its per-PassStyle
switch:

```js
const innerEncode = passable => {
  if (isErrorLike(passable)) {
    // We pull out this special case to accommodate errors that are not
    // valid Passables. For example, because they're not frozen.
    // The special case can only ever apply at the root, and therefore
    // outside the recursion, since an error could only be deeper in
    // a passable structure if it were passable.
    //
    // We pull out this special case because, for these errors, we're much
    // more interested in reporting whatever diagnostic information they
    // carry than we are about reporting problems encountered in reporting
    // this information.
    return encodeError(passable, innerEncode);
  }
  const passStyle = passStyleOf(passable);
  switch (passStyle) {
    // ...
  }
};
```

Two facts the comment establishes:

1. **Scope**: the fast-path applies only at the root of the
   recursion. Inside a deeper traversal, any error has already
   had to be passable (the recursion only enters non-error values
   when the structure containing them is passable), so the special
   case cannot apply transitively.
2. **Priority**: when the input is an error, the encoder prefers
   to *report whatever diagnostic information the error carries*
   over reporting validation failures about the error itself
   (e.g., that it is not frozen, that its prototype chain is
   wrong, that it has extra non-Passable properties). The error's
   message and stack trace are observable, valuable signal; a
   `passStyleOf` validation failure on the same error would hide
   that signal behind a different (and likely less useful)
   exception.

The library's previous comment-fragment ingest of `encodeToSmallcaps.js`
(cycle 69) recorded the same shape under
`error-encoding-root-special-case`. The two encoders are siblings
that share the diagnostic-priority rule; the more recent
`marshal.js` ingest (cycle 74) recorded a third instance under
`error-diagnostic-priority`. The pattern is consistent enough
across the marshal layer to be a load-bearing convention worth
naming separately from any one site.

### The per-PassStyle switch

The body of the switch maps each PassStyle to a per-style encoder:

```js
switch (passStyle) {
  case 'null': return 'v';
  case 'undefined': return 'z';
  case 'number': return encodeBinary64(passable);
  case 'string': return `s${encodeStringSuffix(passable)}`;
  case 'boolean': return `b${passable}`;
  case 'bigint': return encodeBigInt(passable);
  case 'remotable': return encodeRemotable(passable, innerEncode);
  case 'error': return encodeError(passable, innerEncode);
  case 'promise': return encodePromise(passable, innerEncode);
  case 'symbol': {
    const name = nameForPassableSymbol(passable);
    assert.typeof(name, 'string');
    return `y${encodeStringSuffix(name)}`;
  }
  case 'copyArray': return encodeArray(passable, innerEncode);
  case 'byteArray': return encodeByteArray(passable, innerEncode);
  case 'copyRecord': return encodeRecord(passable, encodeArray, innerEncode);
  case 'tagged': return encodeTagged(passable, encodeArray, innerEncode);
  default: throw Fail`a ${q(passStyle)} cannot be used as a collection passable`;
}
```

Two single-byte literals (`v` for null and `z` for undefined) and
one prefix-only encoding (`b<true|false>`) carry their entire
information in the type byte and (for boolean) a fixed suffix.
The remaining PassStyles delegate to per-style encoders that
include their type prefix as part of the encoded string.

### The canonical passStylePrefixes table

After the encoder pipeline, the file exports the canonical
prefix table:

```js
export const passStylePrefixes = {
  error: '!',
  copyRecord: '(',
  tagged: ':',
  promise: '?',
  copyArray: '[^',
  byteArray: 'a',
  boolean: 'b',
  number: 'f',
  bigint: 'np',
  remotable: 'r',
  string: 's',
  null: 'v',
  symbol: 'y',
  undefined: 'z',
};
Object.setPrototypeOf(passStylePrefixes, null);
harden(passStylePrefixes);
```

The bare-block comment immediately above explains the table's
multi-purpose role:

```
The single prefix characters to be used for each PassStyle
category. `bigint` is a two-character string because each of those
characters individually is a valid bigint prefix (`n` for
"negative" and `p` for "positive"), and copyArray is a
two-character string because one encoding prefixes arrays with
`[` while the other uses `^` (which is prohibited from appearing
in an encoded string).
The ordering of these prefixes is the same as the rankOrdering of
their respective PassStyles, and rankOrder.js imports the table
for this purpose.

In addition, `|` is the remotable->ordinal mapping prefix:
This is not used in covers but it is reserved from the same set
of strings. Note that the prefix is > any prefix used by any cover
so that ordinal mapping keys are always outside the range of valid
collection entry keys.
```

Four key facts the comment names:

1. **Multi-character prefixes**: `bigint: 'np'` is two characters
   because both `n` and `p` are valid first bytes for the bigint
   cover (see the sister section on bigint encoding); a value
   whose first byte is `n` is a negative bigint, whose first byte
   is `p` is a non-negative bigint. `copyArray: '[^'` is two
   characters because legacyOrdered uses `[` and compactOrdered
   uses `^`; both are valid first bytes for the copyArray cover.
2. **Table ordering = rankOrder ordering**: the source-order of
   keys in this object literal matches the rankOrder PassStyle
   ordering, and `rankOrder.js` imports this table to drive its
   per-PassStyle comparison logic. The table is the single source
   of truth for which PassStyle sorts above which; downstream code
   reads it rather than duplicating the order.
3. **Reserved `|` prefix outside the cover range**: the keyed
   store's substrate (used to implement collections like CopyMap
   and CopyBag) uses a remotable-to-ordinal mapping where each
   remotable key gets an ordinal index. The encoded ordinal keys
   use `|` as their first byte; `|` is positioned at `0x7C` which
   is *above* every PassStyle prefix used in the cover machinery
   (the highest cover prefix is `z` at `0x7A`). The result is that
   any ordinal-mapping key sorts *above* any value key in the
   keyed store, keeping the two namespaces cleanly separated on
   the wire.
4. **Comment qualification on `|`**: "This is not used in covers
   but it is reserved from the same set of strings." The
   reservation is necessary even though `|` is not a PassStyle
   prefix, because some other future use of a wider character set
   could otherwise accidentally collide with the ordinal-mapping
   scheme.

### The Array.prototype.sort-induced `undefined` position

The very last entry in the table carries an inline comment:

```js
  // Because Array.prototype.sort puts undefined values at the end
  // without passing them to a comparison function, undefined MUST
  // be the last category.
  undefined: 'z',
```

The constraint is JavaScript-language-imposed:
`Array.prototype.sort` has a quirky special case for `undefined`
elements — it places them at the end of the result regardless of
the comparator's verdict. If `undefined` were placed anywhere
other than last in this table, marshal's downstream sort
operations that rely on `passStylePrefixes`'s ordering would
disagree with `Array.prototype.sort`'s special-case behavior on
inputs that include `undefined`.

The character `z` (0x7A) is the highest PassStyle prefix that the
cover machinery uses; placing `undefined` at `z` makes it sort
last *within* the cover range, matching the language-level
behavior. (`|` at 0x7C is above `z`, but `|` is the
ordinal-mapping prefix outside the cover range, and is therefore
a separate namespace whose sort position is irrelevant to the
language-level `undefined` placement.)

### Null prototype + harden

```js
Object.setPrototypeOf(passStylePrefixes, null);
harden(passStylePrefixes);
```

The null-prototype + harden discipline is the standard
endo-defensive shape for module-exported tables: the prototype is
nulled so the table cannot be confused for a prototype-inheriting
object that picks up properties from `Object.prototype`, and
`harden` freezes it transitively so consumers cannot mutate it.
This is the same discipline `passStyleOf.js` applies to its
PassStyle constants.

### Per-style encoders' coordination with the table

The first character each per-style encoder emits is the same byte
named in the table:

- `encodeBinary64` returns `f${...}` — matches `number: 'f'`.
- `encodeBigInt` returns `p${...}` or `n${...}` — matches
  `bigint: 'np'`.
- The literal returns in the switch (`'v'`, `'z'`) — match
  `null: 'v'`, `undefined: 'z'`.
- The boolean encoding `` `b${passable}` `` — matches
  `boolean: 'b'`.
- The string encoding `` `s${encodeStringSuffix(passable)}` `` —
  matches `string: 's'`.
- The symbol encoding `` `y${encodeStringSuffix(name)}` `` —
  matches `symbol: 'y'`.
- `encodeRemotable` is wrapped by `makeEncodeRemotable` which
  asserts `encoding.charAt(0) === 'r'` — matches `remotable: 'r'`.
- `encodePromise` wrapped to assert `'?'` — matches
  `promise: '?'`.
- `encodeError` wrapped to assert `'!'` — matches `error: '!'`.
- `encodeRecord` returns `` `(${...}` `` — matches
  `copyRecord: '('`.
- `encodeTagged` returns `` `:${...}` `` — matches
  `tagged: ':'`.
- The byteArray prefix `'a'` is referenced in the table; the
  encoder is currently a stub (`Fail\`encodePassable(byteArray)
  not yet implemented\``). The prefix is reserved for when the
  implementation lands.
- `copyArray` uses `[` or `^` per format choice.

The full per-style coordination keeps the table and the encoders
agreeing on first-byte semantics by construction.

### `isEncodedRemotable` as the cross-module reader

A small exported helper lets downstream code identify a remotable
key without re-parsing the encoding:

```js
export const isEncodedRemotable = encoded => encoded.charAt(0) === 'r';
```

The check is one byte: read the first character, compare to `r`.
The store substrate uses this to decide which keys are eligible
for the ordinal-mapping (only remotables get ordinal-substituted
in collection-key encodings).

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/e6192056a5d7ff5acb084f6a58dca3663aa9943e/packages/marshal/src/encodePassable.js#L598-L911) at commit `e6192056`.
