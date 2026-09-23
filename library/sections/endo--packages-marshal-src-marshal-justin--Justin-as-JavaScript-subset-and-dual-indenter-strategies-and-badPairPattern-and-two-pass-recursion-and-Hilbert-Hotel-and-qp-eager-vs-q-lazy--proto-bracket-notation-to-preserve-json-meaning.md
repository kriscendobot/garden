---
title: "§`[__proto__]:`-bracket-notation-to-preserve-JSON-meaning"
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
```

§Three-cases-for-property-keys:
1. §`__proto__` — §bracket-notation to avoid JS's prototype-setting interpretation.
2. §Identifier-pattern match — §unquoted-name.
3. §Anything else — §JSON.stringify-quoted-name.

§Borrowable-pattern: §when-the-host-language-treats-a-named-property-key-specially, §emit-it-in-the-bracket-notation-to-preserve-the-intended-meaning. §The-comment-IS-the-justification.

§Sibling to cycle 227 pass-style/string.js's §don't-coerce-input — both designs §emit-the-form-that-matches-the-intended-semantics-not-the-form-that-the-host-shortest-syntax-suggests.
