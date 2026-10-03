I finished the Phase-2 `EndoHost.makeFromTree` `layout`/`entry` work on the existing branch (the capture and canonical-mount commits were already there) and opened draft PR **endojs/endo-but-for-bots#1419**. Focused tests, type-check, lint and formatting pass, except that the XS-worker path was not run locally.

**Branches and PR**
- **Head:** `llm-confined-application-makers-p2` at `19328f0d28744028faab1cdc19ca99a9a41c8fa4`. It was only on the kriscendobot fork (`fda4429685`), so I pushed it to both that fork and `endojs/endo-but-for-bots`, keeping the stack in one repo.
- **Base:** #1417 is still open as a draft. `ensure-pr.sh` refused a base branch that can still move, so I made a fixed snapshot of #1417's head (`0bdf8951cb`) as `llm-confined-application-makers-p1-0bdf895` and used that as the base. If #1417 changes, this base needs to be moved forward.
- **PR #1419:** https://github.com/endojs/endo-but-for-bots/pull/1419. It is draft, with no gauntlet run. The body carries `<!-- garden-job: build-confined-application-makers-p2-split-20261003 -->`, says it stacks on #1417, and follows the repo's PR template. `--find-only` found no earlier PR before I opened it.
- `ensure-pr.sh` reported that it found no board record for `build-confined-application-makers-p2-split-20261003`, so the PR is not recorded against that job. That job key is the one the spec told me to use.

**Commits added**
- `6eb690ec50` feat(daemon): makeFromTree layout and entry options
- `19328f0d28` chore(daemon): changeset for makeFromTree node_modules layouts

**What changed**
- **Options:** `makeFromTree` takes `layout` (default `'detect'`; also `'archive'`, `'node-modules-with-map'`, `'node-modules-scan'`, and `'package'`, which is refused until `makeFromPackage` exists) and `entry`, which only applies to `node-modules-scan`.
- **Formula:** the formula stores only the requested layout. Each time the daemon rebuilds the application, it detects or checks the layout again.
- **Execution:** the two `node_modules` layouts are packed by the daemon into temporary archive bytes and run through the worker's existing `makeArchive`. No worker method was added, and the `archive` layout still takes its old route.
- **Detection:** it only reads the tree root with `lookup`/`text`. That matters because endo-fs-exec tree views have no `has` method.
- **Rejection:** a tree with no layout, including a Yarn Plug'n'Play install, is rejected before anything is created, with an error naming the layouts looked for.
- **Inspection:** `getFormula` now reports `layout`, `entry`, `treeKind` (snapshot or mount) and `runningAs` (the layout currently in use). The chat formula view lists these.
- **Old formulas:** saved formulas without a `layout` field still run as `'archive'`.

**Changed paths:** `.changeset/daemon-make-from-tree-layouts.md`, `packages/daemon/src/{tree-layout.js (new), capture-node-modules.js, manager.js, host.js, interfaces.js, formula-record.js, types.d.ts}`, `packages/daemon/test/endo.test.js`, `packages/spaces-util/src/formula-view-registry.js`.

**Verification**
- **Daemon type-check** (`tsc` in `packages/daemon`): passes.
- **Repo-root `tsc -p tsconfig.json`:** the only errors were in leftover test fixture files under the ignored `packages/daemon/tmp/` folder; I deleted them.
- **eslint** on the changed files: 0 errors, warnings only. My first `eslint --fix` run deleted unrelated `eslint-disable` comments; I put them all back.
- **prettier --check:** clean.
- **`endo.test.js`** with matches for makeFromTree, getFormula, stageTree and inspector: 20 passed. That includes the 8 new tests (hoisted npm-style tree, pnpm-style links loading a package once, a pre-generated map, `entry`, Plug'n'Play rejection, a `../outside` path, mismatched options, and mount-vs-snapshot after a restart) plus the existing Phase 7 tests.
- **`capture-node-modules`, `formula-type` and `xs-worker-facet` tests:** 27 passed.
- **endo-fs-exec `test/daemon.test.js`:** 2 passed, but only after I temporarily shortened its socket path (the long worktree path breaks the default one); I reverted that change.
- **chat `formula-view-registry` test:** 10 passed.

**Follow-ups**
- **XS path not run:** there is no `endor` binary here. The new tests run on whichever worker kind the suite uses, so `yarn test:rust` would cover it.
- **pnpm workspace-link cases** from the design's test plan are not covered; they need a real pnpm install.
- **Result text** naming the detected layout belongs to the Phase 5 MCP tools.
- **Local environment:** this host's node is v22, but the shared `better-sqlite3` was built for v24. In this job's project checkout only, I replaced that file with a v22 build, without changing the other checkouts that share it.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-confined-application-makers-p2-makefromtree-20261003.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 200 tokens (14451103 cached reads)
- Output: 61769 tokens
- Cost: $5.7273606000000035
- Wall-clock: 839s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
