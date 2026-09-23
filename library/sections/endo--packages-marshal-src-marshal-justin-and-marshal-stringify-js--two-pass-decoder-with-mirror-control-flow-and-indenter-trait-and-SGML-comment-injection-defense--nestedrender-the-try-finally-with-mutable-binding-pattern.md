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
title: §nestedRender (the §try/finally-with-mutable-binding pattern)
parent: endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js--two-pass-decoder-with-mirror-control-flow-and-indenter-trait-and-SGML-comment-injection-defense
---

```js
case 'slot': {
  const { iface } = rawTree;
  const index = Number(Nat(rawTree.index));
  const nestedRender = arg => {
    const oldOut = out;
    try {
      out = makeNoIndenter();
      decode(arg);
      return out.done();
    } finally {
      out = oldOut;
    }
  };
  ...
}
```

§Temporarily-swap-the-renderer to compose a sub-string; §try/
finally-restores-the-original. §The-`out` variable is a §`let`
binding precisely so it can be swapped.

§Why-needed: the `slotToVal(renderedSlot, renderedIface)` call
needs the slot and iface arguments rendered as §expressions-
without-line-breaks-or-indent (so they fit inline in the
outer rendering). §Using-makeNoIndenter regardless of the
outer mode produces clean inline expressions.

§The-§try/finally-pattern ensures that even if `decode(arg)`
throws, the §outer-out-binding-is-restored. §Defensive-against-
exceptions in nested decoding.

§Compare-to-cycle-90-track-turns's §async-boundary-discipline
and cycle 187-shim's §postponedHandler-interlockP. §All-three-
are-§save-and-restore-state patterns at different layers.
