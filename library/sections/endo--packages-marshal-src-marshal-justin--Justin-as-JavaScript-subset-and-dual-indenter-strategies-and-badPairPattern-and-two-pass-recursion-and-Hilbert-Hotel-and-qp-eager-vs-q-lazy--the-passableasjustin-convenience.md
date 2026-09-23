---
title: §The-passableAsJustin convenience
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
export const passableAsJustin = (passable, shouldIndent = true) => {
  let slotCount = 0;
  const convertValToSlot = val => `s${slotCount++}`;
  const { toCapData } = makeMarshal(convertValToSlot);
  const { body, slots } = toCapData(passable);
  const encoded = JSON.parse(body);
  return decodeToJustin(encoded, shouldIndent, slots);
};
```

§Pipeline-of-three-stages:
1. `toCapData` — marshal the Passable to CapData with §`s0`/`s1`/`s2`-style-slot-labels.
2. `JSON.parse` — re-parse the wire body.
3. `decodeToJustin` — emit Justin.

§Borrowable-pattern: §use-the-existing-marshal-to-CapData-pipeline + §re-parse + §emit-target-syntax. §Justin-emission-is-a-downstream-of-CapData-encoding; §it-doesn't-need-to-walk-the-original-tree-itself.
