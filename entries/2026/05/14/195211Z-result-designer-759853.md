---
ts: 2026-05-14T19:52:11Z
kind: result
role: designer
project: endo
refs:
  - entries/2026/05/14/194407Z-dispatch-liaison-759853.md
---

# Result: ses-top-level-await design drafted

Output: `project/designs/ses-top-level-await.md` (single file, no commit, no
branch, no PR per dispatch instructions). The dispatch root's `project/`
worktree is detached on `endojs/endo@master`; the file lives there until the
liaison preserves it for maintainer review (typically by copying it to
`journal/projects/endo/drafts/` per the lifecycle in that directory's
README).

## Document shape

The design leads with the test suite, as instructed. The test-suite section
is a single 17-row table indexed against test262's
`language/module-code/top-level-await/` directory; each row names a fixture
shape, its test262 equivalent, and the SES-side assertion. The remaining
shapes (rows 13 through 17) are SES-shim-specific regressions covering
`importNow`'s synchronous-rejection guard, the
`__moduleIsAsync__` round-trip through `bundle-source`, the no-regression
case for purely-sync modules, and the analyzer's syntax acceptance / nested-
function rejection pair.

After the test suite, the document covers:

- Static analysis (one Babel visitor flips `__moduleIsAsync__` when an
  `AwaitExpression` has no function parent).
- Module-instance contract additions (`asyncEvaluation`,
  `topLevelCapability`, `asyncParentModules`, `pendingAsyncDependencies`,
  `cycleRoot`).
- Linker bookkeeping (post-order DFS pass that sets `[[CycleRoot]]` via
  Tarjan low-link).
- Evaluation procedure with a mermaid sequence diagram showing how a sync
  root waits on an async dep's `[[TopLevelCapability]]`.
- `compartment.importNow` guard (synchronous TypeError on any reachable
  async dep).
- Bundle-source coupling: the `endoScript` format gets an explicit error;
  `endoZipBase64`, `nestedEvaluate`, `getExport` round-trip the flag.

## Alternatives considered and open questions

Three alternatives recorded: reject TLA outright (rejected; npm uses it),
transform-away (rejected; loses tick semantics), synchronous SAB block
(rejected; not portable). Six open questions surfaced for the maintainer:
native compartment passthrough, dynamic-import-during-suspension test
coverage, virtual-source async, importNow diagnostic shape, endoScript
fallback policy, cycle-root rediscovery on re-link.

## Source material consulted

- SES source: `module-instance.js`, `module-link.js`, `module-load.js`,
  `compartment.js` (the synchronous `instance.execute()` bottom-up walk at
  module-instance.js:401 is the load-bearing contract this design
  amends).
- module-source: `transform-analyze.js`, `transform-source.js`,
  `babel-plugin.js`, `parse-babel.js`, `DESIGN.md`, `REWRITE.md`.
- bundle-source: `bundle-source.js` shape; the four formats listed in
  `SUPPORTED_FORMATS`.
- test262 local fixtures at
  `packages/test262-runner/test262/test/language/module-code/top-level-await/`,
  in particular `await-expr-resolution.js`,
  `module-import-resolution.js` + `_FIXTURE.js`,
  `module-import-rejection.js`, `top-level-ticks.js`,
  `module-self-import-async-resolution-ticks.js`.
- test262 directory listing fetched via WebFetch for the broader shape
  table (`dfs-invariant.js`, `pending-async-dep-from-cycle.js` covered).
- Babel TLA plugin via WebFetch (`@babel/plugin-syntax-top-level-await`):
  confirmed pure syntax enablement, no transform; bundlers (rollup, webpack
  5) carry the transformation. The endo module-source analyzer must do its
  own transformation because SES is not a bundler.
- 262 cyclic-module-records evaluation algorithm: the structural detail
  came primarily from the test262 fixtures' `info:` comment blocks, which
  quote the spec verbatim; the tc39 spec page fetch returned only a table
  of contents, so the algorithm summary in the design body is anchored to
  the test262 quoted excerpts rather than to a direct spec citation. This
  is recorded as a minor limitation; a follow-up reviewer who wants to
  pin to specific 262 section numbers can do so without changing the
  design's substance.

## Mermaid diagrams

One mermaid `sequenceDiagram` in the evaluation-procedure section showing
User -> Compartment -> Linker -> Root -> Async-dep flow, including the
`pendingAsyncDependencies` decrement on the parent and the
`topLevelCapability.promise` resolution. A second diagram for the
`[[CycleRoot]]` SCC discovery was considered and elided as
text-conveyable.

## Definition-of-done check

- Single file at `project/designs/ses-top-level-await.md`: yes.
- Project's metadata table populated, dates absolute: yes (the project
  has no `designs/CLAUDE.md`, so the table format follows the existing
  sibling design under `packages/compartment-mapper/designs/` and the
  journal's `drafts/exo-import.md` shape).
- Open questions explicit: yes, six of them.
- No commit, no branch, no PR: confirmed.
- Result entry referencing originating dispatch: this file.

## Discrepancy with dispatch entry

The dispatch entry path named in the dispatch prompt
(`entries/2026/05/14/194407Z-dispatch-liaison-759853.md`) does not exist
in the journal worktree at dispatch time. The five-line procedural list
in the dispatch prompt itself was sufficient to act on. No followup
needed unless the liaison wants the dispatch entry committed
retroactively, in which case the steward's next cycle catches it.

Self-improvement: nothing this time.
