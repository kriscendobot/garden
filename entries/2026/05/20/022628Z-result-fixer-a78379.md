---
ts: 2026-05-20T02:26:28Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/05/20/020226Z-result-judge-907068.md
  - https://github.com/endojs/endo-but-for-bots/pull/306
---

# Fixer result: PR #306 must-fix-loop (judge round, code panel)

**Originating dispatch root**: `/home/kris/dispatches/fixer--a78379/`
**Job**: `journal/jobs/claimed/endolinbot--20260520T020512Z--5004d3--daemon-persona-formula-graph-edge.md`
**PR**: endojs/endo-but-for-bots#306 (`feat/daemon-capability-persona`).
**Pre-fix head**: `954e0003b` (rebased onto `f4a8035a6`, the post-judge typecheck-repair commit landed by an autonomous fixer between the judge round and this dispatch).
**Post-fix head**: `b6f332621`.

## Must-fix item addressed

The judge's lone `must-fix-loop` disposition was the formula-graph dependency gap on the `handle` formula: `extractLabeledDeps`'s `case 'handle'` arm in `packages/daemon/src/daemon.js:575` returned only `[['agent', formula.agent]]`, omitting each `epithets[*].principal`. The formula graph drives retention and GC; principals named only through a downstream delegate's persona chain were invisible to the graph and could be collected by the GC sweep, after which any deeper handle's `epithets()` call would fail.

## Commit landed

`b6f332621` — fix(daemon): handle formula deps include epithets[*].principal (judge #306 must-fix)

Two changes:

1. `packages/daemon/src/daemon.js`: extended the `case 'handle'` arm to push one labeled dep per `epithets[*].principal` (labels `epithet-${i}`), keeping the existing `['agent', formula.agent]` dep.
2. `packages/daemon/test/endo.test.js`: added one regression test in the `persona:` block after the existing recursive-propagation test, asserting the structural invariant that after dropping the intermediate agent's pet name and letting the GC sweep run, the deeper handle's chain still resolves end-to-end and each principal remains a live, queryable Handle.

## Test results

Persona block: 9/9 pass after the fix (including the new regression test).

Notes on the regression test's fails-closed strength: in a single-node chain created via `provideHost` / `provideGuest`, the standard `hostHandle` / `hostAgent` deps on `host` and `guest` formulas already retain the immediate ancestor, so the bug does not surface in this specific test scenario without an additional setup that defeats those deps (cross-node principals, or a refactor that detaches the agency lineage from the epithet lineage). The brief explicitly authorized the "chain still resolves" structural form as sufficient when triggering an explicit collection is not available. The regression test codifies the expected behavior so any future refactor that re-introduces the gap fails closed under the chain-still-resolves assertion path.

## Pre-push-gates summary

Ran `bash garden/skills/pre-push-gates/pre-push-gates.sh --summary` from `project/`:

- `yarn format`: pass after auto-fixing 8 paths repo-wide. Of those, two `@param` lines were added to `packages/daemon/src/daemon.js` for unrelated functions (`makeUnconfined`, `formulateLazy`) by `yarn lint --fix`; both reverted because they are pre-existing repo-state, not PR-diff in scope. The other six auto-fixed paths (`host.js`, `better-sqlite3-xs.js`, `bus-daemon-rust-xs.js`, `bus-xs-daemon-polyfills.js`, `evasive-transform/src/index.js`, `ses/src/compartment.js`) were all reverted as repo-wide pre-existing state.
- `yarn lint --fix`: fail on repo-wide files. Diff-scoped lint (run via `yarn lint:eslint src/daemon.js test/endo.test.js`) returned no errors after fixing a single `no-unused-vars` for the new test's `jarvis` variable (renamed the throwaway assignment to a bare `await`).
- Probes: `no-inline-import-jsdoc`, `security-md-hash-uniform`, `sentence-per-line-md` all fail on pre-existing repo files; none relate to this fix's diff.
- `yarn typecheck`: skip (no `typecheck` script at the project root). The daemon package's `yarn lint:types` reports two pre-existing `src/host.js` errors and one transitive `@libp2p/utils` resolution error; all three are present on the clean tree at `f4a8035a6` per a `git stash` / re-run comparison.

PR-scoped findings: none after the two `@param` reverts and the `jarvis` rename.

## Push and CI

`git push origin HEAD:feat/daemon-capability-persona` succeeded after rebasing onto `f4a8035a6` (origin had moved during the dispatch via an autonomous typecheck-repair commit; rebase was conflict-free).

CI kicked off at the new head; all 25 checks pending at result-write time. The steward will re-dispatch the judge when CI is green at `b6f332621`, per `skills/pr-creation-flow/SKILL.md` § Jury-fixer loop.

## Self-improvement

`pre-push-gates`'s `yarn lint --fix` stage rewrites repo-wide files including pre-existing diff-unrelated code, then `git add -A`-stages everything. A fixer focused on the diff has to manually revert the unrelated reformats one file at a time. The brief flagged that the gates lack a diff-only filter; this dispatch is one data point for that scoping work. Logging here rather than to liaison because the steward's prior judge dispatch already captured the same observation in the panel verdict's `drop`-dispositioned finding.
