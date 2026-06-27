---
id: passable-equality
aliases: ["passable equality", "pass-invariant equality", "passable equivalence", "keyEQ", "`keyEQ`", "key equality", "structural equality of keys", "compareKeys equality", "distributed equality", "distributed equality semantics", "isKey", "`isKey`", "keyLT", "keyLTE", "keyGTE", "keyGT", "key order vs rank order", "partial order of keys", "incommensurate keys", "CopyRecord equality", "CopyArray equality", "CopyMap equality", "CopySet equality", "CopyBag equality", "sameValueZero key equality", "kindOf equivalence", "marshal equality invariant", "equality preserved across serialization"]
topics: [patterns, marshal, pass-style]
---

# passable-equality

The marshalling-family convention that **two Passables that are
structurally equal compare equal, and stay equal across the wire**.
At the application (`kindOf`) level the equality predicate is
`keyEQ(k1, k2)` from `@endo/patterns`, defined as
`compareKeys(k1, k2) === 0`. Equality is recursive: atomic leaves
compare by `sameValueZero` semantics (`NaN` equals itself, `-0`
equals `+0`), and `CopyArray` / `CopyRecord` / `CopySet` / `CopyBag`
/ `CopyMap` compare by structural recursion over their contents,
with remotables compared by identity only. Because the equal-bytes
encoders (`encodePassable` for rank-order keys, `encodeToSmallcaps`
for the JSON-shape wire) are canonical, two keys that are `keyEQ`
serialize to identical bytes and round-trip back to a `keyEQ`-equal
key — so an agent receiving a value can decide whether it is "the
same" as one it already holds without trusting the sender to be
consistent. This is the value-level, structural counterpart of
[[pass-invariant-handle-equality]] (the identity-level guarantee on
Handles) and the database-key-shaped form of
[[rank-order-preserving-encoding]].

## The three abstraction levels

`@endo/patterns`'s own `marshal-vs-patterns-level.md` lays out where
equivalence lives:

| Level | Classification | Equivalence | Ordering |
|---|---|---|---|
| `kindOf` (application) | `kindOf(p)`, `M.key()` | `keyEQ(k1, k2)` | `compareKeys(k1, k2)`, `M.gte(k)` |
| `passStyleOf` (transport) | `passStyleOf(p)` | *(none)* | `compareRank(p1, p2)` |
| JavaScript | `typeof j` | `j1 === j2`, `Object.is`, `sameValueZero` | `j1 <= j2` |

The middle (`passStyleOf`) row has **no equivalence cell**: the
transport level classifies and rank-orders Passables but does not
define value equality — equality is a `kindOf`-level notion that
only applies to **Keys** (the subset of Passables that have a
defined total position). `isKey` (from `checkKey.js`) gates that
domain: errors, promises, and non-frozen objects are Passables but
not Keys, so `keyEQ` is undefined on them.

## Key order is a partial order, and refines rank order

`compareKeys` returns `NaN` for **incommensurate** pairs — two keys
that neither precede, follow, nor equal each other (a `CopyRecord`
missing a property the other has, a pair of distinct remotables, a
`NaN` against a non-`NaN` number). So keys form a **partial order**,
not the total order the patterns README loosely calls it. The five
wrapper predicates `keyLT` / `keyLTE` / `keyEQ` / `keyGTE` / `keyGT`
all return `false` on an incommensurate pair (partial-order-aware
semantics), so `keyEQ` is `false` whenever the two keys cannot be
compared at all.

Rank order (`compareRank`, the `passStyleOf`-level total order used
for storage and sort) is the **total-order completion** of key
order: the invariant `compareKeys(X, Y) < 0 ⟹ compareRank(X, Y) < 0`
holds, so rank order is consistent with key order and fills in a
verdict for the pairs key order leaves incommensurate (by first-seen
position and other tiebreakers). `keyEQ` therefore implies rank-equal,
but not conversely — two distinct remotables can be rank-tied yet
key-incommensurate. This is the central distinction between this
concept and [[rank-order-preserving-encoding]].

