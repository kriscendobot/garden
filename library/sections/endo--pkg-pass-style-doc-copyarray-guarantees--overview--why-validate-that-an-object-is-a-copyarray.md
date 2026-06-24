---
title: Why validate that an object is a CopyArray?
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

The input validation check `assertCopyArray(arr)` asserts that `passStyleOf(arr) === 'copyArray'`. Done early enough, it protects against many dangers. After this test passes, we are guaranteed that `arr` is
   * an object for which `Array.isArray(arr) === true`, and therefore considered to be a JavaScript array. (Note though that, currently, it may be a proxy for an array. See below.)
   * an object that inherits directly from `Array.prototype`,
      * Since SES has already hardened `Array.prototype`, this guarantees that `arr` inherits nothing enumerable or otherwise surprising.
   * frozen, and therefore
      * all its own properties are non-configurable, and if data properties, non-writable.
      * it will never have more or fewer own properties than it has now.
      * it will never inherit from anything different than what it inherits from now (`Array.prototype`).
   * has a `length` property which is a *non-enumerable* own data property whose value is a number representing a non-negative integer. This invariant probably follows from `Array.isArray(arr)` anyway.
   * aside from `length`, has only own-properties which are
      * number-named (rather than symbol named) for the non-negative integers between `0` and `length - 1`. It has all of these, i.e., it has no holes. It has no own properties besides these and `length`.
      * enumerable,
      * data properties, rather than accessor properties, whose values are therefore stable

Source: [packages/pass-style/doc/copyArray-guarantees.md](https://github.com/endojs/endo/blob/be51fb10b6f4/packages/pass-style/doc/copyArray-guarantees.md) at commit `be51fb10`.
