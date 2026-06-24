---
title: Body
source: packages/marshal/src/encodeToSmallcaps.js
source_kind: comment-fragment
source_repo: endojs/endo
source_path: packages/marshal/src/encodeToSmallcaps.js
source_line_range: "138-187"
source_commit: e56bf00f289ff8484094b785b11636b8bc71d87e
comment_subject: "Why encodeToSmallcaps must produce a canonical JSON encoding (equal passables must JSON.stringify-equal), the copyRecord key-sort that achieves it, and the canonical-JSON aspiration the current implementation falls short of"
ingested: 2026-05-15
ingested_by: scholar
topics: [marshal, pass-style]
status: current
parent: endo--packages-marshal-src-encodetosmallcaps-js--canonical-encoding-invariants
---

### The invariant

The comment opens with the contract:

> Must encode `val` into plain JSON data *canonically*, such that
> `JSON.stringify(encode(v1)) === JSON.stringify(encode(v1))`.

(The duplication of `v1` is a typo in the comment; the intent is
`encode(v1)` equals `encode(v2)` whenever the distributed-object
semantics considers `v1` and `v2` equal.)

The *why* of canonicity is named explicitly later:

> Readers must not care about this order anyway. We impose this
> requirement mainly to reduce non-determinism exposed outside a
> vat.

The motivation is **outside the vat**, not inside. A vat that
exposes its serialized state to an outside observer (a peer, a
hash, a checkpoint, a snapshot diff) leaks information through
encoding order if the encoding is not canonical. Canonical
encoding closes the leak.

### Two sources of non-determinism

The comment names two cases the encoder treats differently:

#### Case A: copyRecord enumeration order

JavaScript guarantees that `Object.keys` (and `for...in` over own
string keys) walks integer-named properties in numeric order,
then string-named properties in insertion order. Two
`copyRecord` objects can carry the same string keys with the same
values but in different insertion orders. The
distributed-object semantics declares them equal; native JS
enumeration order does not.

The encoder's response:

```js
case 'copyRecord': {
  const names = ownKeys(passable).sort();
  return fromEntries(
    names.map(name => [
      encodeToSmallcapsRecur(name),
      encodeToSmallcapsRecur(passable[name]),
    ]),
  );
}
```

Three details matter:

1. `ownKeys` is `Reflect.ownKeys`. copyRecord forbids symbol-keyed
   own properties (`packages/pass-style/doc/copyRecord-guarantees.md`),
   so `ownKeys` returns only string keys. If sortable symbol keys
   were ever allowed, the comment flags, the sort would need to
   become "more interesting" — symbol descriptions are not
   strictly orderable.
2. The sort is *before* recursion. Each key's own value is
   recursively encoded, but the order in which siblings appear in
   the resulting object literal is determined by the sorted name
   array.
3. The `fromEntries` returns an object literal whose own-property
   insertion order matches the array iteration order, which
   matches the sort order. `JSON.stringify` then walks own-string
   properties in insertion order, so the wire bytes carry the
   sort order outward.

The string-key-sort is byte-string lexicographic. After
encoding, a property name that starts with a reserved sigil (e.g.
`"#foo"`) is escaped to `"!#foo"` by the
[special-character-prefix-scheme](endo--packages-marshal-src-encodetosmallcaps-js--special-character-prefix-scheme.md)'s
Hilbert-hotel quoting. The contiguous reserved-character range
makes the escape *sort-order-preserving*: `"#foo"` sorts where
`"!#foo"` sorts because `!` is the lowest sigil and the quoted
form's first char is one position higher than the original. This
is why the prefix scheme picks a contiguous range; a non-contiguous
sigil set would break canonical sort order across encoded keys.

#### Case B: non-copyRecord node visitation order

```
For most encodings, the order of properties of each node of the
output structure is determined by the algorithm below without
special arrangement, usually by being expressed directly as an
object literal.
```

