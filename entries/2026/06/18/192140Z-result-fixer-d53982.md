---
ts: 2026-06-18T19:21:00Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs: []
---

Applied erights's inline suggestion on PR #468
(`endojs/endo-but-for-bots`) to simplify the `defineProperty` descriptor
for the concrete TypedArray constructor replacements in
`packages/immutable-arraybuffer/src/shim.js`.

Changed `{ value: PseudoCtor, writable: true, enumerable: false, configurable: true }`
to `{ value: PseudoCtor }` so the call leaves existing descriptor attributes
untouched rather than restating them.

Commit: `58d625b14`. Pushed to `feat/freezable-typedarray-emulation`. Replied
on inline comment 3438353187 citing the SHA.

Pre-push-gates: `no-pull-citations` probe failed on pre-existing citations in
`packages/immutable-arraybuffer/designs/freezable-typedarray.md` (added by
prior commits in this branch; not introduced by this fix). All other probes
passed. The design file's PR citations are a pre-existing condition; they are
not from any line this dispatch changed.

Self-improvement: nothing this time.
