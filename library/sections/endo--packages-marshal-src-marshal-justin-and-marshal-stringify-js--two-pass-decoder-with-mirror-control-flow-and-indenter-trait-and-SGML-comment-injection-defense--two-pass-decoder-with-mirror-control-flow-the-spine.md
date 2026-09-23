---
source: packages/marshal/src/marshal-justin.js + packages/marshal/src/marshal-stringify.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/tree/master/packages/marshal/src
source_path: packages/marshal/src/marshal-justin.js, packages/marshal/src/marshal-stringify.js
section_kind: source
ingested: 2026-06-04
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Mark S. Miller (prompted)
topics:
  - marshal
  - pass-style
  - errors
genre: §endo-source-comment-fragment §canonical-passable-rendering-pair
cycle: 189
lane: chat
status: current
title: §Two-pass-decoder-with-mirror-control-flow (the spine)
parent: endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js--two-pass-decoder-with-mirror-control-flow-and-indenter-trait-and-SGML-comment-injection-defense
---

```js
const decodeToJustin = (encoding, shouldIndent = false, slots = []) => {
  /**
   * The first pass does some input validation.
   * Its control flow should mirror `recur` as closely as possible
   * and the two should be maintained together. They must visit everything
   * in the same order.
   *
   * TODO now that ibids are gone, we should fold this back together into
   * one validating pass.
   */
  const prepare = rawTree => { ... };

  // ... makeIndenter() setup ...

  const recur = rawTree => { ... };

  prepare(encoding);
  decode(encoding);  // calls recur
  return out.done();
};
```

§Two-passes-over-the-same-encoding: `prepare()` validates;
`recur()`/`decode()` renders. §The-prose-comment is the §critical-
maintenance-instruction: "Its control flow should mirror
`recur` as closely as possible and the two should be
maintained together. They must visit everything in the same
order."

§Why-two-passes: separating validation from rendering means
the renderer can §safely-assume-everything-is-already-
validated. §The-second-pass-can-be-§pure-rendering.

§The-§TODO-named-explicitly: "now that ibids are gone, we
should fold this back together into one validating pass." §The-
two-pass-structure-is-a-historical-artifact (ibids were a
prior encoding feature that needed two passes). §The-fold-back-
is-deferred.

§Compare-to-cycle-187-shim-cluster's §considered-and-rejected
discipline and cycle 188-perf's §working-copy-inventory.
§Both-are-§honest-design-state-disclosure. §Cycle-189's-§TODO-
in-comment is the in-source variant.

§The-discipline of "two-passes-must-be-maintained-together"
appears in cycle 174-gateway-package's §three-design-lifecycle-
statuses-now-distinguished as a similar §invariant-spanning-
multiple-places.
