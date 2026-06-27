---
title: Body
source: packages/marshal/src/encodePassable.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodePassable.js
source_line_range: "160-247"
source_commit: c423ed37b4c574aaccd778fc72acb2ff8910d586
comment_subject: "Variant Elias-delta encoding of bigints with sign-aware unary-prefix alphabets and ten's-complement digit encoding so positive and negative bigints of arbitrary magnitude sort in their natural numeric order"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-encodepassable-js--bigint-encoding-elias-delta-with-sign-aware-alphabets
---

### Three components: unary length-of-length, length, digits

The JSDoc above `encodeBigInt`:

```
Encode a JavaScript bigint using a variant of Elias delta coding,
with an initial component for the length of the digit count as a
unary string, a second component for the decimal digit count, and
a third component for the decimal digits preceded by a gratuitous
separating colon.
```

The encoder's body for positive values is:

```js
return `p${
  // A "~" for each digit beyond the first
  // in the decimal *count* of decimal digits.
  '~'.repeat(lDigits - 1)
}${
  // The count of digits.
  nDigits
}:${
  // The digits.
  n
}`;
```

So for the bigint `12345n`, `nDigits = 5`, `lDigits = 1` (the count
`5` has one decimal digit), and the encoding is `p` + `~`.repeat(0)
+ `5` + `:` + `12345` = `p5:12345`.

For the bigint `100n`, `nDigits = 3`, `lDigits = 1`, and the encoding
is `p3:100`.

For a bigint with a many-digit count, e.g. `n` with `nDigits = 10`:
`lDigits = 2` (the count `10` has two decimal digits), and the
encoding is `p` + `~`.repeat(1) + `10` + `:` + `<ten digits>`
= `p~10:0123456789` (or whatever the actual digits are).

The unary prefix `~`.repeat(lDigits - 1) tells the *decoder* how
many decimal characters to read as the digit count: read `lDigits`
decimal characters (which is `1` + the count of `~`s), parse them
as the number of digits, then read that many decimal digits.

### Why the unary prefix is necessary

Without the unary length-of-length prefix, the decoder could not
know where the digit count ends and the digits begin. Consider
`p10:` (encoding of a 10-digit number, with one-digit count `1` and
zero leading `~`s — but wait, that's wrong, because for `lDigits = 1`
the prefix has zero `~`s but the count's digit `1` looks like the
start of the actual number digits to a parser without context).

The unary prefix solves this: every `~` (or `#` for negatives)
between the type character and the first decimal digit tells the
decoder "the digit count is one character longer than you would
otherwise read". The decoder then reads exactly `1 + count(~)`
characters as the digit count, skips the `:`, and reads `nDigits`
characters as the digits.

The trailing `:` is what the comment calls "gratuitous" — strictly,
the digit count and the digit string of length `nDigits` are
contiguous and the decoder has full information without the
separator. The colon is in place to make the encoding human-readable
and easier to debug; it is not load-bearing for decoding correctness.

### Sign-aware unary alphabets: `#` for negative, `~` for positive

The comment names the lexicographic-sort design directly:

```
To ensure that the lexicographic sort order of encoded values
matches the numeric sort order of the corresponding numbers, the
characters of the unary prefix are different for negative values
(type "n" followed by any number of "#"s [which sort before decimal
digits]) vs. positive and zero values (type "p" followed by any
number of "~"s [which sort after decimal digits]) and each decimal
digit of the encoding for a negative value is replaced with its
ten's complement (so that negative values of the same scale sort
by *descending* absolute value).
```

The reasoning works in three layers:

1. **Type-character sort order**: `n` (0x6E) < `p` (0x70). All
   encoded negatives start with `n` and all encoded positives with
   `p`, so negatives sort before positives at the type-character
   level.
2. **Unary-character sort order**: ASCII `#` (0x23) is below ASCII
   `0..9` (0x30..0x39); ASCII `~` (0x7E) is above. For negatives,
   *more `#`s* means a larger digit count means a more-negative
   value (further from zero); since `#` sorts below digits, the
   negative encoding with more `#`s sorts *below* the negative
   encoding with fewer `#`s. For positives, *more `~`s* means a
   larger digit count means a larger value; since `~` sorts above
   digits, the positive encoding with more `~`s sorts *above* the
   one with fewer.

   The two cases differ because the lexicographic-order goal is
   different in each: for negatives, larger magnitude must sort
   below smaller magnitude; for positives, larger magnitude must
   sort above smaller magnitude. The alphabet choice
   (below-digits for negatives, above-digits for positives) achieves
   each.
