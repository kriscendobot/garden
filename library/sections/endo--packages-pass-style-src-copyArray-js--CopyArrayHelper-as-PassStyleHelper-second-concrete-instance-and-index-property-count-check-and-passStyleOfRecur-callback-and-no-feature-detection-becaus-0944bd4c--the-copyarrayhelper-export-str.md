---
title: §The CopyArrayHelper export structure
source-slug: endo--packages-pass-style-src-copyArray-js
section-slug: CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/copyArray.js
source-repo: endojs/endo
source-path: packages/pass-style/src/copyArray.js
source-author: Endo project (collective)
total-lines: 38
ingest-cycle: 262
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal
---

Lines 9-38:

```js
/**
 *
 * @type {import('./internal-types.js').PassStyleHelper}
 */
export const CopyArrayHelper = harden({
  styleName: 'copyArray',

  confirmCanBeValid: (candidate, reject) =>
    isArray(candidate) || (reject && reject`Array expected: ${candidate}`),

  assertRestValid: (candidate, passStyleOfRecur) => {
    getPrototypeOf(candidate) === arrayPrototype ||
      assert.fail(X`Malformed array: ${candidate}`, TypeError);
    // Since we're already ensured candidate is an array, it should not be
    // possible for the following get to fail.
    const len = /** @type {number} */ (
      confirmOwnDataDescriptor(candidate, 'length', false, Fail).value
    );
    // Validate that each index property is own/data/enumerable
    // and its associated value is recursively passable.
    for (let i = 0; i < len; i += 1) {
      passStyleOfRecur(
        confirmOwnDataDescriptor(candidate, i, true, Fail).value,
      );
    }
    // Expect one key per index plus one for 'length'.
    ownKeys(candidate).length === len + 1 ||
      assert.fail(X`Arrays must not have non-indexes: ${candidate}`, TypeError);
  },
});
```

§Three-disciplines-in-one-export-line (cycle 260 sibling) — `export const CopyArrayHelper = harden({...})`: const + harden + PascalCase-with-Helper-suffix. §The-binding-name-convention is consistent across both helpers; §the-style-name-pattern in lowercase camelCase too (`'copyArray'` mirrors `'byteArray'`).

§Two-cycles-with-the-binding-name-convention (260 ByteArrayHelper + 262 CopyArrayHelper); §discipline-now-emergent-pattern-across-the-cluster.
