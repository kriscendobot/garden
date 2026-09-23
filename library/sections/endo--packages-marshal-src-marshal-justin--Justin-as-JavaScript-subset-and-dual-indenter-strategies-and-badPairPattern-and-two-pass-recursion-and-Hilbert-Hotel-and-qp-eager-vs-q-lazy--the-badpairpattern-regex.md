---
title: §The-`badPairPattern` regex
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
const badPairPattern = /^(?:\w\w|<<|>>|\+\+|--|<!|->)$/;
```

§Six-named-token-pair-cases that must be separated by whitespace to preserve meaning:
1. `\w\w` — two word characters (e.g., `foo bar` not `foobar`).
2. `<<` — bitwise left shift.
3. `>>` — bitwise right shift.
4. `++` — increment.
5. `--` — decrement.
6. `<!` — would form HTML-style comment start.
7. `->` — would form HTML-style comment end.

§The-honest-comment:

> The `<!` and `->` cases prevent the accidental formation of an html-like comment. I don't think the double angle brackets are actually needed but I haven't thought about it enough to remove them.

§Borrowable-pattern: §regex-encoding-token-pairs-that-must-be-separated + §honest-comment-admitting-some-cases-might-be-unnecessary-but-haven't-been-removed. §The-comment-makes-the-uncertainty-visible.

§The-`<!`-and-`->`-cases — §JavaScript-historically-treats-`<!--`-and-`-->`-as-comment-syntax in script tags for legacy HTML compatibility. §The-renderer-must-avoid-emitting-these-token-pairs-even-by-accident.

§Borrowable-pattern: §when-emitting-source-code, §enumerate-the-token-pair-cases-that-have-special-meaning-in-the-target-language + §guard-against-accidentally-emitting-them.
