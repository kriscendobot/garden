---
ts: 2026-05-20T05:30:40Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo
worktree: dispatches/builder--6e861d/project
---

Isolated the `module-source-define-property` change from PR #297 (`pc-test-pi-ses-compat` branch) as a master-based standalone PR per kriskowal's request on PR #297 review comment 3271372125 (2026-05-20T05:18:07Z).

Identified mapping. PR #297 commit `8dba161f2` is a clean per-commit isolation of the change. Its tree:

- `.changeset/module-source-define-property.md` (28 lines, new)
- `packages/module-source/src/transform-analyze.js` (preamble emits `$h_defineProperty` instead of `Object.defineProperty`; functor signature gains the `defineProperty:` field)
- `packages/module-source/src/hidden.js` (adds `HIDDEN_DEFINE_PROPERTY`)
- `packages/module-source/test/fixtures/format-preserved.txt` (golden updated to reflect new preamble)
- `packages/module-source/test/module-source.test.js` (new test `hoisted function name survives Object import`; initializer signature gains `defineProperty: Object.defineProperty`)
- `packages/ses/src/module-instance.js` (`makeModuleInstance` passes `defineProperty` from `commons.js` through the functor record)
- `packages/compartment-mapper/src/bundle-mjs.js` (bundle output emits `defineProperty,` in the functor call)

Procedure. Branched off `origin/master` at `9213d2c56`. `git cherry-pick 8dba161f` conflicted only in `packages/module-source/test/module-source.test.js` because commit `8dba161f`'s parent contains the namespace-reexport changeset's new test (`export namespace from`); resolved by discarding that test (it belongs to a sibling changeset) and keeping the new `hoisted function name survives Object import` test. Resulting head: `afe6faec6`.

Verification. `yarn install`, `yarn workspace @endo/module-source lint`, `yarn workspace ses lint`, `yarn workspace @endo/compartment-mapper lint` all clean (single pre-existing JSDoc warning in `ses/src/compartment.js`). `yarn workspace @endo/module-source test` 52 pass; `yarn workspace ses test` 501 pass + 2 known failures + 2 skipped; `yarn workspace @endo/compartment-mapper test` 879 pass + 6 known failures. Regression evidence: reverted the source files (kept the test); the new test fails with `TypeError: Object.defineProperty is not a function`, confirming the test is load-bearing.

Pre-push gates. Workspace-wide `yarn format` clean. Workspace-wide `yarn lint --fix` auto-fixed two unrelated files (`packages/evasive-transform/src/index.js`, `packages/ses/src/compartment.js`); discarded those since they are out of scope for this PR. Diff-scoped probes (`no-inline-import-jsdoc`, etc.) all pass on my diff. The `security-md-hash-uniform` probe fails on pre-existing divergence in `packages/{immutable-arraybuffer,bytes,hex,panic}/SECURITY.md` (workspace-wide, not in my diff).

Push and PR. `git push -u origin HEAD:fix/module-source-define-property` (sha `afe6faec6`). `gh pr create -R endojs/endo-but-for-bots --base master --head fix/module-source-define-property --draft` opened as PR #311 <https://github.com/endojs/endo-but-for-bots/pull/311>. CI all-queued at sample time (Browser Tests, lint, build, zizmor, node 18/20/22/24 test matrix, test-async-hooks, cover, test262, test-hermes, check-action-pins, viable-release, test-xs, test-ocapn-python).

Cross-cutting observations.

1. The maintainer's three-changeset split on PR #297 carved the work cleanly along commit boundaries. Each of the three fixes (this one, namespace-reexport, cycle-reexport-all) was one commit, and that commit was self-contained at the source-file level. The only friction was a test-file conflict caused by ordering between the sibling commits' new tests; cherry-pick into a master-based branch resolved with a single hunk discard. This pattern (one commit per changeset, sibling commits' tests cleanly separable) is the cheap-to-isolate shape; future bundled PRs that follow it can be ferried as independent PRs with the same procedure.

2. The `pre-push-gates` skill's stages 1 and 2 (`yarn format`, `yarn lint --fix`) run workspace-wide, so on a multi-package repo with pre-existing format or lint drift the gate auto-fixes unrelated files and stages them into the calling role's commit. Per the task instruction ("diff-only scoping"), I discarded those before pushing. A future improvement to the gate would be to scope the auto-fix to the diff-touched packages (e.g., compute the union of packages from `git diff origin/master...HEAD --name-only` and run `yarn workspace <name> format` / `lint --fix` per package). The probe stage 3 is already diff-only-scoped for several probes; stages 1 and 2 are not.

Self-improvement: nothing this time. The pre-push-gates auto-fix-on-unrelated-paths observation is a candidate for a `notes-from-the-field` row on `skills/pre-push-gates/SKILL.md`, but the right authoring path is a gardener follow-up rather than a builder edit, and the observation can sit in this result entry for the orchestrator to route.
