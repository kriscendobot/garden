---
event: result
role: weaver+shepherd
dispatcher: endolinbot-steward
dispatch_root: /home/kris/dispatches/weaver--95b4f8 (torn down)
repo: endojs/endo-but-for-bots
pr: 355
---

# Result: weaver-95b4f8 rebase + shepherd-2abcf7 escalation #355

Two-stage dispatch on the same worktree triple:

**Stage 1 — weaver (aeafdf):**
- Sync bot-master: no-op (already at upstream tip from earlier rebases today).
- Rebased PR #355: 4ff473bc → c88cd6996. Some intermediate work + a barrister summary-fix bundle commit retained.
- Weaver terminated mid-CI-watch.

**Stage 2 — shepherd (2abcf7):**
- Watched post-rebase CI to convergence.
- Final state: 6 FAILURE / 12 SUCCESS, mergeStateStatus UNSTABLE, mergeable MERGEABLE.
- All 6 failures real (no flakes, 0 re-runs).
  - 4× test (22.x/24.x × ubuntu/macos): `nominateCandidates` early-return regression in `compartment-mapper/src/import-hook.js` breaking the `path-with-dot` fixture (which exists precisely to lock the opposite behavior, per master commit 3768a3eaa).
  - 1× viable-release: `evasive-transform/src/index.d.ts` TS2304 (`NodePath` moved from inline JSDoc to top-of-file @import; .d.ts generator does not emit a top-level type import for JSDoc-only references).
  - 1× lint: 24 TS errors across PR-added/modified files (bundle-source/tools/trace-merge.js, compartment-mapper/test/integrity.test.js, node-powers.test.js).
- Escalation comment posted: endo-but-for-bots#355 issuecomment-4523163134. Scope (~12 source files, 24 lint errors) beyond shepherd's surgical-fix bounds; recommends fixer dispatch.

Next stage owed (steward decision): fixer dispatch to address the three categories. Holding for kriskowal's call on dispatch authorization since the regression is mirror-PR-side and may warrant a different shape than a normal fixer pass.