## How sameValueZero composes up to structural equality

`compareKeys` dispatches on `passStyleOf`:

- **Atoms** (`undefined`, `null`, `boolean`, `bigint`, `string`,
  `symbol`, `number`) reuse `compareRank`, whose rank-tie predicate
  is `sameValueZero` — so atom-level `keyEQ` is exactly
  `sameValueZero` (`NaN` equals `NaN`, `-0` equals `+0`), not `===`.
- **Remotables** compare by identity only; two non-identical
  remotables are incommensurate.
- **CopyArray** compares lexicographically (prefix-shorter-is-smaller).
- **CopyRecord** uses a *Pareto partial order*: the two records must
  have the same property set, and the element-wise comparisons must
  all go the same direction or be equal, else `NaN`.
- **Tagged** collections dispatch into `setCompare` / `bagCompare`
  (built on `makeCompareCollection`); `CopyMap` comparison is still
  unimplemented and throws, with a `TODO` naming the endojs/endo#1737
  review thread.

Structural equality rests on the **canonical internal form** of the
copy collections: `CopySet` and `CopyBag` store their elements
rank-sorted, so two equal collections have byte-identical internal
form, and equality reduces to a positional walk. That canonical form
is also what makes the encoders deterministic, which is what carries
equality across serialization.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [marshal-vs-patterns-level / overview](../sections/endo--pkg-patterns-docs-marshal-vs-patterns-level--overview.md) | The three-level (`kindOf` / `passStyleOf` / JavaScript) table placing `keyEQ` at the application level, `sameValueZero` / `===` / `Object.is` at the JavaScript level, and *no* equivalence operation at the transport level. |
| [compareKeys.js / passStyle-dispatched comparison](../sections/endo--packages-patterns-src-keys-compareKeys-js--passstyle-dispatched-key-comparison-with-pareto-partial-order.md) | `keyEQ` defined as `compareKeys === 0`; the partial-order-with-`NaN` design; per-passStyle dispatch (atoms reuse rank, remotables identity-only, copyRecord Pareto); the key-order-refines-rank-order invariant; the five-predicate wrapper suite. |
| [checkKey.js / keys foundation](../sections/endo--packages-patterns-src-keys-checkKey-js--keys-foundation-confirm-is-assert-trio-and-recursion.md) | `isKey` and the Confirm/Is/Assert trio that defines *which* Passables are Keys (the domain on which equality is defined); recursion-on-passStyle with the unexpected-passStyle-throws discipline. |
| [checkKey.js / copy-collection extensions](../sections/endo--packages-patterns-src-keys-checkKey-js--copyset-copybag-copymap-extensions-and-special-case-algorithms.md) | The structural validation and canonical-internal-form construction for `CopySet` / `CopyBag` / `CopyMap` that structural equality recurses over. |
| [patterns README / key comparison](../sections/endo--pkg-patterns-readme--key-comparison.md) | The package-surface framing of `keyEQ` and `compareKeys`, "distributed equality semantics," and the key/pattern/passable hierarchy; note its "total order" wording is the loose framing the implementation refines to a partial order. |
| [keycollection-operators.js / Pareto pair-entries merge](../sections/endo--packages-patterns-src-keys-keycollection-operators-js--pareto-pair-entries-merging-with-anti-rank-tie-breaking-for-collection-comparison.md) | `makeCompareCollection`, the Pareto-partial-order algorithm that `setCompare` and `bagCompare` use to compare (and so equate) `CopySet` and `CopyBag` values. |
| [copySet.js / canonical internal form](../sections/endo--packages-patterns-src-keys-copyset-js--element-validation-and-canonical-internal-form.md) | The rank-sorted canonical internal form of `CopySet` that makes two equal sets byte-identical and equality a positional walk. |
| [copyBag.js / entry validation](../sections/endo--packages-patterns-src-keys-copybag-js--bag-entry-validation-with-per-entry-shape-and-positive-count.md) | The `[key, positive-count]` canonical form of `CopyBag` underlying multiplicity-aware equality. |
| [rankOrder.js / sameValueZero and numeric rank](../sections/endo--packages-marshal-src-rankorder-js--same-value-zero-and-numeric-rank-semantics.md) | `sameValueZero` as the rank-tie predicate (`NaN === NaN`, `-0 === +0`) that atom-level `keyEQ` inherits, and the `compareNumerics` placement of `NaN`. |
| [rankOrder.js / per-passStyle rules](../sections/endo--packages-marshal-src-rankorder-js--inner-comparator-per-pass-style-rules.md) | The per-passStyle rank rules `compareKeys` reuses for atoms, and the deep-tied-remotable case that is rank-equal yet key-incommensurate. |

