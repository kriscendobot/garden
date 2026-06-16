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
title: §badArray-proxy-rejecting-all-slot-positions (marshal-stringify.js)
parent: endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js--two-pass-decoder-with-mirror-control-flow-and-indenter-trait-and-SGML-comment-injection-defense
---

```js
const badArrayHandler = harden({
  get: (_target, name, _receiver) => {
    if (name === 'length') {
      return 0;
    }
    // `throw` is noop since `Fail` throws. But linter confused
    throw Fail`Marshal's parse must not encode any slot positions ${name}`;
  },
});

const arrayTarget = freeze([]);
const badArray = new Proxy(arrayTarget, badArrayHandler);
```

§A-proxy-that-rejects-all-slot-position-accesses. §The-`length`
property returns 0; §any-other-property-access-throws.

§Why: `marshal-stringify` is the JSON-stringify-compatible
path. §There-are-no-slots. §If-the-unserializer attempts to
look up `slots[0]` (because the body contains a slot
reference), the proxy throws with a §named-error: "Marshal's
parse must not encode any slot positions {name}."

§The-`length === 0` special case: callers may legitimately
check the slots array's length (it's an array) before
indexing. §Returning-0 lets the validation-not-found path
proceed; the §throw-on-numeric-index protects against
unexpected slot access.

§The-`freeze` but not `harden` discipline (the proxy target):

```
`freeze` but not `harden` the proxy target so it remains trapping.
Thus, it should not be shared outside this module.

@see https://github.com/endojs/endo/blob/master/packages/ses/docs/preparing-for-stabilize.md
```

§Same-discipline-as-cycle-146-E.js' §freeze-but-not-harden-
proxy-target. §Both-cite-the-§preparing-for-stabilize-doc.
§A-hardened-target-might-trigger-V8-Proxy-short-circuits
that-bypass-meta-traps; freezing preserves the proxy's trap
behavior.

§The-§"`throw` is noop since `Fail` throws. But linter confused"
comment names a §lint-quirk: ESLint can't see that `Fail` is a
template-tagged function that always throws, so the explicit
`throw` is required to silence the no-fallthrough warning.

§Compare-to-cycle-188-perf's §`@ts-expect-error 2454` and
cycle 181-base64's `/** @type {any} */` casts. §All-three-are-
§linter-or-type-checker-workarounds-with-named-comment.
