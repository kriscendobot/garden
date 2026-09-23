---
section: what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
source: endo--packages-pass-style-src-remotable-js
topics: [pass-style, marshal]
status: current
title: The §canBeMethodName — strings, symbols, *and numbers*
parent: endo--packages-pass-style-src-remotable-js--what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
---

The §predicate accepts three key types:

```js
const canBeMethodName = key =>
  typeof key === 'string' || typeof key === 'symbol' || typeof key === 'number';
```

The §commented-out-stricter-line `// typeof key === 'string' ||
typeof key === 'symbol';` is the *narrower* version this design
was considering. The current implementation also accepts numbers;
the §TODO links to issue #2884:

> *TODO https://github.com/endojs/endo/issues/2884*
> *Abstract out canBeMethodName so later PRs agree on method name
> restrictions.*

The §number-as-method-name allowance is open: the predicate
admits it now; a future PR will tighten or formalize.
