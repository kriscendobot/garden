---
title: §`qp` — quasi-quotes-Justin-template-literal-tag
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
export const qp = payload => `\`${passableAsJustin(harden(payload), true)}\``;
```

§A-template-literal-tag that returns the Passable rendered as a Justin expression wrapped in backticks. §Used-with-Fail-X-quote from @endo/errors:

```js
const patt = M.and(M.gte(-100), M.lte(100));
`${qp(patt)}`
// produces:
// `makeTagged("match:and", [
//   makeTagged("match:gte", -100),
//   makeTagged("match:lte", 100),
// ])`
```

§Borrowable-pattern: §a-quasi-quote-template-literal-tag-renders-domain-values-as-evaluatable-source. §The-error-message-becomes-a-snippet-that-the-reader-can-paste-into-a-REPL.

§Sibling to cycle 217 @endo/errors' §the-Rejector-three-line-idiom — both designs §template-literals-as-the-domain-API.
