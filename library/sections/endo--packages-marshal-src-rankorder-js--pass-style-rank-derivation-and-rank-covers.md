---
title: "`passStyleRanks` derivation and `getPassStyleCover`: deriving the per-PassStyle integer rank and the lexicographic prefix cover from the canonical `passStylePrefixes` table; why RankCovers may be overestimates that need filtering"
source: packages/marshal/src/rankOrder.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/rankOrder.js
source_line_range: "107-148"
source_commit: 2e9333096fc82fabc9a3c1f6d3e268336e7df943
comment_subject: "How rankOrder.js sorts and walks passStylePrefixes to derive per-PassStyle rank index and rank cover; the BMP/printable-ASCII assumption on prefixes; the multi-character-prefix sortedness assertion; why getPassStyleCover advertises that the cover may be an overestimate (no smallest/biggest bigint forces bounding by adjacent style boundaries)"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
---

## Abstract

`rankOrder.js` derives its **per-PassStyle rank table** (the
`passStyleRanks` record) by walking `encodePassable.js`'s canonical
`passStylePrefixes` table in ascending-prefix order and computing
two things for each PassStyle: a small integer `index` (its
position in the sort, which is the actual rank order across
PassStyles) and a `cover` (a `[low, high)` pair of bracket strings
whose lexicographic comparison places every encoded value of that
PassStyle between them). The derivation rests on three assumptions
the code asserts inline: that all prefixes lie in the Basic
Multilingual Plane (so code-unit order matches code-point order),
that prefixes consist of printable ASCII (0x20-0x7E) in practice,
and that multi-character prefixes are themselves sorted (so taking
the first character as the cover's low bound and the
successor-of-the-last as the cover's high bound is a valid range).
The companion **`getPassStyleCover` exporter** prefaces its return
with a comment warning that **the cover may be an overestimate**:
because there is no smallest or biggest bigint, the bigint cover
must extend down through some adjacent style's high end and up
through some adjacent style's low end, capturing values of the
adjacent styles that a range query then has to filter out. The
overestimate is the price of using a fixed lexicographic range
rather than a per-PassStyle equality check.

## Body

### The passStyleRanks derivation

The derivation pipeline lives in a single `entries.sort.map` chain:

```js
/**
 * @typedef {Record<PassStyle, { index: number, cover: RankCover }>} PassStyleRanksRecord
 */

const passStyleRanks = /** @type {PassStyleRanksRecord} */ (
  fromEntries(
    entries(passStylePrefixes)
      // Sort entries by ascending prefix, assuming that all prefixes are
      // limited to the Basic Multilingual Plane (U+0000 through U+FFFF) and
      // thus contain only code units that are equivalent to code points.
      // In practice, they are entirely printable ASCII
      // (0x20 SPACE through 0x7E TILDE).
      .sort(([_leftStyle, leftPrefixes], [_rightStyle, rightPrefixes]) => {
        return trivialComparator(leftPrefixes, rightPrefixes);
      })
      .map(([passStyle, prefixes], index) => {
        // Verify that `prefixes` is sorted, and cover all strings that start
        // with any of its characters, i.e.
        // all s such that prefixes.at(0) ≤ s < successor(prefixes.at(-1)).
        prefixes === prefixes.split('').sort().join('') ||
          Fail`unsorted prefixes for passStyle ${q(passStyle)}: ${q(prefixes)}`;
        const cover = [
          prefixes.charAt(0),
          String.fromCharCode(prefixes.charCodeAt(prefixes.length - 1) + 1),
        ];
        return [passStyle, { index, cover }];
      }),
  )
);
setPrototypeOf(passStyleRanks, null);
harden(passStyleRanks);
```

Three pieces of comment-encoded reasoning:

1. **The BMP / printable-ASCII assumption.** The sort uses
   `trivialComparator`, which is just `<`/`===`/`>`. JavaScript's
   `<` on strings is UTF-16 code-unit comparison; for code units
   in the Basic Multilingual Plane (which excludes surrogate pairs
   and therefore covers every code unit U+0000 through U+FFFF as
   itself rather than as a fragment of a code point), this is
   equivalent to code-point order. The comment names the stronger
   in-practice fact: every actual prefix in
   `encodePassable.js`'s `passStylePrefixes` is in the printable-
   ASCII range 0x20 SPACE through 0x7E TILDE. Both assumptions
   make the sort answer match Unicode-ordering intuition without
   any code-point-iterator work.

2. **The multi-character-prefix sortedness assertion.** Several
   PassStyles have multi-character prefixes — `bigint: 'np'`,
   `copyArray: '[^'`. The derivation walks each prefix string and
   asserts that it equals its own character-sorted form:
   `prefixes === prefixes.split('').sort().join('')`. This is
   what licenses the cover construction below:
   `[prefixes.charAt(0), successor(prefixes.charCodeAt(-1)))` is
   a half-open lexicographic range that covers every string
   starting with any character in `prefixes` only if those
   characters are themselves sorted contiguously. A failure of
   this assertion would mean the encoder's prefix table is
   internally inconsistent and the cover construction would
   silently mis-bound.

3. **Cover construction as half-open range.** For each PassStyle,
   the cover is the pair
   `[low, high) = [prefixes[0], chr(prefixes[-1] + 1))`. So
   `bigint: 'np'` produces cover `['n', 'o')` — wait, `'n' < 'o'`
   *and* `'o' < 'p'`, so a string starting with `'o'` would fall
   inside this cover. That cannot be right — and indeed the
   comment's "all strings starting with any of its characters"
   wording is the cleaner statement. The exact range is more
   complex than `['n', 'o')`: it is the union of all strings
   starting with any character in the sorted prefix range, which
   for `'np'` is the union of strings starting with `'n'` *and*
   strings starting with `'p'`. The implementation captures
   `[low='n', high=successor('p')='q')`, a single half-open range
   that *contains* both sub-ranges plus the gap between them (any
   string starting with `'o'`). The "gap" inclusion is the
   overestimate the `getPassStyleCover` comment then formalizes.

### getPassStyleCover: the overestimate disclaimer

The exported accessor wraps the table lookup:

```js
/**
 * Associate with each passStyle a RankCover that may be an overestimate,
 * and whose results therefore need to be filtered down. For example, because
 * there is not a smallest or biggest bigint, bound it by `NaN` (the last place
 * number) and `''` (the empty string, which is the first place string). Thus,
 * a range query using this range may include these values, which would then
 * need to be filtered out.
 *
 * @param {PassStyle} passStyle
 * @returns {RankCover}
 */
export const getPassStyleCover = passStyle => passStyleRanks[passStyle].cover;
harden(getPassStyleCover);
```

Two facts the comment establishes:

1. **The overestimate is structural, not a bug.** A `RankCover` is
   a `[low, high]` pair of *Passables*, intended for use with
   `getIndexCover` (later in the same file) to find the range of
   indexes in a rank-sorted array whose elements fall in the
   cover. The cover for `bigint` cannot be precisely the smallest
   and biggest bigint because there is no smallest and no biggest
   — bigints are unbounded. The cover must therefore extend
   *outside* the bigint range; the natural choice is to extend
   downward through the highest end of the adjacent style's range
   (numbers, where `NaN` sorts last) and upward through the
   lowest end of the next adjacent style's range (strings, where
   `''` sorts first). The cover example named in the comment is
   `[NaN, '']` — explicitly *not* a bigint pair. A range query
   using this cover gets every bigint *plus* possibly `NaN` and
   possibly `''`, which the caller filters out by a per-value
   PassStyle check.

