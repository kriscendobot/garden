---
title: §the-`set index(index)` argument-name-same-as-property pattern (first-explicit-observation)
section-slug: endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API
source-slug: endo--packages-zip-src-buffer-writer-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/buffer-writer.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/buffer-writer.js
total-lines: 188
ingest-cycle: 290
ingest-date: 2026-06-11
lane: chat
scope: full
parent: endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API
---

```javascript
set index(index) {
  this.seek(index);
}
```

**The setter's parameter has the same name as the property**. JavaScript allows this; the parameter shadows the property within the setter's body, which is fine because the setter delegates to `seek(index)` and doesn't try to access `this.index` directly.

§the-shadowing-IS-syntactic-not-confusing in this case because the body doesn't reference the property. **§the-named-parameter-IS-the-canonical-name** for what you're setting.
