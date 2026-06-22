---
kind: dispatch
role: builder
host: endolinbot
posture: liaison
short_id: 840a02
dispatch_root: dispatches/builder--840a02
repo: endojs/endo-but-for-bots
branch: master
pr_number: null
model: sonnet
---

Reconstruct a draft PR against `endojs/endo-but-for-bots:master` containing
the **passable byte arrays** slice of the already-merged work in PRs #468
and #473, suitable for a boatman to later ferry to `endojs/endo`.

Source PRs (both MERGED into endo-but-for-bots/master):
- #468 `feat/freezable-typedarray-emulation` —
  feat(immutable-arraybuffer): freezable TypedArray emulation per #449 design
  (merged 2026-06-19T00:44:59Z)
- #473 `feat/pass-style-byte-array-plain-frozen-validation` —
  feat(pass-style): validate plain frozen Uint8Array on immutable buffer
  as byteArray (merged 2026-06-19T05:16:10Z)

The passable-byte-arrays feature combines the two: an immutable buffer
that can carry a Uint8Array view + pass-style accepting that view as
the `byteArray` passStyle. The boatman will later land this in
endojs/endo via identity-switched ferry from a credentialed host.