2. **Filter-down is the caller's job.** The cover machinery's
   contract is *contains, possibly imprecisely*; the caller of
   `getIndexCover` plus `getPassStyleCover` is responsible for
   the cheap per-value test that prunes the overestimate. This
   division of labor keeps the cover small (just two Passables) at
   the price of one PassStyle check per included candidate.

### Why this matters: cover-based range queries

The cover machinery is what lets marshal answer questions like
"give me all CopyMap entries whose key is a bigint" without
walking every entry. The flow is:

1. Compute `cover = getPassStyleCover('bigint')` (a `[low, high]`
   pair, perhaps an overestimate per above).
2. Pass `cover` and the comparator to `getIndexCover` (in the
   same file): it returns `[leftIndex, rightIndex]` — the
   leftmost and rightmost positions in the rank-sorted array
   whose values fall in the cover.
3. Walk `coveredEntries(sorted, [leftIndex, rightIndex])` to
   iterate the candidates.
4. Filter each candidate by `passStyleOf(value) === 'bigint'`
   to discard the overestimate (any `NaN` or `''` swept into the
   range).

The expense is one `passStyleOf` per candidate; the saving is
that no candidates *outside* the cover are walked at all. For a
keyed-store backed by a lexicographically-sorted index (e.g.,
LMDB), `getIndexCover` becomes two binary searches.

