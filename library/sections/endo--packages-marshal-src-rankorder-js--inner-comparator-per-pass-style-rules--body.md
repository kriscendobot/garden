---
title: Body
source: packages/marshal/src/rankOrder.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/rankOrder.js
source_line_range: "157-330"
source_commit: 337d16a895066a66e7c92d716449273d337dceb9
comment_subject: "How the inner comparator dispatches per PassStyle: each per-style rank rule, including the prefix-ranking property that lets a record/array X with a subset of Y's property names or a prefix of Y's elements sort earlier; the deep-tied implication of NaN as compareRemotables default; the byteArray shortlex rule; the @endo/immutable-arraybuffer prototype-check workaround"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules
---

### The four-tied PassStyles

```js
case 'undefined':
case 'null':
case 'error':
case 'promise': {
  // For each of these passStyles, all members of that passStyle are tied
  // for the same rank.
  return 0;
}
```

These four PassStyles have rank-order semantics where *every two
values of the style are tied*. Concretely:

- **`undefined`**: there is only one `undefined` value.
- **`null`**: there is only one `null` value.
- **`error`**: errors have rich content (message, stack, cause)
  but rank-order treats them as opaque; sorting a CopyArray of
  errors leaves them in input order (the underlying sort is
  stable, so this is observably idempotent).
- **`promise`**: promises are remote references whose identity
  is the only thing the rank-order layer can see; even
  "the same promise twice" is not a fact rank-order
  distinguishes (other layers handle promise identity).

The "tied for the same rank" framing is what the `compareRank`
contract means at this leaf: 0 here is a *deliberate*
indistinguishability, not a missing implementation.

### Trivial less-than for boolean and bigint

```js
case 'boolean':
case 'bigint': {
  // Within each of these passStyles, the rank ordering agrees with
  // JavaScript's relational operators `<` and `>`.
  return trivialComparator(left, right);
}
```

JavaScript's `<` for booleans treats `false` as 0 and `true` as
1, so `false < true`. The `trivialComparator` is a tiny wrapper
around `<`/`===`/`>` returning -1/0/1. For bigints, the same
operator does mathematical comparison across the unbounded
integer range. Note that bigints are *also* handled correctly
by `compareNumerics` (its template parameter accepts `bigint`);
the trivial-less-than path here is simpler and equivalent.

### Symbol via name string

```js
case 'symbol': {
  return comparator(
    nameForPassableSymbol(left),
    nameForPassableSymbol(right),
  );
}
```

A *passable symbol* is either a well-known symbol (e.g.,
`Symbol.iterator`) or a registered symbol (one constructed via
`Symbol.for(name)`). `nameForPassableSymbol` returns the
canonical name string for either kind. The comparator then
recurses on those names — which are now `string` PassStyle
values and follow the `ENDO_RANK_STRINGS` mode.

The mutual recursion is what lets the rank order on symbols be
*derived* from the rank order on strings rather than separately
specified.

### CopyRecord: lexicographic by inverse-sorted names, then by values

This case is the most carefully designed:

```js
case 'copyRecord': {
  // Lexicographic by inverse sorted order of property names, then
  // lexicographic by corresponding values in that same inverse
  // order of their property names. Comparing names by themselves first,
  // all records with the exact same set of property names sort next to
  // each other in a rank-sort of copyRecords.

  // The copyRecord invariants enforced by passStyleOf ensure that
  // all the property names are strings. We need the reverse sorted order
  // of these names, which we then compare lexicographically. This ensures
  // that if the names of record X are a subset of the names of record Y,
  // then record X will have an earlier rank and sort to the left of Y.
  const leftNames = recordNames(left);
  const rightNames = recordNames(right);

  const result = comparator(leftNames, rightNames);
  if (result !== 0) {
    return result;
  }
  const leftValues = recordValues(left, leftNames);
  const rightValues = recordValues(right, rightNames);
  return comparator(leftValues, rightValues);
}
```

Three facts:

1. **Compare names first, then values.** The lexicographic
   comparison runs first over the (sorted) names lists; only if
   the names lists are equal does it descend into the values.
   The effect: records with the same set of property names
   cluster together in a rank-sorted output.

2. **Why *inverse* sorted order?** The trick is that
   `recordNames(record)` returns names in **descending** order
   (later code in this section confirms; the receiver
   reverse-sorts). The lexicographic comparison then says:
   "compare the largest names first; if they match, compare the
   next-largest; etc." The consequence: if record X has a
   *subset* of record Y's names, then at some point in the
   walk X will hit the end of its names list while Y still has
   more names left. The lexicographic rule (array-prefix-ranks-
   earlier) says X comes first. So **records with fewer keys
   rank earlier than supersets of those keys**.

3. **Why this matters for cover queries.** A range query
   like "find all records with at least property `'name'`" can
   be implemented as a cover with low = `{name: ''}` and high =
   `{name: '~'}` or similar — the rank ordering puts every record
   with `'name'` as a property *together*, with the subset
   property gating the cover's range. The subset-ranks-earlier
   rule is the foundation for these queries.

### CopyArray: lexicographic, with prefix-ranking

```js
case 'copyArray': {
  // Lexicographic
  const len = Math.min(left.length, right.length);
  for (let i = 0; i < len; i += 1) {
    const result = comparator(left[i], right[i]);
    if (result !== 0) {
      return result;
    }
  }
  // If all matching elements were tied, then according to their lengths.
  // If array X is a prefix of array Y, then X has an earlier rank than Y.
  return comparator(left.length, right.length);
}
```

The rule: walk both arrays in parallel; the first index where
they differ decides the order. If one runs out before the other
(all corresponding elements were tied), the shorter array ranks
earlier. The closing comment names this property explicitly:
*X-prefix-of-Y means X-ranks-earlier-than-Y*.

