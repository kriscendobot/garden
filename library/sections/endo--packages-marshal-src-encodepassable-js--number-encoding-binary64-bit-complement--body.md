---
title: Body
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

### The C-union trick for float-to-bits

The comment above `encodeBinary64` opens by naming what it is doing
and naming why it would be hard to do otherwise:

```
This is the JavaScript analog to a C union: a way to map between a
float as a number and the bits that represent the float as a buffer
full of bytes. Note that the mutation of static state here makes
this invalid Jessie code, but doing it this way saves the nugatory
and gratuitous allocations that would happen every time you do a
conversion -- and in practical terms it's safe because we put the
value in one side and then immediately take it out the other; there
is no actual state retained in the classic sense and thus no
re-entrancy issue.
```

The mechanism is two views over the same backing `BigUint64Array(1)`:

```js
const { buffer: hiddenBuffer } = new BigUint64Array(1);
const bufferView = new DataView(hiddenBuffer);
```

`bufferView.setFloat64(0, f)` writes the IEEE-754 representation of
`f` into the shared backing buffer; `bufferView.getBigUint64(0)`
then reads those same bytes back as an unsigned 64-bit integer.
The comment flags two facts about this construction:

1. **It is invalid Jessie code** because Jessie (the
   capability-safe JavaScript subset) forbids mutable static state
   (the file-scope `hiddenBuffer` is exactly that). The author is
   conscious of the breach and names it.
2. **It is operationally safe** because the put-then-immediate-get
   pattern leaves no observable state behind: there is no scheduling
   point between the write and the read at which another caller
   could observe a stale value. The hidden buffer is effectively a
   one-instruction register, not a multi-step accumulator.

The cycle-71 ingest of `passStyleOf.js` recorded the same shape
(its `passStyleMemo` is also a mutable-static-state breach with a
recorded rationale); the *forbid mutable static state* discipline
and its few worked rationales appear under the
`[[security-as-extreme-modularity]]` concept page.

### The bit-complement trick for sort-order preservation

The body of `encodeBinary64`:

```js
const encodeBinary64 = f => {
  // Normalize -0 to 0 and NaN to a canonical encoding
  if (is(f, -0)) {
    f = 0;
  }
  bufferView.setFloat64(0, f);
  let bits = bufferView.getBigUint64(0);
  if (is(f, NaN)) {
    bits = canonicalNaN;
  }
  if (f < 0) {
    bits ^= 0xffffffffffffffffn;
  } else {
    bits ^= 0x8000000000000000n;
  }
  return `f${zeroPad(bits.toString(16), 16)}`;
};
```

The bare-block comment immediately above explains the strategy:

```
JavaScript numbers are encoded by outputting the base-16
representation of the binary value of the underlying IEEE floating
point representation. For negative values, all bits of this
representation are complemented prior to the base-16 conversion,
while for positive values, the sign bit is complemented. This
ensures both that negative values sort before positive values and
that negative values sort according to their negative magnitude
rather than their positive magnitude. This results in an ASCII
encoding whose lexicographic sort order is the same as the numeric
sort order of the corresponding numbers.
```

Why the two-cases-by-sign? IEEE-754 doubles are encoded as
`<sign-bit><11-bit-biased-exponent><52-bit-mantissa>`. As an
unsigned 64-bit integer, the raw bit pattern of `+0.0` is
`0x00...0`, and the raw bit pattern of `-0.0` is `0x80...0`, so
negative zero sorts *above* positive zero by raw bits. More
generally, positive numbers are arranged with smaller magnitude at
lower bit patterns and larger magnitude at higher; negative numbers
are arranged with *smaller magnitude at higher bit patterns* and
larger magnitude at the highest bit patterns. Without the
bit-complement, the raw-bits sort order would place positive
numbers below negative numbers and would sort negative numbers in
ascending-magnitude order rather than descending-magnitude order.

The two cases of the XOR mask reverse both problems:

- **Positive case (`bits ^= 0x8000000000000000n`)**: flip the sign
  bit. A positive number's sign bit goes from `0` to `1`, so its
  encoded high nibble is in `8..f`. Numerically larger positives
  have larger raw bits, which (after sign flip) still have larger
  unsigned values, which sort *above* numerically-smaller positives.
  Result: positives sort ascending by magnitude in the upper half
  of the unsigned space.
