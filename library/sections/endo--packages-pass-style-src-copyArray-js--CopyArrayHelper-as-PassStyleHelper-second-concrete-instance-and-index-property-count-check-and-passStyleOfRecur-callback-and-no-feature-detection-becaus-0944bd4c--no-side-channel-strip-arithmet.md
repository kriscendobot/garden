---
title: §No side-channel-strip arithmetic difference is itself the signal
source-slug: endo--packages-pass-style-src-copyArray-js
section-slug: CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/copyArray.js
source-repo: endojs/endo
source-path: packages/pass-style/src/copyArray.js
source-author: Endo project (collective)
total-lines: 38
ingest-cycle: 262
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-copyArray-js--CopyArrayHelper-as-PassStyleHelper-second-concrete-instance-and-index-property-count-check-and-passStyleOfRecur-callback-and-no-feature-detection-because-Array-is-universal
---

Cycle 260 byteArray: `ownKeys(candidate).length === 0` — no own keys allowed.
Cycle 262 copyArray: `ownKeys(candidate).length === len + 1` — exactly `len + 1` own keys allowed.

§The-`= 0`-vs-`= len + 1`-arithmetic-difference encodes §the-structural-difference-between-the-two-pass-styles:

- §byteArray-is-a-canonical-bag-of-bytes-with-no-attached-metadata; §any-own-key-IS-a-side-channel.
- §copyArray-is-an-ordered-sequence-of-passable-values-with-a-`length`-property; §`length`-IS-the-required-metadata + §index-keys-ARE-the-required-payload-keys + §any-other-key-IS-a-side-channel.

§Two-cycles-with-ownKeys-length-check-with-pass-style-specific-arithmetic (260 zero + 262 len+1); §the-arithmetic-IS-the-pass-style's-shape-signature; §first-explicit-observation in library.
