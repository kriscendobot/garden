---
title: §The feature-detection-at-module-load with conditional binding
source-slug: endo--packages-pass-style-src-string-js
section-slug: isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-as-polyfill-and-three-stage-migration-plan
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/string.js
source-repo: endojs/endo
source-path: packages/pass-style/src/string.js
source-author: Endo project (collective)
total-lines: 83
ingest-cycle: 272
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-string-js--isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-as-polyfill-and-three-stage-migration-plan
---

Lines 5 and 23-42 carry the §feature-detection pattern:

```js
const hasWellFormedStringMethod = !!String.prototype.isWellFormed;

export const isWellFormedString = hasWellFormedStringMethod
  ? str => typeof str === 'string' && str.isWellFormed()
  : str => {
      if (typeof str !== 'string') {
        return false;
      }
      for (const ch of str) {
        const cp = /** @type {number} */ (ch.codePointAt(0));
        if (cp >= 0xd800 && cp <= 0xdfff) {
          return false;
        }
      }
      return true;
    };
```

§The-conditional-binding (ternary on the feature-detection bool) yields two different implementations of `isWellFormedString` at module load. §sibling-pattern to cycle 260's `adaptImmutableArrayBuffer`-factory but instantiated as a ternary rather than a factory function.

§Two-cycles-with-feature-detection-at-module-load (260 byteArray's adapter-factory + 272 string's conditional-binding); §the-pattern-IS-the-same-discipline-with-two-different-implementations.

§First-explicit-observation in library: **§the-conditional-binding-via-ternary-on-feature-detection-bool-as-alternative-to-the-adapter-factory-pattern — §when-the-feature-detection-yields-a-binary-choice, §a-ternary-IS-sufficient + §when-it-yields-multiple-values-an-adapter-factory-IS-needed; §two-named-shapes-of-feature-detection-at-module-load**.
