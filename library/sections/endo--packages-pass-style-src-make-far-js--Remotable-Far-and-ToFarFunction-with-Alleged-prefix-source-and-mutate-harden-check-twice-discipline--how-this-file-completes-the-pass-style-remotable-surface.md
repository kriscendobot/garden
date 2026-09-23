---
section: Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline
source: endo--packages-pass-style-src-make-far-js
topics: [pass-style, marshal]
status: current
title: How this file completes the pass-style remotable surface
parent: endo--packages-pass-style-src-make-far-js--Remotable-Far-and-ToFarFunction-with-Alleged-prefix-source-and-mutate-harden-check-twice-discipline
---

The pass-style remotable surface now spans four files in the
library:

- cycle 71 — `passStyleOf.js` (dispatch by pass-style; calls
  cycle 134's RemotableHelper for `'remotable'` values)
- cycle 87 — `error.js` (three sections — error passability)
- cycle 134 — `remotable.js` (the *validator*; what counts as a
  remotable; tag-record inheritance; confirmRemotableProtoOf
  recursive walk)
- **cycle 136 (this cycle)** — `make-far.js` (the *constructor*;
  Remotable/Far/ToFarFunction; produces what remotable.js
  validates)

Together they form *the pass-style remotable surface*: how a
remotable is constructed, how it's recognized, what its prototype
chain looks like, and how its iface is named (with the
allegation-not-attestation prefix discipline).
