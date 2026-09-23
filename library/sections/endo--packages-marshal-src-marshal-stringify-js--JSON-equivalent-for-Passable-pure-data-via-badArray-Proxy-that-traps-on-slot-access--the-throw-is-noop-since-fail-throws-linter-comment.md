---
section: JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
source: endo--packages-marshal-src-marshal-stringify-js
topics: [marshal, pass-style, hardened-javascript]
status: current
title: The §throw-is-noop-since-Fail-throws linter comment
parent: endo--packages-marshal-src-marshal-stringify-js--JSON-equivalent-for-Passable-pure-data-via-badArray-Proxy-that-traps-on-slot-access
---

```js
get: (_target, name, _receiver) => {
  if (name === 'length') {
    return 0;
  }
  // `throw` is noop since `Fail` throws. But linter confused
  throw Fail`Marshal's parse must not encode any slot positions ${name}`;
},
```

The §linter-noise-as-documentation pattern: `throw` is
*technically* a no-op because `Fail\`...\`` already throws.
But ESLint's flow analysis doesn't model `Fail` as
non-returning; the explicit `throw` *appeases the linter*.

The §comment-explains-the-extra-`throw` discipline: future
readers reading the code will see *both* `Fail` and `throw`;
the comment explains that one is for the *user* and one is
for the *linter*.