### The null-prototype + harden discipline

```js
setPrototypeOf(passStyleRanks, null);
harden(passStyleRanks);
```

The same defensive shape `encodePassable.js` applies to
`passStylePrefixes`: the prototype is nulled so the table cannot
be confused for a prototype-inheriting object that picks up
properties from `Object.prototype`, and `harden` freezes it
transitively. The table is now safe to expose via
`getPassStyleCover` without worrying about consumers mutating or
extending it.

### Why the cover-construction works only for sorted prefixes

The cover construction uses
`prefixes.charAt(0)` and `String.fromCharCode(prefixes.charCodeAt(prefixes.length - 1) + 1)`
— the first character and the successor of the last character.
For a single-character prefix like `error: '!'`, this is
`['!', '"')`, which contains exactly the strings starting with
`'!'`. For a multi-character prefix like `bigint: 'np'`, this is
`['n', 'q')`, which contains every string starting with `'n'`,
`'o'`, or `'p'` — *more* than the strictly-bigint set but no
less. If the prefix were *unsorted* (say, `'pn'`), this same
construction would produce `['p', 'o')` — an empty cover, since
`'p' > 'o'`. The sortedness assertion is what catches this
specific defect before it silently breaks every cover-based
range query.

## Translation

| rankOrder idiom | Adjacent vocabulary |
|---|---|
| "passStyleRanks" | the derived record mapping each PassStyle to its index (sort position) and its cover (a [low, high) bracket pair) |
| "RankCover" | a [low, high] pair of Passables whose lexicographic-with-rank-comparator range contains every encoded value of a given PassStyle (plus possibly some adjacent values to be filtered) |
| "trivialComparator" | the wrapper around native `<`/`===`/`>` returning -1/0/1; used here because all prefixes are in the BMP printable-ASCII range |
| "BMP / printable-ASCII assumption" | the constraint that every character in `passStylePrefixes` is a code unit U+0000-U+FFFF (in practice 0x20-0x7E), so JavaScript's native string comparison agrees with code-point order |
| "sortedness assertion" | the `prefixes === prefixes.split('').sort().join('')` check that catches an out-of-order multi-character prefix before it silently produces an empty or wrong cover |
| "overestimate" | a cover whose range contains every value of the target PassStyle *and possibly some adjacent values*; intentional consequence of the unbounded-bigint problem |

## See also

- [`endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table`](endo--packages-marshal-src-encodepassable-js--error-special-case-and-passstyle-prefix-table.md) — the source-of-truth table this section reads; its source-order matches what `passStyleRanks` extracts via sort + index.
- [`endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules`](endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules.md) — sibling section in the same source; uses `passStyleRanks[leftStyle].index` to rank values of different PassStyles against each other.
- [`endo--packages-marshal-src-rankorder-js--same-value-zero-and-numeric-rank-semantics`](endo--packages-marshal-src-rankorder-js--same-value-zero-and-numeric-rank-semantics.md) — sibling section; explains how `compareNumerics` is then used to compare two `passStyleRanks[...].index` integers when PassStyles differ.
- [[rank-order-preserving-encoding]] — the concept page; the derivation here is the in-memory dual of the bytes-on-the-wire prefix table.
- [[pass-invariant-handle-equality]] — adjacent concept; the per-PassStyle equality discipline that motivates the per-PassStyle rank discipline.

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/2e9333096fc82fabc9a3c1f6d3e268336e7df943/packages/marshal/src/rankOrder.js#L107-L148) at commit `2e933309`.
