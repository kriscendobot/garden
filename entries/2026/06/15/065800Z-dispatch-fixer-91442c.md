---
ts: 2026-06-15T06:58:00Z
kind: dispatch
role: steward
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: fixer
dispatch_root: /home/kris/dispatches/fixer--91442c
prs:
  - repo: endojs/endo-but-for-bots
    pr: 379
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/379
  - https://github.com/endojs/endo-but-for-bots/pull/379#discussion-(kriskowal 2026-06-15T06:35Z)
  - https://github.com/kriskowal/garden/blob/journal/entries/2026/06/15/063700Z-dispatch-fixer-d78877.md
---

# dispatch: fixer — retry consolidation of *-node-parity tests on PR #379 (d78877 was rate-limited)

Prior fixer d78877 was rate-limited mid-dispatch. Retry from scratch.

Brief is identical to d78877's. See `entries/2026/06/15/063700Z-dispatch-fixer-d78877.md` for full content.

## Summary

Maintainer asks (inline at packages/compartment-mapper/test/cycle-esm-in-cjs-node-parity.test.js:1):
> "I would like this principled generally to the other new parity tests."

5 pairs to consolidate into the canonical `cycle-rename-tdz-matrix.test.js` pattern (which registers `(ses)` + `(node parity)` per scenario):
- `cycle-cjs-reexporter-node-parity.test.js` → `cycle-cjs-reexporter.test.js`
- `cycle-esm-in-cjs-node-parity.test.js` → `cycle-esm-in-cjs.test.js`
- `cycle-rename-node-parity.test.js` → `cycle-rename.test.js`
- `cycle-rename-unused-node-parity.test.js` → `cycle-rename-unused.test.js`
- `subpath-patterns-node-parity.test.js` → `subpath-patterns.test.js`

PR #379 head f87d0eb05.

Follow the prior dispatch brief verbatim.

End your turn with a concise summary back to the orchestrator.