## See also

- [[pass-invariant-handle-equality]] — the identity-level instance of this concept: a connector guarantees that two `handleFor(X)` calls for the same backing identity return the same *formula identifier*. This page is the value-level, structural counterpart for ordinary Keys.
- [[rank-order-preserving-encoding]] — the marshal-side coordinated encoder (`encodePassable`) and comparator (`rankOrder.js`). Equal keys encode to identical order-preserving bytes; key order refines rank order. The total-order completion of the partial order this page covers.
- [[smallcaps-encoding]] — the JSON-shape wire encoder (`encodeToSmallcaps`). Its canonical encoding (sorted record keys, escaped-string Hilbert hotel) is what makes `keyEQ`-equal keys serialize identically and round-trip back equal.
- [[grant-matcher-puzzle]] — the motivating puzzle (not yet ingested): a holder must recognize when the *same* key arrives from two mutually distrusting sources. Pass-invariant passable equality is the mechanism that makes that recognition trustworthy without trusting either sender.
- [[shape-not-content]] — equality is defined on the structural *shape* of a Passable, not on incidental JavaScript identity; non-Key shapes (errors, promises) have no equality at all.

## Common confusions

- **passable-equality (key order) is not rank order.** Key order is a
  *partial* order returning `NaN` for incommensurate pairs; rank order
  is the *total* order used for storage, sort, and the keyed-store byte
  encoding. `keyEQ` implies rank-equal, but two distinct remotables can
  be rank-tied yet key-incommensurate. See [[rank-order-preserving-encoding]].
- **passable-equality is not pass-invariant-handle-equality.** `keyEQ`
  is the general *structural* (value-level) predicate over Keys;
  [[pass-invariant-handle-equality]] is the *identity-level* guarantee
  that a Handle vended for the same backing identity carries the same
  formula identifier.
- **Not every Passable is a Key.** Errors, promises, and non-frozen
  objects are Passables but not Keys, so `keyEQ` and `compareKeys` are
  undefined on them; `isKey` gates the domain.
- **`keyEQ` is not `===`.** On atomic leaves `keyEQ` uses
  `sameValueZero` (`NaN` equals `NaN`, `-0` equals `+0`), which differs
  from `===` on those two cases and from `Object.is` on `-0`/`+0`.

## Provenance note

Concept page added 2026-06-27 by the `scholar-ingest-passable-equality`
job. It is a synthesis page: every claim is grounded in already-ingested
sections (the `@endo/patterns` keys cluster — `compareKeys.js`,
`checkKey.js`, `copySet.js`, `copyBag.js`, `keycollection-operators.js`,
the patterns README, and `marshal-vs-patterns-level.md` — plus the
`@endo/marshal` `rankOrder.js` sections). No new source files were
ingested; the idempotency check found `compareKeys.js` and `checkKey.js`
current at their recorded commits. It broadens the Handle-side framing of
[[pass-invariant-handle-equality]] to the general marshalling-level
equality invariant the job requested.
</content>
</invoke>
