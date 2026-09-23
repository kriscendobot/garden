---
title: Body
source: packages/marshal/src/rankOrder.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/rankOrder.js
source_line_range: "19-22, 33-46, 95-115, 218-237"
source_commit: 337d16a895066a66e7c92d716449273d337dceb9
comment_subject: "Why marshal's rank-order equality is sameValueZero (Map/Set's equality, with NaN equal to NaN and -0 equal to 0); why compareNumerics places NaN last and self-equal; why -0 collapses to 0 in marshal's distributed semantics; why the ENDO_RANK_STRINGS environment option exists (utf16-code-unit-order vs unicode-code-point-order vs error-if-order-choice-matters)"
ingested: 2026-05-29
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-rankorder-js--same-value-zero-and-numeric-rank-semantics
---

### sameValueZero: rank-equality matches Map/Set equality

The first multi-paragraph comment in the file establishes the
equality predicate used to decide rank ties:

```js
/**
 * This is the equality comparison used by JavaScript's Map and Set
 * abstractions, where NaN is the same as NaN and -0 is the same as
 * 0. Marshal still serializes -0 as zero, so the semantics of our distributed
 * object system does not yet distinguish 0 from -0.
 *
 * `sameValueZero` is the EcmaScript spec name for this equality comparison,
 * but TODO we need a better name for the API.
 *
 * @param {any} x
 * @param {any} y
 * @returns {boolean}
 */
const sameValueZero = (x, y) => x === y || is(x, y);
```

Three facts the comment establishes:

1. **Choice of equality**: marshal uses `Map`/`Set`'s equality
   (`SameValueZero`), not `===` (which says `NaN !== NaN`) and not
   `Object.is` (which says `Object.is(-0, +0) === false`).
   `sameValueZero(NaN, NaN)` is `true`; `sameValueZero(-0, +0)` is
   `true`. The implementation is one line: try `===` first (handles
   everything except `NaN`), fall back to `Object.is` (handles
   `NaN`).
2. **Wire-equality alignment**: marshal's serializer encodes `-0` as
   `0`, so two values that compare equal under `sameValueZero` also
   produce byte-equal wire representations. The rank-equality
   predicate is the in-memory dual of the wire-equality property.
   The "does not *yet* distinguish 0 from -0" wording is a
   distinguishing-them-later hedge; current semantics collapse.
3. **API-naming TODO**: the spec name `sameValueZero` is a
   not-quite-English compound; the comment explicitly flags this as
   a TODO for a better public name. This is a *naming-debt
   acknowledgment*, not a defect — but a future reader looking for
   the public-facing predicate in the marshal API will find it
   spelled this way.

### compareNumerics: NaN last and self-equal, +0/-0 tied

The numeric comparator implements the per-style rank rule for
both `number` and `bigint`:

```js
/**
 * Compare two same-type numeric values, returning results consistent with
 * `compareRank`'s "rank order" (i.e., treating both positive and negative zero
 * as equal and placing NaN as self-equal after all other numbers).
 *
 * @template {number | bigint} T
 * @param {T} left
 * @param {T} right
 * @returns {RankComparison}
 */
export const compareNumerics = (left, right) => {
  // eslint-disable-next-line @endo/restrict-comparison-operands
  if (left < right) return -1;
  // eslint-disable-next-line @endo/restrict-comparison-operands
  if (left > right) return 1;
  if (NumberIsNaN(left) === NumberIsNaN(right)) return 0;
  if (NumberIsNaN(right)) return -1;
  assert(NumberIsNaN(left));
  return 1;
};
```

Three facts:

1. **NaN placement is `after` every other number**: by the standard
   IEEE-754 semantics of `<` and `>`, every comparison against `NaN`
   returns `false`. So after the first two `if`s, two equal numbers
   *or* one-or-both being `NaN` fall through. The third `if`
   collapses the both-`NaN` case to tied (returning 0); the fourth
   handles right-is-`NaN` (left is less, so left precedes); the
   final `assert(NumberIsNaN(left))` enforces by precondition that
   the only remaining case is left-is-`NaN` (left is greater, so
   left follows). The net effect: in a rank-sorted array, all
   `NaN`s sort to the *end*, all tied with each other.
2. **+0/-0 tied via `<`/`>`**: under both `<` and `>`, `+0` and
   `-0` compare equal (both operators return `false`), so they
   fall through the first two `if`s and land in the
   `NumberIsNaN(left) === NumberIsNaN(right)` branch, both false-
   equal-to-false, returning 0 (tied). The behavior matches
   `sameValueZero`'s wire-alignment.
