---
section: what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
source: endo--packages-pass-style-src-remotable-js
topics: [pass-style, marshal]
status: current
title: The §confirmedRemotables WeakSet cache
parent: endo--packages-pass-style-src-remotable-js--what-a-remotable-is-with-tag-record-inheritance-and-distinct-object-vs-function-remotable-shapes
---

The §memoization:

```js
const confirmedRemotables = new WeakSet();

const confirmRemotable = (val, reject) => {
  if (confirmedRemotables.has(val)) {
    return true;
  }
  // ... check ...
  if (result) {
    confirmedRemotables.add(val);
  }
  return result;
};
```

The §cache-positive-not-negative discipline:

> *We don't remember rejections because they are possible to
> correct with e.g. `harden`.*

A non-frozen object would fail today; after the caller hardens
it, the same object passes. So *no false negatives via cache* —
only positives are cached. The §discipline-anticipates-mutation:
the cache is *forward-only* — once true, always true (because the
checks are about frozen-ness + structure, both of which are
permanent once set); rejections are *not* cached because they're
about *the value at this moment*.

The *use of WeakSet* lets the cache GC entries when the remotable
itself is collected — *no leak*.