The encoder builds tagged-record encodings, error encodings, and
the other shaped objects via JS object literals like
`{'#tag': ..., payload: ...}` and `{'#error': ..., name: ...}`.
JS object-literal order is source-text order; the
`JSON.stringify` walk preserves it. So the wire bytes for a
tagged record always have `#tag` before `payload`, and the wire
bytes for an error always have `#error` before `name`.

This *agrees* with canonical-JSON for copyRecord property names
(both produce sorted output), but it diverges from
canonical-JSON for tagged-record and error encodings, which
canonical-JSON would also sort. The comment flags the divergence:

> Note that the actual order produced here, though it agrees
> with canonical-JSON on copyRecord property ordering, differs
> from canonical-JSON as a whole in that the other record
> properties are visited in the order in which they are
> literally written below. TODO perhaps we should indeed switch
> to a canonical JSON encoder, and not delicately depend on the
> order in which these object literals are written.

The current encoding is canonical *because the encoder source
text fixes the order at every literal*, not because the encoding
follows a canonical-JSON discipline. A future canonical-JSON
encoder would close the modularity gap.

### Why readers must not depend on order

The comment makes the strong claim:

> Readers must not care about this order anyway. We impose this
> requirement mainly to reduce non-determinism exposed outside a
> vat.

The reader-side discipline is part of the marshal contract: a
decoder that reads `{"#tag": t, "payload": p}` must not assume
the order, because a hostile peer or a non-canonical re-encoding
might present the object with the properties in a different
order, and the decoder must still decode it correctly. The
canonicalness on the encode side is for the *hash-stability* and
*snapshot-diff* use cases, not for reader convenience.

This is consistent with the broader marshal validation discipline:
the decoder must validate every structure it reads from JSON.parse
output, because the input is not guaranteed to come from a
smallcaps encoder (`decodeFromSmallcaps` cannot trust input is
from `encodeToSmallcaps` per its own JSDoc).

### What canonical encoding is *not* doing

It is not:

- **Defending against hash-collision attacks.** The canonicality
  reduces accidental non-determinism, not adversarial
  manipulation. A peer that wants to produce two byte-different
  encodings of two semantically-equal values can do so by feeding
  the decoder, not the encoder.
- **Providing a sort-stable identity.** Two values are equal if
  they pass `keyEQ` (pass-style level), which is a *deeper*
  predicate than byte-equal smallcaps. Two semantically-equal
  values produce byte-equal smallcaps; the converse is not the
  same as `keyEQ`.
- **A wire-compatibility guarantee.** Two implementations of
  smallcaps that both follow the spec can produce byte-different
  encodings of the same value if they disagree on a corner case
  the spec under-specifies. The marshal package's tests fix the
  specific output bytes for the JS implementation; another
  implementation (a hypothetical Rust smallcaps) would need to
  follow the same convention.

### Implications for upstream proposals

A few near-future proposals would interact with this invariant:

- **Symbol keys in copyRecord.** The comment flags this case: if
  the pass-style relaxes to permit sortable symbol keys, the sort
  would need a custom comparator. Symbol descriptions are
  ordinary strings, so the natural extension is to sort the
  symbols by their description after sorting the string keys. The
  serialization of the symbol key would still go through the
  encoder's `%` sigil; the sort happens on the *description text*,
  not on the encoded form.
- **ByteArray pass style.** The byteArray case currently throws
  ("not yet implemented"), so the canonicality question is open
  for byte-array values. The encoded form will need to be
  determined.
- **Canonical-JSON encoder migration.** The TODO sits as a refactor
  opportunity. Switching to canonical-JSON would let the encoder
  drop the "object literal source order" load-bearing convention,
  making the encoder source easier to refactor without breaking
  canonicality. The cost is the canonical-JSON encoder dependency
  itself.

Source: [packages/marshal/src/encodeToSmallcaps.js](https://github.com/endojs/endo/blob/e56bf00f289ff8484094b785b11636b8bc71d87e/packages/marshal/src/encodeToSmallcaps.js#L138-L187) at commit `e56bf00f`.
