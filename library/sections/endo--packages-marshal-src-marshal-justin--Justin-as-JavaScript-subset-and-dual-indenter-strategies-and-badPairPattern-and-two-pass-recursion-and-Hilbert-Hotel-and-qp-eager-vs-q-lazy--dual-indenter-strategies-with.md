---
title: §Dual-indenter-strategies-with-shared-Indenter-interface
source-slug: endo--packages-marshal-src-marshal-justin
section-id: Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy
url: https://github.com/endojs/endo/blob/master/packages/marshal/src/marshal-justin.js
authors: [Endo contributors]
repo: endojs/endo
path: packages/marshal/src/marshal-justin.js
total-lines: 510
status: shipping
ingest-cycle: 229
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-marshal-src-marshal-justin--Justin-as-JavaScript-subset-and-dual-indenter-strategies-and-badPairPattern-and-two-pass-recursion-and-Hilbert-Hotel-and-qp-eager-vs-q-lazy
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

§Five-method-Indenter-interface implemented twice:

- **§makeYesIndenter** (66 lines) — §generous-whitespace-for-readability with §level-counter + §`'  '.repeat(level)` indentation.
- **§makeNoIndenter** (33 lines) — §minimum-whitespace-needed-to-preserve-meaning; tracks the last emitted character to decide if a separator is needed.

§Borrowable-pattern: §two-implementations-of-the-same-interface-with-different-strategies + §the-caller-picks-via-named-boolean (`shouldIndent`). §The-interface-is-the-protocol; §the-strategy-is-pluggable.

§Sibling to cycle 227 pass-style helpers' §PassStyleHelper-uniform-shape — both designs §uniform-interface-with-multiple-implementations.
