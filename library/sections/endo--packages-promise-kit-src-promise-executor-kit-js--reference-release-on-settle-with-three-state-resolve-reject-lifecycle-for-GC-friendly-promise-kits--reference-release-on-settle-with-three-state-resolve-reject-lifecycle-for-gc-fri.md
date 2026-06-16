---
source: packages/promise-kit/src/promise-executor-kit.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/promise-executor-kit.js
source_path: packages/promise-kit/src/promise-executor-kit.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
topics:
  - patterns
  - async-flow
genre: §endo-source-comment-fragment
cycle: 173
lane: chat
status: current
title: Reference-release on settle with three-state resolve/reject lifecycle for GC-friendly promise kits
parent: endo--packages-promise-kit-src-promise-executor-kit-js--reference-release-on-settle-with-three-state-resolve-reject-lifecycle-for-GC-friendly-promise-kits
---

> §Chat-lane after cycle 172's designs-lane. §Endo-source-
> comment-fragment genre. **§Sibling-to-cycle-152's-memo-
> race.js** (both in @endo/promise-kit) and §used-by-cycle-
> 171's-stream-substrate (makeStream uses makePromiseKit
> per-cell).

`packages/promise-kit/src/promise-executor-kit.js` (55
lines) exports a single function: `makeReleasingExecutorKit`.
The single most structurally interesting move is the
**§three-state-internal-reference-lifecycle**: each of
`internalResolve` and `internalReject` traverses `undefined`
(initial) → `function` (executor captured) → `null`
(settled, references released). The §reference-release-on-
settle discipline lets the underlying promise become GC-
eligible immediately after settlement.
