# mirror-endo-2780-cache-globals-gauntlet — tada report

## Summary

Mirrored upstream **endojs/endo#2780** ("wip Cache globals") onto `endojs/endo-but-for-bots` based on a frozen master anchor, then ran the full gauntlet (clean → panel review → un-draft).

## Fork PR

- **Fork PR:** https://github.com/endojs/endo-but-for-bots/pull/764
- **Frozen base SHA:** `master-2708cac` (snapshot of upstream `endojs/endo` master)
- **Head branch:** `mirror/endo-2780-cache-globals`

## Upstream Reference

- **Upstream PR:** https://github.com/endojs/endo/pull/2780
- **Upstream status:** OPEN, DRAFT / WIP (base `master`, head `weizman/cache-globals`)
- **Upstream HEAD:** `5663a356052c49033a37941f860bedf1d8121c2f`

## Gauntlet outcome

| Stage | Result |
|-------|--------|
| Build (PR open) | ✅ PR #764 opened as draft, base `master-2708cac` |
| CI | ✅ All 15 checks pass (lint, build, zizmor, test ×4, cover, test262 ×2, test-xs, test-ocapn-python, check-action-pins, viable-release) |
| Cleaner | ✅ No cleanup needed (CI green) |
| Panel review | ✅ APPROVED — no must-fix items. Mirror faithfully reproduces upstream diff re-based onto frozen anchor. Added `/* global globalThis */` JSDoc annotations as helpful documentation. Advisory: none. |
| Un-draft | ✅ PR #764 marked ready for review at https://github.com/endojs/endo-but-for-bots/pull/764 |

## Diff summary

3 files changed in `packages/compartment-mapper/src/`:
- `import-hook.js` — `const { URL } = globalThis;`
- `node-powers.js` — `const { Function, Promise } = globalThis;`
- `parse-cjs-shared-export-wrapper.js` — `const { Proxy, Set, URL } = globalThis;`

Each caches a global intrinsic at module-init time so later mutation of `globalThis` cannot subvert it. All cached values are actually used within their respective modules.

## Notes

- Upstream #2780 remains **WIP/draft**. This mirror faithfully reproduces its current state. If upstream changes, the fork PR can be rebased and re-reviewed.
- No scope beyond the mirror's premise was added or expected per the job spec.
