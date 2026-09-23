---
title: §The unicode-iteration-trick as polyfill strategy
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

Lines 29-39 (the polyfill body):

```js
for (const ch of str) {
  // The string iterator iterates by Unicode code point, not
  // UTF16 code unit. But if it encounters an unpaired surrogate,
  // it will produce it.
  const cp = /** @type {number} */ (ch.codePointAt(0));
  if (cp >= 0xd800 && cp <= 0xdfff) {
    // All surrogates are in this range. The string iterator only
    // produces a character in this range for unpaired surrogates,
    // which only happens if the string is not well-formed.
    return false;
  }
}
```

§The-trick:
1. JS's string iterator (`for (const ch of str)`) iterates **by Unicode code point, not UTF-16 code unit**.
2. **BUT** it produces a single character in the surrogate range `0xd800-0xdfff` ONLY when it encounters an **unpaired surrogate**.
3. Therefore: if any iterated character has a code point in the surrogate range, the string IS not well-formed.

§First-explicit-observation in library: **§the-unicode-iteration-trick-as-named-polyfill-strategy — §JS's-string-iterator-produces-single-surrogate-characters-ONLY-for-unpaired-surrogates + §iterating-and-checking-the-code-point-range-against-surrogates-IS-the-well-formed-check**.

§The-polyfill-IS-trickier-than-the-naive-implementation — §the-naive-implementation-would-iterate-by-UTF-16-code-unit-and-track-pairs; §the-trick-leverages-the-iterator's-built-in-pair-resolution + §catches-only-unpaired-residue.

§Named-Unicode-knowledge-encoded-in-the-comment — §two-paragraphs-of-Unicode-explanation; §the-author-named-the-key-property + §the-property-IS-load-bearing + §without-it-the-polyfill-is-obscure; §first-explicit-observation in library of §named-Unicode-iteration-property-as-load-bearing-polyfill-discipline.

§Surrogate-range-0xd800-0xdfff-named-explicitly — §the-magic-numbers-aren't-named-with-a-constant + §the-comment-names-them-instead; §the-discipline-IS-comment-IS-the-constant; §sibling-pattern to cycle 260's named-constant-with-comment-as-the-vocabulary-source.