3. **Polymorphism over `number` and `bigint`**: the function's
   template parameter `T extends number | bigint` lets it serve
   both PassStyles. `bigint` does not have a `NaN` value, so the
   `NumberIsNaN` checks degenerate (always false) and the function
   reduces to a trivial less-than comparator on `bigint` inputs.
   The `@endo/restrict-comparison-operands` eslint rule, normally
   disallowing `<`/`>` on non-numeric values, is disabled here
   because the template guarantees numeric operands.

### ENDO_RANK_STRINGS: three string-comparison modes

The file declares an environment option at the top:

```js
const ENDO_RANK_STRINGS = getenv('ENDO_RANK_STRINGS', 'utf16-code-unit-order', [
  'unicode-code-point-order',
  'error-if-order-choice-matters',
]);
```

And dispatches on it inside the per-style comparator:

```js
case 'string': {
  switch (ENDO_RANK_STRINGS) {
    case 'utf16-code-unit-order': {
      return trivialComparator(left, right);
    }
    case 'unicode-code-point-order': {
      return compareByCodePoints(left, right);
    }
    case 'error-if-order-choice-matters': {
      const result1 = trivialComparator(left, right);
      const result2 = compareByCodePoints(left, right);
      result1 === result2 ||
        Fail`Comparisons differed: ${left} vs ${right}, ${q(result1)} vs ${q(result2)}`;
      return result1;
    }
    default: {
      throw Fail`Unexpected ENDO_RANK_STRINGS ${q(ENDO_RANK_STRINGS)}`;
    }
  }
}
```

The three modes and what they buy:

1. **`utf16-code-unit-order` (default)**: uses JavaScript's `<`/`>`
   operators (`trivialComparator`), which compare strings by UTF-16
   *code unit* order. This is the legacy behavior, the most
   efficient, and is what stored rank-sorted databases already
   contain. Surrogate pairs (code points above U+FFFF) are
   compared as their UTF-16 high-surrogate code unit, which is in
   the range U+D800-U+DBFF — placing them numerically *between*
   the BMP's U+D7FF and U+E000. The sort thus interleaves
   above-BMP characters into the middle of the BMP rather than
   placing them at the end where their code points actually fall.
2. **`unicode-code-point-order`**: walks both strings as code-point
   iterators (`for-of` semantics, which decodes surrogate pairs)
   and compares code-point by code-point. Above-BMP characters
   correctly sort *after* every BMP character. This is the more
   linguistically-correct order but breaks compatibility with any
   stored database whose sort order was determined under the
   default mode.
3. **`error-if-order-choice-matters`**: runs both comparators and
   asserts they agree. Useful as a development-time canary for
   data that does not contain above-BMP characters: if the two
   modes disagree, the assertion fires with both verdicts in the
   message. This lets a migration plan exercise tests under the
   diagnostic mode before switching production to
   `unicode-code-point-order`.

The choice of UTF-16 code-unit order as the default is the
backward-compatible one. The `compareByCodePoints` function uses
`Symbol.iterator` to step through actual code points, handling
surrogate pairs correctly; the `trivialComparator` uses native
operators that step through code units. For BMP-only strings the
two modes produce identical results; for any string with
above-BMP characters they diverge.

### Why this matters for marshal users

A consumer of marshal who only uses ASCII strings and integers
need not think about any of this — `sameValueZero` becomes `===`,
`compareNumerics` becomes a trivial less-than, and the string
mode does not matter. The complexity exists for the corner cases:

- **Stored keys**: a CopyMap or CopyBag persisted to disk relies
  on the order being stable across runs of the program. The
  `ENDO_RANK_STRINGS` default is the production setting precisely
  because changing it would silently re-order keys in stored
  databases.
- **NaN/0 round-tripping**: an application that uses `NaN` as a
  sentinel and stores it in a CopyMap will find its NaN entries
  clustered together at the end of the sorted key space —
  predictable, but not what naive intuition expects.
- **Surrogate-pair migration**: switching to
  `unicode-code-point-order` is a one-way migration that requires
  rewriting all existing rank-sorted databases. The diagnostic
  mode is the recommended bridge: assert agreement until the
  application's data has no above-BMP keys (or has only above-BMP
  keys in safe positions).

Source: [packages/marshal/src/rankOrder.js](https://github.com/endojs/endo/blob/337d16a895066a66e7c92d716449273d337dceb9/packages/marshal/src/rankOrder.js#L19-L237) at commit `337d16a8`.
