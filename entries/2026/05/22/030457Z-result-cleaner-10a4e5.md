---
ts: 2026-05-22T03:04:57Z
kind: result
role: cleaner
project: endo-but-for-bots
worktree: dispatches/cleaner--3a8f98/project
refs:
  - entries/2026/05/22/020348Z-dispatch-liaison-e570a4.md
---

# Cleaner result: module-source reassignment-publish coverage on PR #353 (endojs/endo#2982)

PR `endojs/endo-but-for-bots#353`, branch `fix/bundle-source-export-let-2982`. Pre-cleaner head `10ac18971`; cleaner head `66d67684c` (one commit added). CI on the cleaner head: all 18 checks green (browser-tests, build, lint, cover, test 22.x/24.x ubuntu+macos, test-async-hooks 18/22, test-hermes, test-ocapn-python, test-xs, test262 22.x/24.x ubuntu, viable-release, zizmor, check-action-pins). PR remains DRAFT; un-draft is the judge's.

## Coverage

Targeted package: `@endo/module-source` (the babel-plugin where the fix landed). The builder's fix touched `packages/module-source/src/babel-plugin.js` (the AST rewriter; new AssignmentExpression / UpdateExpression visitors that wrap reassignments in a `$h_live.NAME(...)` publish call) and `packages/bundle-source/test/let-export.test.js` (un-`.failing` of the integration regression test).

Baseline `c8` coverage on `packages/module-source/src/`:

```
All files             |    88.9 |    87.78 |   94.87 |    88.9
 babel-plugin.js      |   93.12 |     89.2 |     100 |   93.12 | uncovered: 355-356,503-507,560-570,659-666,807-814,818-828,863
```

Post-cleaner coverage:

```
All files             |    89.5 |    88.23 |   94.87 |    89.5
 babel-plugin.js      |   94.04 |    89.77 |     100 |   94.04 | uncovered: ...549,568-570,807-814,818-828,863
```

Net: `babel-plugin.js` 93.12 to 94.04 statements; overall package 88.9 to 89.5. The previously-uncovered ranges 503-507 (UpdateExpression guards) and 659-666 (the new class-reassignment `liveSoftened.set`) are now reached. The remaining uncovered ranges (importMeta hook, ImportNamespaceSpecifier branch, ExportNamedDeclaration specifier sub-branches, default-case throws) are pre-existing on code paths the PR did not touch.

## Tests added

Four new tests in `packages/module-source/test/module-source.test.js`, all using the existing `initialize` helper that drives the transformed program through a Compartment with concrete `liveVar` / `onceVar` updaters and records each publish call in `log`. The plain `let` reassignment was already covered by the pre-existing `export named` test (line 219); the four added cases close the remaining declaration-kind / update-shape matrix:

1. `var reassignment publishes through liveVar` — top-level `export var x = 'initial'; x = 'updated';` exercises the `AssignmentExpression` instrumentation against the `var` declaration's softened-local path; asserts both the publish log and the resulting namespace value.
2. `function reassignment publishes through liveVar` — `export function fn() {...} fn = () => 'updated';` exercises the function-declaration softened-local path; asserts the runtime-callable surface (`namespace.fn()`).
3. `let postfix and compound reassignment publish through liveVar` — exercises the `UpdateExpression` visitor for `++` / `--` (prefix and postfix) and the compound-assign `+=` path; asserts each individual update lands as a log entry.
4. `class reassignment publishes through liveVar (endojs/endo#2982 follow-up)` — marked `test.failing`; see § Gap below.

Each of the three passing tests is regression-evidence-load-bearing: with the publish-call rewrite commented out in the AssignmentExpression visitor, all three fail (alongside the existing `export named` and `export class and let` tests), confirming the tests fail when the instrumentation is broken. With the rewrite restored, all three pass.

## Gap surfaced (regression evidence; not papered over)