- **Negative case (`bits ^= 0xffffffffffffffffn`)**: flip every
  bit. A negative number's sign bit goes from `1` to `0`, so its
  encoded high nibble is in `0..7` (below the positives'
  `8..f` range). The remaining bits are also inverted, which
  reverses the ascending-magnitude order of the raw bits into a
  descending-magnitude order. Result: negatives sort by descending
  magnitude (i.e., ascending value, most-negative first) in the
  lower half of the unsigned space.

Together the two masks give a single unsigned 64-bit integer space
in which numbers sort in their natural numeric order: most-negative
first, then negative-zero (now equal to positive-zero via the
upstream normalization), then positive in ascending magnitude.

The 16-hex-digit zero-padded string output is then a lexicographic
representation of that integer, which is a direct stand-in for the
unsigned integer's order under string comparison.

### Why the `-0` normalization happens before encoding

JavaScript distinguishes `-0` and `0` at the bit level (different
IEEE patterns) but treats them as equal under `===`. If the
encoder fed `-0` through `setFloat64`, the raw bits would be
`0x80...0` (the negative-zero pattern), which the bit-complement
mask would then promote: the sign bit would flip to `0` and the
encoded value would sort *below* positive zero. That would break
the equality-correspondence invariant: two values equal under
`===` would have unequal encoded forms.

The early `is(f, -0)` check rewrites `-0` to `0` so the encoding
of both is `f${zeroPad((0x8000000000000000n).toString(16), 16)}`
= `f8000000000000000` (in the positive-case mask path). The
encoding now reflects equality under `===` even when bit-level
representation differs.

### NaN canonicalization without depending on lockdown

The comment block above the canonical NaN constant names the
dependency-avoidance reason directly:

```
Because @endo/marshal does not depend on `ses`, it certainly
cannot depend on `lockdown()` being called. But the DataView
methods are only tamed to canonicalize NaNs by lockdown. Therefore
we need to do our own NaN canonicalization here.

See https://webidl.spec.whatwg.org/#js-unrestricted-double which
implies that this is the canonical NaN for web standards.
Casual googling stongly suggests that this is also the cosmWasm
canonical NaN. But I have not yet found an authoritative page
stating this.
```

There are many distinct IEEE-754 NaN bit patterns (any pattern with
all-1 exponent and non-zero mantissa is a NaN). If the encoder
preserved the input NaN's specific bit pattern, two inputs that
are both NaN under `is(f, NaN)` could encode to different strings.
That would defeat the equality-correspondence invariant the
preceding `-0` normalization also exists to protect.

`lockdown()` canonicalizes NaN bit patterns at the language level
by replacing the `Float64Array.prototype.{get,set}` machinery, so
within an SES-locked-down realm, any DataView write of a NaN
produces a single canonical bit pattern. The marshal package
however is meant to be usable without SES (per the package's
ecosystem-compatibility design), so it cannot count on lockdown
having run. It carries its own canonical NaN constant and
substitutes it inline after the `setFloat64` and before the XOR
mask:

```js
const canonicalNaN = 0x7ff8000000000000n;
```

The bit pattern matches the WebIDL "unrestricted double" canonical
NaN, which is the same bit pattern lockdown's NaN-canonicalization
shim uses. The shape-correspondence between the marshal
implementation and lockdown's shim is intentional: an encoder
output produced in a non-lockdown realm matches one produced in a
lockdown realm bit-for-bit on NaN inputs.

The comment also names the cosmWasm canonical NaN as a
likely-equivalent value, qualified by the author's uncertainty
about an authoritative reference. The library section preserves
the qualification rather than treating cosmWasm as confirmed
shared canonical-NaN ground.

Source: [packages/marshal/src/encodePassable.js](https://github.com/endojs/endo/blob/e6192056a5d7ff5acb084f6a58dca3663aa9943e/packages/marshal/src/encodePassable.js#L86-L158) at commit `e6192056`.
