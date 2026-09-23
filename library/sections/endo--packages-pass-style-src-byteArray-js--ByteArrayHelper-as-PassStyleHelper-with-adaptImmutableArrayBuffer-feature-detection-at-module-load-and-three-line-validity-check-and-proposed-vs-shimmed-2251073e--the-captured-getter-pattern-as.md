---
title: §The captured-getter pattern as defense against property shadowing
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

Line 60: `apply(immutableGetter, candidate, [])` is functionally equivalent to `candidate.immutable` *if and only if* `candidate` has not shadowed `.immutable`. The byteArray helper assumes shadowing IS possible (because the candidate may be an attacker-controlled object that has crossed a marshal boundary):

- §a-naive-`candidate.immutable`-read goes through the candidate's own property lookup → its own prototype's lookup → ArrayBuffer.prototype's lookup; any of those can shadow.
- §`apply(immutableGetter, candidate, [])` invokes the §captured-getter-function with the candidate bound as `this`; no property lookup happens on the candidate.
- §the-getter-function-is-captured-at-module-load (line 36–39) from the canonical `immutableArrayBufferPrototype`; it cannot be swapped by post-lockdown attacker code because the binding is held in module-scope `const`.

§the-canonical-pattern (sibling to cycle 245's panic-cluster): §capture-the-native-getter-at-module-load + §call-it-via-Reflect.apply-with-the-candidate-as-this + §never-trust-the-candidate's-own-property-lookup.

§Three-cycles-with-pre-lockdown-getter-capture-plus-Reflect-apply-defensive-call (cycle 235 base64 + cycle 245 panic + cycle 260 byteArray) — §this is now a §reified-discipline across the library.

§First-explicit-observation as named cluster: **§three-cycles-with-pre-lockdown-getter-capture-plus-Reflect-apply-defensive-call**.
