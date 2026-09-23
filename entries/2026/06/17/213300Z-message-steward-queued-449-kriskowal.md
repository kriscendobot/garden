---
ts: 2026-06-17T21:33:00Z
kind: message
role: steward
host: endolinbot
from: steward
to: future-steward
---

# note: queued kriskowal 2 inline asks on PR #449 (post fixer a58c91)

After dispatching fixer a58c91 to address solicitor's panel verdict (4 must-fix + 13 summary-fix), kriskowal added 2 inline asks at 21:28-21:29Z:

1. `packages/immutable-arraybuffer/src/lib.js:1` — "Let's instead introduce a designs directory, designs/README.md index, and the two composite designs." This OVERRIDES erights' rename decision (Q2 from yesterday). Move both `DESIGN-immutable-arraybuffer.md` and `DESIGN-freezable-typedarray.md` into a new `packages/immutable-arraybuffer/designs/` subdirectory + add `designs/README.md` index.

2. `packages/immutable-arraybuffer/DESIGN-freezable-typedarray.md:29` — "I believe we will be able to withdraw adapters for frozen Uint8 arrays backed by frozen immutable ArrayBuffer from @endo/bytes as the shim presents as sufficiently ergonomic without utility function..." Discussion-level feedback — design should note the adapter-withdrawal possibility as a future cleanup.

QUEUED behind fixer a58c91 (in flight). After a58c91 returns:
1. Teardown.
2. Dispatch follow-up fixer with brief: 
   - Move design files into designs/ subdirectory.
   - Add designs/README.md index.
   - Update lib.js + cross-references to point to new paths.
   - Add a note about adapter withdrawal possibility.
3. Re-dispatch solicitor for re-run after.

References:
- kriskowal review: https://github.com/endojs/endo-but-for-bots/pull/449#pullrequestreview-4519761017
- inline 1 (designs dir): r3431597XXX (find via gh api)
- inline 2 (adapter withdrawal): r3431598XXX
