---
title: §Better-fidelity emulation of class prototype via non-enumerable properties
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
// Better fidelity emulation of a class prototype
for (const key of ownKeys(arrayBufferMethods)) {
  defineProperty(arrayBufferMethods, key, {
    enumerable: false,
  });
}
```

§Better-fidelity-emulation-of-class-prototype as named design move. §Class-prototype-methods-are-non-enumerable-by-default + §object-literal-methods-are-enumerable-by-default + §so-the-shim-must-strip-enumerability-to-match-class-prototype-semantics.

§When-installing-methods-on-a-built-in-prototype, §strip-enumerability-via-defineProperty-loop + §the-result-IS-better-fidelity-emulation-of-a-class. §First-explicit-observation in library of §strip-enumerability-via-defineProperty-loop as the shim-installation discipline.

§The-comment-explicitly-names-the-purpose: §better-fidelity-emulation. §When-a-design-move-improves-fidelity-not-functionality, §name-it-as-fidelity-improvement.
