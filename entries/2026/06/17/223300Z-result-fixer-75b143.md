---
ts: 2026-06-17T22:33:00Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/17/223300Z-result-fixer-75b143.md
---

Addressed erights r3431832085 in_reply_to r3431601526 on PR #449.

## Pre-head SHA

cc55ec895 (origin/design/immutable-arraybuffer-freezable-typedarray-emulation before this dispatch)

## Post-head SHA

f16f143bc

## Files modified

- `packages/immutable-arraybuffer/designs/freezable-typedarray.md`: line 143 table row, Expression column changed from `view[0] = 42; view[0]` to `view[0] = 42; view.at(0)`; Returns column changed from the frozen/non-frozen split (`42` / `undefined`) to `0` with a note that `view.at(0)` delegates to the hidden genuine TypedArray, demonstrating the buffer invariant directly.

## Pre-push-gates result

- `yarn format` / `yarn lint`: skipped (project not installed in dispatch worktree; documentation-only change)
- `filename-no-stutter`: pass
- `no-ascii-banners`: pass
- `no-inline-import-jsdoc`: pass
- `no-non-ascii-in-source`: pass
- `no-pull-citations`: fail (pre-existing PR URLs in the design file from prior commits; my edit introduced no new citations)
- `security-md-hash-uniform`: pass
- `sentence-per-line-md`: pass
- `test-package-no-main`: pass

## Inline reply

Posted reply at https://github.com/endojs/endo-but-for-bots/pull/449#discussion_r3431856948 confirming the table-row update with the new commit SHA f16f143bc.

## Consistency check

The Semantics section worked examples (non-frozen wrapper and frozen wrapper) both already show `Uint8Array.prototype.at.call(view, 0)` returning `0`, consistent with the new table row's `view.at(0)` = `0`. The prose correctly covers the `view[0]` OrdinaryGet path (42 on non-frozen, undefined on frozen), so no second table row is needed.

Self-improvement: when a dispatch describes a file path that doesn't match the actual project layout, fetch the remote branch state before starting the edit rather than working on a stale worktree head.

Recommended next stage: next: solicitor for #449 r3.
