---
title: §Sanity check with c8-ignore for unreachable defense-in-depth
source-slug: endo--packages-path-compare-src-index
source-url: https://github.com/endojs/endo/blob/master/packages/path-compare/src/index.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/path-compare/src/index.js
total-lines: 84
ingest-cycle: 237
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-path-compare-src-index--shortlex-ordering-with-five-named-steps-and-doc-comment-IS-the-specification-and-undefined-greater-than-anything-and-sanity-check-with-c8-ignore
---

After step 2 (the length check that returns when lengths differ), the function reaches a §dead-code-sanity-check:

```js
// sanity check
/* c8 ignore next 5 */
if (a.length !== b.length) {
  throw new Error(
    `Unexpectedly different lengths of string arrays: ${q({ a, b })}`,
  );
}
```

§The-condition-is-the-negation-of-step-2's-condition, so if step 2 didn't return, the condition is necessarily false. §The-code-is-unreachable-by-the-algorithm but §defense-in-depth-against-future-edits-that-might-remove-step-2. §The-`/* c8 ignore next 5 */` is the explicit signal to coverage tooling that §this-is-deliberate-unreachable-code-not-untested-code. §When-coverage-would-flag-dead-code, §c8-ignore-with-explanation. The five-line annotation count covers the `if` line + the `throw` + `new Error(` + the template string + the closing `);`.

§Three-named-uses-of-c8-ignore-in-library-so-far (need to confirm — likely first explicit observation as a borrowable pattern; mark §first-observation). §JSON.stringify-aliased-as-q-for-terse-error-messages: `const { stringify: q } = JSON;` at file top. §The-q-alias makes the error message expression short: `${q({ a, b })}`. §When-error-messages-need-to-show-a-structured-value, §alias-JSON.stringify-as-q.
