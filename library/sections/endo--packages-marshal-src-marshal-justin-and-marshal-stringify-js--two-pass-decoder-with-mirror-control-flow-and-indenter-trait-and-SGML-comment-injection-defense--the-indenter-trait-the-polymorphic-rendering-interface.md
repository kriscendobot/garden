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
title: §The-Indenter-trait (the §polymorphic-rendering-interface)
parent: endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js--two-pass-decoder-with-mirror-control-flow-and-indenter-trait-and-SGML-comment-injection-defense
---

```js
/**
 * @typedef {object} Indenter
 * @property {(openBracket: string) => number} open
 * @property {() => number} line
 * @property {(token: string) => number} next
 * @property {(closeBracket: string) => number} close
 * @property {() => string} done
 */
```

§Five-method-interface. §`open(bracket)` increases nesting;
`line()` emits a newline+indent; `next(token)` emits a token
with optional separating whitespace; `close(bracket)` reduces
nesting; `done()` finalizes and returns the string.

§Two-implementations: §makeYesIndenter (readable; tracks
`level` for indentation) + §makeNoIndenter (minimum
whitespace; uses §badPair-detector to decide when whitespace
is required).

§Polymorphism-via-makeIndenter-dispatch:

```js
const makeIndenter = shouldIndent ? makeYesIndenter : makeNoIndenter;
let out = makeIndenter();
```

§Two-shapes-of-output-from-one-decoder. §The-decoder-doesn't-
care-which-indenter-it-uses; it just calls the five-method
interface.

§Compare-to-cycle-185-check-bundle's §powered-and-powerless-
symmetric-pair: both are §runtime-polymorphism-via-shared-
interface, but at different scales. §Check-bundle has §two-
modules; this has §two-factory-functions.

§The-§out-as-mutable-binding (`let out = makeIndenter()`) lets
the §nestedRender-pattern swap implementations temporarily;
see below.
