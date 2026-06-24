---
title: Why validate that an object is a CopyRecord?
source: packages/pass-style/doc/copyRecord-guarantees.md
source_repo: endojs/endo
source_commit: be51fb10b6f4
source_date: 2023-11-30
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [pass-style, marshal]
status: current
parent: endo--pkg-pass-style-doc-copyrecord-guarantees--overview
---

The input validation check `assertRecord(r)` asserts that `passStyleOf(r) === 'copyRecord'`. Done early enough, it protects against many dangers. After this test passes, we are guaranteed that `r` is
   * an object for which `Array.isArray(r) === false`, and therefore considered not to be a JavaScript array.
   * an object that inherits directly from `Object.prototype`,
      * Since SES has already hardened `Object.prototype`, this guarantees that `r` inherits nothing enumerable or otherwise surprising.
   * frozen, and therefore
      * all its own properties are non-configurable, and if data properties, non-writable.
      * it will never have more or fewer own properties than it has now.
      * it will never inherit from anything different than what it inherits from now (`Object.prototype`).
   * has only own-properties which are
      * string-named (rather than symbol named)
      * enumerable,
      * data properties, rather than accessor properties, whose values are therefore stable

That last check prevents property getters from sneaking in. After this check succeeds, even if `r` is a proxy, these checks guarantee that any value successfully read from any of its property names is stable --- it will be identical to the result of again successfully reading a value from that property name.

The *successfully* is the critical qualifier though. A proxy handler would still be able to interleave attacker code execution during the reading of a property, or almost any other operation on the object. That interleaved code might throw an exception, preventing the property read from reporting any value, and potentially aborting a should-be-atomic block of code in the middle, leaving behind partially mutated and therefore corrupted state. Worse, the proxy handler might engage in a reentrancy attack against the code that examined the `r` object.

This is a reentrancy attack against code that is simply looking at a simple data object obtained from untrusted callers that has also gone through the input validation above. For "normal" code, catching all these post-validation reentrancy vulnerabilities by review is too hard, so the plan is *not* to review such "normal" code against that, if that code makes adequate use of `passStyleOf` input validation.

This plan is to have `assertRecord(r)` guarantee that `r` is not a proxy. Then, once this check is passed, the above code interleaving dangers are gone. Once validated, `r` is guaranteed to be not just stable but passive, as we intuitively expect data to be.

If `r` is a proxy, then, if this plan goes as we expect, this test will throw without even giving the proxy an opportunity to interleave during the test.

Source: [packages/pass-style/doc/copyRecord-guarantees.md](https://github.com/endojs/endo/blob/be51fb10b6f4/packages/pass-style/doc/copyRecord-guarantees.md) at commit `be51fb10`.
