---
title: §Conditional method via conditional spread
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
const arrayBufferMethods = {
  sliceToImmutable(start = undefined, end = undefined) { ... },
  get immutable() { return isBufferImmutable(this); },

  ...(optTransferBufferToImmutable
    ? {
        transferToImmutable(newLength = undefined) { ... },
      }
    : {}),
};
```

§Conditional-method-via-conditional-spread + §the-method-only-exists-if-the-platform-supports-it (`optTransferBufferToImmutable` is the optional pony function — present iff the platform has the underlying API).

§When-a-shim-method-depends-on-an-optional-platform-feature, §use-conditional-spread-not-conditional-Object.defineProperty + §the-method-is-either-present-or-absent-not-present-with-a-throw. §Sibling-to-cycle-238's-structural-attenuation-not-behavioral-attenuation — §the-method-IS-absent-not-present-with-a-throw.

§Three-cycles-with-explicit-absence-as-attenuation (238 + 242 + 245). §Cycle-238's-readOnly-returns-the-readable-interface-not-a-frozen-copy; §cycle-242's-no-help()-in-this-layer; §cycle-245's-conditional-spread-when-platform-feature-is-absent.

§The-`opt`-prefix on `optTransferBufferToImmutable` is the naming convention for the optional pony function — §the-pony-exports-the-function-only-if-the-platform-supports-it. §When-a-pony-function-may-or-may-not-be-exported, §prefix-with-`opt`-to-signal-the-optional-availability.
