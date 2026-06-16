---
title: §Module structure overview
source-slug: endo--packages-pass-style-src-byteArray-js
section-slug: ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/byteArray.js
source-repo: endojs/endo
source-path: packages/pass-style/src/byteArray.js
source-author: Endo project (collective)
total-lines: 68
ingest-cycle: 260
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-byteArray-js--ByteArrayHelper-as-PassStyleHelper-with-adaptImmutableArrayBuffer-feature-detection-at-module-load-and-three-line-validity-check-and-proposed-vs-shimmed-prototype-discipline
---

The file has **three top-level concerns**, in order:

1. **Imports + local destructuring** (lines 1–9): `harden` from `@endo/harden`; `X` and `Fail` from `@endo/errors`; an `@import` typedef of `PassStyleHelper` from the sibling `./internal-types.js`; destructuring of `Object.{getPrototypeOf, getOwnPropertyDescriptor}` and `Reflect.{ownKeys, apply}` into local consts.
2. **`adaptImmutableArrayBuffer` factory** (lines 14–42) called immediately at module load (line 44) — feature-detects platform support for `sliceToImmutable()` on `ArrayBuffer`, returns either real `{immutableArrayBufferPrototype, immutableGetter}` or `{immutableArrayBufferPrototype: null, immutableGetter: () => false}`.
3. **`export const ByteArrayHelper`** (lines 50–68) — the hardened PassStyleHelper instance, exported by name.

§The-three-concerns-template (imports + adapter-factory + named-helper-export) is a recurring shape across the PassStyleHelpers; the byteArray case adds the adapter-factory step because byteArray is the only pass-style whose validity depends on a stage-3 ECMAScript proposal that may not be present on the platform.