3. **Same-length comparison**: when two negative values have the
   same digit count, the unary prefixes are the same length and
   the comparison falls through to the decimal digits. Without
   further intervention, larger absolute values would have
   numerically-larger decimal strings, which sort *above* smaller
   ones; the negative-larger-absolute-value goal is the opposite.
   The next mechanism fixes this case.

### Ten's-complement digit encoding for negatives

For negative values, each decimal digit of the encoding is replaced
with its ten's complement: `0` → `9`, `1` → `8`, ..., `9` → `0`,
and the leading-digit-count is also ten's-complemented. The body:

```js
return `n${
  '#'.repeat(lDigits - 1)
}${
  (10 ** lDigits - nDigits).toString().padStart(lDigits, '0')
}:${
  (10n ** BigInt(nDigits) + n).toString().padStart(nDigits, '0')
}`;
```

For the negative bigint `-100n`: `nDigits = 3` (the decimal digit
count of the absolute value), `lDigits = 1`. The ten's-complement
of the count is `10 - 3 = 7`. The ten's-complement of the digits
`100` is `10n ** 3n + (-100n) = 900n` → `"900"`. So the encoding
is `n7:900`.

For the negative bigint `-12345n`: `nDigits = 5`, `lDigits = 1`.
Count complement = `10 - 5 = 5`. Digit complement = `10n ** 5n +
(-12345n) = 87655n` → `"87655"`. Encoding: `n5:87655`.

Compare:

- `-100n` → `n7:900`
- `-12345n` → `n5:87655`

By the same-length-prefix argument: both encodings have `n` plus
zero `#`s, then a single decimal digit, then `:`, then the digits.
`n5:87655` < `n7:900` lexicographically (the leading digit `5` < `7`),
which corresponds to `-12345n < -100n` numerically. ✓

The same-length argument extended: for two negatives with the same
`nDigits`, the larger-absolute-value one has the smaller (after
ten's complement) digit string, which sorts below the smaller-
absolute-value one's larger ten's-complement digit string. That
gives the descending-absolute-value sort order the comment promises.

### Decoder symmetry

The decoder reverses each transformation:

```js
let nDigits = parseInt(snDigits, 10);
if (typePrefix === 'n') {
  // TODO Assert to reject forbidden encodings
  // like "n0:" and "n00:…" and "n91:…" through "n99:…"?
  nDigits = 10 ** /** @type {number} */ (lDigits) - nDigits;
}

tail.charAt(0) === ':' || Fail`Separator expected: ${encoded}`;
digits.length === nDigits ||
  Fail`Fixed-length digit sequence expected: ${encoded}`;
let n = BigInt(digits);
if (typePrefix === 'n') {
  // TODO Assert to reject forbidden encodings
  // like "n9:0" and "n8:00" and "n8:91" through "n8:99"?
  n = -(10n ** BigInt(nDigits) - n);
}
```

The TODOs the comment marks are about *encoding canonicality*: there
are forbidden encodings the decoder currently accepts. For example,
`n0:` would decode to `nDigits = 10 - 0 = 10`, but then the digit
sequence has zero characters not ten, which the length check
rejects. The TODOs suggest tightening to reject these inputs at
parse time rather than letting them fail downstream. The TODOs do
not affect the sort-order property; they are tightening for
defense-in-depth.

### Zero

Zero is encoded as a positive value with `nDigits = 1` and the
single decimal digit `0`. The encoding is `p1:0`. It is not
encoded as a negative because the type-character split is
"strictly negative" vs. "positive or zero", which keeps zero on
the positive side of the `n`-vs-`p` divide.

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/c423ed37b4c574aaccd778fc72acb2ff8910d586/packages/marshal/src/encodePassable.js#L160-L247) at commit `c423ed37`.
