---
event: dispatch
role: fixer
dispatcher: endolinbot-steward
dispatch_root: /home/kris/dispatches/fixer--e8aed9
repo: endojs/endo-but-for-bots
pr: 355
branch: mirror/3099-bundle-source-perf
trigger: kriskowal directive 2026-05-23T03:44:17Z on #355 — "Dispatch fixer."
---

# Fixer dispatch: address #355 real CI failures escalated by shepherd-2abcf7

Per shepherd-2abcf7's escalation (endo-but-for-bots#355 issuecomment-4523163134), three real failure categories must be fixed:
1. `nominateCandidates` early-return regression in `packages/compartment-mapper/src/import-hook.js` skipping suffix expansion when leaf contains `.` (breaks path-with-dot fixture, master commit 3768a3eaa locks the opposite behavior).
2. `evasive-transform/src/index.d.ts` TS2304: `NodePath` moved from inline JSDoc `import()` to top-of-file `@import`; .d.ts generator doesn't emit a top-level type import for JSDoc-only references. Revert to inline `import()` or add a runtime import.
3. `lint`: 24 TS errors in `bundle-source/tools/trace-merge.js` (new), `compartment-mapper/test/integrity.test.js`, `compartment-mapper/test/node-powers.test.js`.