The length comparison at the end falls through `comparator` on
two numbers, which is `compareNumerics` (NaN last, +0/-0 tied)
— but lengths are nonnegative integers, so it reduces to a
trivial less-than.

### ByteArray: shortlex

```js
case 'byteArray': {
  // ByteArrays compare by shortlex.
  // - first, if they are of unequal length, then the shorter is less.
  // - then, among byteArrays of equal length, by lexicographic comparison
  //   of their bytes in ascending order.
  const { byteLength: leftLen } = left;
  const { byteLength: rightLen } = right;
  if (leftLen < rightLen) {
    return -1;
  }
  if (leftLen > rightLen) {
    return 1;
  }
  // ... per-byte comparison ...
}
```

*Shortlex* is the comparison "first by length, then
lexicographic". It differs from the `copyArray` rule in that
*length* is the primary key — a longer byte array is always
greater than any shorter byte array, regardless of the leading
bytes. For copyArrays the primary key is element-by-element
content; length only matters when one is a prefix of the other.

The reason byteArrays use shortlex but copyArrays use
content-first lexicographic: byteArrays are typed-buffer payloads
where length carries first-class meaning (e.g., a 16-byte UUID
is structurally distinct from a 20-byte hash), while copyArrays
are structural lists where two arrays of different lengths can
still have meaningful content-by-content comparisons.

### The @endo/immutable-arraybuffer shim workaround

Inside the byteArray case:

```js
// Account for gaps in the @endo/immutable-arraybuffer shim.
const leftArray =
  Object.getPrototypeOf(left) === ArrayBuffer.prototype
    ? new Uint8Array(left)
    : new Uint8Array(left.slice(0));
const rightArray =
  Object.getPrototypeOf(right) === ArrayBuffer.prototype
    ? new Uint8Array(right)
    : new Uint8Array(right.slice(0));
```

The comparison happens via `Uint8Array` views over the
buffers, but the construction depends on whether the buffer is
a native `ArrayBuffer` or an `ImmutableArrayBuffer` from the
shim. A native `ArrayBuffer` can be viewed directly via
`new Uint8Array(buffer)`. The shim's `ImmutableArrayBuffer`,
which `@endo/pass-style` recognizes as a `byteArray` PassStyle,
cannot always be viewed directly (the shim has API gaps that
the workaround names); `slice(0)` copies its bytes to a
plain `ArrayBuffer` first.

The prototype check is the discriminator: if `getPrototypeOf` is
`ArrayBuffer.prototype` exactly, it is the native kind and can
be viewed in place; otherwise it is the shim and needs the
copy.

### Tagged: lexicographic by tag-then-payload

```js
case 'tagged': {
  // Lexicographic by `[Symbol.toStringTag]` then `.payload`.
  const labelComp = comparator(getTag(left), getTag(right));
  if (labelComp !== 0) {
    return labelComp;
  }
  return comparator(left.payload, right.payload);
}
```

Tagged values are `(tag, payload)` pairs where the tag is a
string. Rank-order compares tags first, then payloads. Two
tagged values with different tags never compare equal at the
rank-order level regardless of payload content; two with the
same tag compare by payload.

### compareRemotables default: NaN means deep-tied

The kit-factory signature names a noteworthy property of the
default behavior:

```js
/**
 * @param {PartialCompare} [compareRemotables]
 * A comparator for assigning an internal order to remotables.
 * It defaults to a function that always returns `NaN`, meaning that all
 * remotables are incomparable and should tie for the same rank by
 * short-circuiting without further refinement (e.g., not only are `r1` and `r2`
 * tied, but so are `[r1, 0]` and `[r2, "x"]`).
 * @returns {RankComparatorKit}
 */
export const makeComparatorKit = (compareRemotables = (_x, _y) => NaN) => {
```

The default `compareRemotables` returns `NaN` rather than `0`.
The outer wrapper later coerces `NaN` to `0` for the public-
facing comparator return, but the *short-circuit* happens at the
inner comparator level: when the recursive call on two arrays
hits the first remotable pair, that pair's `NaN` propagates
upward through the `||` in the outer wrapper, terminating the
walk before any later element pair can be examined.

The concrete example the comment names: `[r1, 0]` vs
`[r2, "x"]`. A naive lexicographic comparator would compare
`r1` vs `r2` (tied, since both are remotables), then `0` vs
`"x"` (number sorts before string by PassStyle index, so the
second array ranks higher). With the NaN default, the first
pair returns `NaN`, propagates, and the second array's `0` vs
`"x"` never gets compared. The two arrays are *tied at depth*.

This is the price of the NaN-short-circuit-as-default: it
keeps the public rank order well-defined (no comparator can
produce a contradictory total ordering) at the cost of
declaring more pairs equal than a fully-precise comparator
would.

`makeFullOrderComparatorKit` (covered in a sibling section)
provides the strict alternative when a deeper distinction is
needed.

### How the cross-PassStyle case routes through compareNumerics

```js
if (leftStyle !== rightStyle) {
  return compareNumerics(
    passStyleRanks[leftStyle].index,
    passStyleRanks[rightStyle].index,
  );
}
```

Before the switch fires, mismatched PassStyles get routed
through `compareNumerics` on their integer indexes from
`passStyleRanks`. The integers are nonnegative and finite, so
`compareNumerics` reduces to a trivial less-than (NaN logic
never triggers). The choice of `compareNumerics` rather than a
direct integer-less-than is stylistic consistency: the file's
numeric comparator is the one place numeric comparison
happens.

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/337d16a895066a66e7c92d716449273d337dceb9/packages/marshal/src/rankOrder.js#L157-L330) at commit `337d16a8`.
