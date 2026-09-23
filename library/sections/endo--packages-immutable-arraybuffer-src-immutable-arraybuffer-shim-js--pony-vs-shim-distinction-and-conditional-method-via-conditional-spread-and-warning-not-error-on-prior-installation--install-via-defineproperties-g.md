---
title: §Install via defineProperties + getOwnPropertyDescriptors
source-slug: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js
source-url: https://github.com/endojs/endo/blob/master/packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
total-lines: 97
ingest-cycle: 245
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation
---

```js
defineProperties(
  arrayBufferPrototype,
  getOwnPropertyDescriptors(arrayBufferMethods),
);
```

§Canonical-install-pattern: §defineProperties + §getOwnPropertyDescriptors. §The-property-descriptors-from-the-source-object-are-copied-to-the-target + §the-non-enumerable-flag-set-earlier-IS-preserved + §the-getter-`get immutable()`-IS-installed-as-an-accessor-not-a-data-property.

§When-installing-methods-and-getters-onto-a-prototype-uniformly, §use-defineProperties-with-getOwnPropertyDescriptors-not-iteration-with-defineProperty. §The-batch-IS-the-correctness-mechanism — §each-property-keeps-its-original-descriptor-flags (writable, configurable, enumerable, get, set).

§First-explicit-observation in library of §install-via-defineProperties-plus-getOwnPropertyDescriptors as canonical shim-install pattern.
