---
title: As a direct alternative to JSON
source: packages/marshal/README.md
source_repo: endojs/endo
source_commit: 70bcca3d4ba93e92221a9188f583126ca84e4e4d
source_date: 2024-02-05
source_authors: [Richard Gibson, Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [marshal, pass-style]
status: current
---

> Abstract: Marshal can be used as a direct JSON replacement when capability values are not in play: it handles BigInt, NaN, Infinity, undefined, errors, and other types JSON cannot, with deterministic encoding. Useful for serializing arbitrary frozen JS values to a stable wire format even outside the capability-bearing context.

# As a direct alternative to JSON

This marshal package also exports `stringify` and `parse` functions that are
built on the marshal encoding of passable data. They can serve as direct
substitutes for `JSON.stringify` and `JSON.parse`, respectively, with the
following differences:

* Compared to JSON, marshal's `stringify` is both more tolerant and less tolerant
  of what data it accepts. It is more tolerant in that it will encode `NaN`,
  `Infinity`, `-Infinity`, bigints, and `undefined`. It is less tolerant in that
  it accepts only pass-by-copy data according to the semantics of our distributed
  object model, as enforced by marshal---the `Passable` type exported by the
  marshal package. For example, all objects-as-records must be frozen, inherit
  from `Object.prototype`, and have only enumerable string-named data properties.
  `JSON.stringify` handles unserializable data by skipping it, but marshal's
  `stringify` rejects it by throwing an error.
* The JSON functions have parameters for customizing serialization and
  deserialization, for example with a *replacer* or *reviver*. The marshal-based
  alternatives do not.

The full marshal package will serialize `Passable` objects containing
presences and promises, because it serializes to a `CapData` structure
containing both a `body` string and a `slots` array. Marshal's `stringify`
function serializes only to a string, and so will not
accept any remotables or promises. If any are found in the input, this
`stringify` will throw an error.

Any encoding into JSON of data that cannot be represented directly, such as
`NaN`, relies on some kind of escape for the decoding side to detect and use.
For `stringify` and `parse`, this is signaled by an object with a property named
`@qclass` per the original encoding described [above](#beyond-json).

Source: [packages/marshal/README.md](https://github.com/endojs/endo/blob/70bcca3d4ba93e92221a9188f583126ca84e4e4d/packages/marshal/README.md) at commit `70bcca3d`.
