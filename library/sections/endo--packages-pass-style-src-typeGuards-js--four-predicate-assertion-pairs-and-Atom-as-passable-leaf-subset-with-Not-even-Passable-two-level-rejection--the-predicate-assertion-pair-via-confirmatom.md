---
section: four-predicate-assertion-pairs-and-Atom-as-passable-leaf-subset-with-Not-even-Passable-two-level-rejection
source: endo--packages-pass-style-src-typeGuards-js
topics: [pass-style, hardened-javascript, marshal]
status: current
title: The §predicate-assertion pair via `confirmAtom`
parent: endo--packages-pass-style-src-typeGuards-js--four-predicate-assertion-pairs-and-Atom-as-passable-leaf-subset-with-Not-even-Passable-two-level-rejection
---

```js
export const isAtom = val => confirmAtom(val, false);
hideAndHardenFunction(isAtom);

export const assertAtom = val => {
  confirmAtom(val, Fail);
};
hideAndHardenFunction(assertAtom);
```

The §`isAtom = confirm(val, false)` + `assertAtom = confirm(val, Fail)`
pattern is cycle 102's checkKey/Is/Assert trio applied to
*Atom*. (The Atom file gets only the *predicate* + *assertion*
exports; cycle 102's `keys/checkKey.js` adds an internal
`confirmX(val, reject)` that's also exported, plus a
WeakSet memo.)

§No-memo-for-Atom: unlike `keys/checkKey.js`'s `keyMemo`
WeakSet, `confirmAtom` doesn't memo. The check is *cheap* —
one passStyleOf call + a switch fall-through. Memoization
would add overhead with no payoff.
