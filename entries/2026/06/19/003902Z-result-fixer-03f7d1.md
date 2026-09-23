---
ts: 2026-06-19T00:38:00Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - pr: 468
  - comment: 3439646219
---

Addressed erights inline comment 3439646219 on
`packages/immutable-arraybuffer/src/lib.js` (subarray `subWrapper` creation).

Added a 28-line multi-line `//` comment immediately before
`const subWrapper = create(getPrototypeOf(this))` explaining in three numbered
points why `create(getPrototypeOf(this))` is sufficient and no pseudo-constructor
call is needed:
1. The right prototype is already `OriginalConstructor.prototype` via
   `getPrototypeOf(this)`, carrying all shim behaviors.
2. The `hiddenTypedArrays` brand registration is added on the next line.
3. No new `reverseBuffers` entry is needed because sub-array shares the parent's
   backing buffer, which was already registered at parent construction time.

Pre-push probes: all pass (yarn format/lint skipped; project not installed in
dispatch worktree, but probes including no-non-ascii-in-source pass cleanly).

Commit: beafa2686 on feat/freezable-typedarray-emulation
Reply posted on comment 3439646219 (reply id 3439653996).

Self-improvement: nothing this time.
