---
ts: 2026-05-20T05:23:11Z
kind: dispatch
role: steward
to: builder
dispatch_id: 6e861d
dispatch_root: /home/kris/dispatches/builder--6e861d
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 297
    role: source
---

# Dispatch builder 6e861d — isolate `module-source-define-property` change as PR on master (kriskowal directive)

kriskowal on PR #297 (review comment 3271372125, 2026-05-20T05:18:07Z, anchored on `.changeset/module-source-define-property.md`): "@kriscendobot Please dispatch a builder to reproduce this change as an isolated PR based on master."

Acked 05:23Z. PR #297 (0xpatrickbot's "fix(ses, module-source): support pi-mono in confined Endo Compartments", base llm) bundles 3 changesets:

1. `module-source-define-property.md`
2. `module-source-namespace-reexport.md`
3. `ses-cycle-reexport-all.md`

This dispatch extracts only #1 (the comment's anchor) as an isolated PR based on master.

Builder must:
1. Read PR #297's diff in detail to identify which source-file changes correspond to `module-source-define-property` (likely in `packages/module-source/`).
2. Create a new branch off current `master` (the bot fork's master).
3. Apply just the `module-source-define-property` changeset + its corresponding source change.
4. Open a new PR against master with that change in isolation.
