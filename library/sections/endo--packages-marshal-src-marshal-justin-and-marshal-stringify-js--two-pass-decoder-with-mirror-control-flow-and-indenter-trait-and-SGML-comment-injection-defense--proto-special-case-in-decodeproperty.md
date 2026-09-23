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
title: §`__proto__` special case in decodeProperty
parent: endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js--two-pass-decoder-with-mirror-control-flow-and-indenter-trait-and-SGML-comment-injection-defense
---

```js
const decodeProperty = (name, value) => {
  out.line();
  if (name === '__proto__') {
    // JavaScript interprets `{__proto__: x, ...}`
    // as making an object inheriting from `x`, whereas
    // in JSON it is simply a property name. Preserve the
    // JSON meaning.
    out.next(`["__proto__"]:`);
  } else if (identPattern.test(name)) {
    out.next(`${name}:`);
  } else {
    out.next(`${quote(name)}:`);
  }
  decode(value);
  out.next(',');
};
```

§Three-cases-for-property-naming:

1. **§`__proto__`**: emit as `["__proto__"]:` (computed key) to
   §avoid-prototype-poisoning.
2. **§identPattern-match** (`/^[a-zA-Z]\w*$/`): emit bare
   identifier.
3. **§otherwise**: JSON-quote the name.

§Why-`__proto__`-is-special: in JavaScript object literals,
`{__proto__: x}` sets the prototype of the new object to `x`.
§In-JSON, `{"__proto__": x}` is just a property assignment.
§The-Justin-rendering must preserve the JSON-meaning, so it
emits `["__proto__"]:` (computed property key) which is §a-
property-assignment-not-a-prototype-set.

§Compare-to-cycle-152-pass-style/symbol.js' §Hilbert-Hotel-
encoding for §"namespaces-that-could-collide"; cycle 189's
§`__proto__`-bracket-escape is the §single-case-where-property-
syntax-differs-between-JSON-and-JS.

§Tier-1-borrowing: §`__proto__`-bracket-escape applies wherever
JS-source is rendered from JSON-shaped data and the renderer
must avoid §accidental-prototype-pollution.
