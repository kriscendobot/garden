---
title: §Feature-detection at module load with two return shapes
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

`adaptImmutableArrayBuffer` is an **immediately-invoked closure** (defined at line 14, called at line 44, result destructured into module-scope `immutableArrayBufferPrototype` and `immutableGetter`). The closure makes a one-line probe:

```js
const anArrayBuffer = new ArrayBuffer(0);

if (anArrayBuffer.sliceToImmutable === undefined) {
  return {
    immutableArrayBufferPrototype: null,
    immutableGetter: () => false,
  };
}
```

§Two-shapes-with-same-keys is the function's contract: caller destructures by name and gets either real values or always-deny stand-ins; the call site does not branch on platform feature presence.

- §`immutableArrayBufferPrototype: null` is the **impossibility signal** — when the platform lacks the proposal, no `instanceof`-style check can ever succeed because the helper's `assertRestValid` compares with `===` against this prototype reference.
- §`immutableGetter: () => false` is the **always-deny getter stand-in** — when the platform lacks the proposal, every call to the `.immutable` getter via `apply(immutableGetter, candidate, [])` evaluates to false, which makes the helper's `Fail` branch fire.
- §The-call-site-need-not-know-which-branch-fired — `confirmCanBeValid` returns false in the absence-of-proposal case via `candidate instanceof ArrayBuffer && candidate.immutable` (a real ArrayBuffer cannot satisfy `.immutable` without the proposal).
- §The-feature-detection-runs-once-at-module-load — *not* on every `passStyleOf` call. The cost of the probe is paid once and amortized across the lifetime of the SES realm.
- §sliceToImmutable-as-the-canonical-detection-probe — §use-the-method-name-on-an-empty-buffer to detect the proposal's presence; §do-not-feature-detect-by-trying-and-catching; §do-not-feature-detect-by-checking-globalThis-properties.
- §First-explicit-observation in library: **§stage-3-proposal-feature-detection-at-module-load-with-null-prototype-as-impossibility-signal**.

§The-comment-block-on-the-detection (lines 11–13: *"Detects the presence of a immutable ArrayBuffer support in the underlying platform and provides either suitable values from that implementation or values that will consistently deny that immutable ArrayBuffers exist."*) is the canonical specification of the §two-shapes-with-same-keys contract; §the-doc-comment-IS-the-contract (sibling to cycle 257's design-doc-template recurrence and cycle 253's pattern of doc-comment-IS-the-spec).