The fix has one remaining hole the cleaner uncovered while building the coverage suite: **a top-level exported `class` declaration that is reassigned in the direct-sibling position is not instrumented with the publish call.** Reproduces in five lines:

```js
export class X { static v = 'initial' }
X = class { static v = 'updated' };
```

Expected: `liveVar.X` updater called once at declaration and once at reassignment, with the new class.
Actual: `liveVar.X` is called only once (at declaration); the reassignment runs raw and the bundled `X` export stays observably stuck at the initial class.

Root cause: in the diff, the `ClassDeclaration` visitor (`packages/module-source/src/babel-plugin.js:646`) populates `liveSoftened` via the identity-mapping `liveSoftened.set(name, name)` for reassigned classes. But the enclosing `ExportNamedDeclaration` visitor (line 753) calls `path.replaceWithMultiple(decl ? [replace(path.node, decl)] : [])` at line 845, which (per Babel traversal semantics) defers the `ClassDeclaration` visit until after the sibling assignment expression in the same Program body has already been visited. By that point the `AssignmentExpression` visitor has already inspected `liveSoftened`, found no entry for `X`, and returned. Confirmed by tracing visitor order: `Program.enter` runs, then `AssignmentExpression(X = ...)` runs with `liveSoftened` empty (early-returns), then `ClassDeclaration(X)` runs and finally sets `liveSoftened`. The bundle-source `let-export` integration test does not catch this because it drives the class reassignment through a deferred top-level function call (`const update = () => { classVal = class {...} }`), whose body is traversed after the class visitor has populated `liveSoftened`, so it hits the working path.

Recorded as `test.failing` rather than a passing test or an omission so the regression evidence ships with the PR and a follow-up fixer can move the class entry into the `Program.enter` rename sweep (or otherwise guarantee `liveSoftened` is populated before sibling traversal) and un-`.failing` the case. The body's comment names the analysis in-line so a future fixer does not need to re-derive it.

## Judge readiness

CI green on cleaner head; PR DRAFT; PR `MERGEABLE` against `master`. Ready for judge dispatch. The class-reassignment gap surfaced above is the one item the panel should weigh: it can either (a) accept the partial fix + `test.failing` follow-up marker and request the follow-up be filed as a separate issue/PR, or (b) request the fixer extend the current PR to cover the class case before un-draft. Recommendation (cleaner's view, non-binding on the panel): option (a). The bundle-source regression test the PR primarily targets passes and the gap is on a distinct code path with its own regression-evidence marker, so the PR's stated scope (`fixes endojs/endo#2982`) is honored for the let / var / function shapes the issue's reproducer enumerates. The class-direct-sibling-reassignment case is an adjacent defect the same area now-visibly carries, but the issue did not name it.

## Local validation

Per cleaner discipline:

- `yarn test` on `packages/module-source`: 54 passed, 1 known failure (the new `test.failing`). Run completes across the three ses-ava configs (lockdown, unsafe, ses).
- `yarn test:c8` on `packages/module-source`: same test result; coverage report above.
- `yarn lint` on `packages/module-source`: clean (eslint + tsc both pass).
- No new dependencies; no `yarn.lock` churn; no separate `chore: Update yarn.lock` commit needed.
- No dead code identified for deletion: the PR adds new visitor branches that are now (after this commit) exercised; no other reachable-but-unexercised paths in the touched plugin file fit the four "dead code" deletion criteria.

## Commit

```
66d67684c test(module-source): cover reassignment-publish for export var/function/let and surface class-reassignment gap
```

Pushed to `origin/fix/bundle-source-export-let-2982` (fast-forward from `10ac18971`).

Self-improvement: nothing this time. The cleaner's discipline of *write a load-bearing test first, then revert the fix to confirm failure* is what surfaced the class-reassignment gap: building the runtime probe for the `var` and `function` cases revealed that all three reassignment shapes share one publish-call mechanism, which made the missing class case visible the moment the cleaner generalized the test. No new norm to encode; the existing `regression-evidence` skill already names exactly this pattern.
