---
title: §The proposed-vs-shimmed prototype discipline
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

Lines 28–34 contain a doc comment whose precision is unusual:

```
/**
 * As proposed, this will be the same as `ArrayBuffer.prototype`. As shimmed,
 * this will be a hidden intrinsic that inherits from `ArrayBuffer.prototype`.
 * Either way, get this in a way that we can trust it after lockdown, and
 * require that all immutable ArrayBuffers directly inherit from it.
 */
const immutableArrayBufferPrototype = getPrototypeOf(anImmutableArrayBuffer);
```

§The-proposed-vs-shimmed-discipline names two possible runtime topologies that the code must accept without branching:

- §**The-proposed-shape**: `immutableArrayBufferPrototype === ArrayBuffer.prototype` (the stage-3 proposal adds `.immutable` as a getter on `ArrayBuffer.prototype` itself). Immutable and mutable ArrayBuffers share a prototype; the difference is internal slot state.
- §**The-shimmed-shape**: `immutableArrayBufferPrototype` is a **hidden intrinsic** that inherits from `ArrayBuffer.prototype`. Immutable ArrayBuffers have a one-level-deeper prototype chain; the hidden intrinsic carries the `.immutable` getter.

§The-getPrototypeOf-of-an-instance-yields-the-correct-prototype-in-either-topology — the code obtains the prototype dynamically rather than naming `ArrayBuffer.prototype` or any shim-specific intrinsic. §the-runtime-tells-us-the-shape rather than the source code presuming.

§"get this in a way that we can trust it after lockdown" — the read happens at module load (pre-lockdown), so the captured `immutableArrayBufferPrototype` and `immutableGetter` are §captured-before-lockdown-and-remain-trustworthy-after. Sibling pattern to cycle 245's `@endo/panic`'s pre-lockdown native-capture and cycle 246's pre-lockdown-capture-and-shim-replacement discipline.

§"require that all immutable ArrayBuffers directly inherit from it" — this is the **policy** the helper enforces via `getPrototypeOf(candidate) === immutableArrayBufferPrototype` (strict equality, not `instanceof`). §direct-prototype-equality-not-instanceof — §when-the-canonical-prototype-is-captured-at-module-load, §use-strict-equality-against-the-capture-rather-than-instanceof-or-isPrototypeOf; §instanceof-walks-the-prototype-chain-and-can-accept-subclasses + §isPrototypeOf-also-walks-the-chain + §strict-equality-rejects-anything-with-an-extra-prototype-link-between-the-candidate-and-the-canonical-prototype.

§First-explicit-observation in library: **§the-proposed-vs-shimmed-discipline-named-as-two-runtime-topologies-the-code-accepts-without-branching**.
