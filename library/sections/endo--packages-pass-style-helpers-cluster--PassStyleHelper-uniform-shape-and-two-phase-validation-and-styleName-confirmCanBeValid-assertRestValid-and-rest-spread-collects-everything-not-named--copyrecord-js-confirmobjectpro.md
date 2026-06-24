---
title: §copyRecord.js — §confirmObjectPrototype + §confirmPropertyCanBeValid
source-slug: endo--packages-pass-style-helpers-cluster
section-id: PassStyleHelper-uniform-shape-and-two-phase-validation-and-styleName-confirmCanBeValid-assertRestValid-and-rest-spread-collects-everything-not-named
url: https://github.com/endojs/endo/tree/master/packages/pass-style/src
authors: [Endo contributors]
repo: endojs/endo
path: packages/pass-style/src/{byteArray.js, copyArray.js, copyRecord.js, tagged.js, iter-helpers.js, string.js, makeTagged.js}
status: shipping
ingest-cycle: 227
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-pass-style-helpers-cluster--PassStyleHelper-uniform-shape-and-two-phase-validation-and-styleName-confirmCanBeValid-assertRestValid-and-rest-spread-collects-everything-not-named
---

```js
const confirmObjectPrototype = (candidate, reject) => {
  return (
    getPrototypeOf(candidate) === objectPrototype ||
    (reject && reject`Records must inherit from Object.prototype: ${candidate}`)
  );
};

const confirmPropertyCanBeValid = (candidate, key, value, reject) => {
  return (
    (typeof key === 'string' ||
      (reject &&
        reject`Records can only have string-named properties: ${candidate}`)) &&
    (!canBeMethod(value) ||
      (reject &&
        reject`Records cannot contain non-far functions because they may be methods of an implicit Remotable: ${candidate}`))
  );
};
```

§Two-named-internal-predicates with §the-Rejector-three-line-idiom (`cond || (reject && reject\`...\`)`). §confirmCanBeValid composes them with `.every`:

```js
confirmCanBeValid: (candidate, reject) => {
  return (
    confirmObjectPrototype(candidate, reject) &&
    ownKeys(candidate).every(key =>
      confirmPropertyCanBeValid(candidate, key, candidate[key], reject),
    )
  );
},
```

§Three-constraints-checked-in-sequence: §inherits-from-Object.prototype + §string-named-property-keys + §no-method-like-values. §Sibling to cycle 230 (anticipated) Remotable's §non-far-functions-may-be-methods discipline.

§The-TODO-comment in `confirmPropertyCanBeValid`:

```js
// TODO: Update message now that there is no such thing as "implicit Remotable".
```

§Honest-acknowledgment-of-stale-error-message-text. §Borrowable-pattern: §TODO-comment-marks-a-stale-error-message that's still informative-enough-to-be-useful. §The-fix-is-not-urgent; the comment is.
