---
title: How do I enumerate thee, let me list the ways
source: packages/pass-style/doc/copyArray-guarantees.md
source_repo: endojs/endo
source_commit: be51fb10b6f4
source_date: 2023-11-30
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [pass-style, marshal]
status: current
parent: endo--pkg-pass-style-doc-copyarray-guarantees--overview
---

Why these properties restrictions?
JavaScript has a [tremendous number of different constructs for enumerating the
properties](enumerating-properties.md) of an object, with different semantics
of what subset they choose to enumerate.
Once an object passes `assertCopyArray(arr)`, all of these are guaranteed to
agree except for `length`.
Since an array's `length` property is a non-enumerable string-named property,
`Reflect.ownKeys`, `Object.getOwnPropertyNames`,
`Object.getOwnPropertyDescriptors` will see the `length` property. The others
will not.

Source: [packages/pass-style/doc/copyArray-guarantees.md](https://github.com/endojs/endo/blob/be51fb10b6f4/packages/pass-style/doc/copyArray-guarantees.md) at commit `be51fb10`.
