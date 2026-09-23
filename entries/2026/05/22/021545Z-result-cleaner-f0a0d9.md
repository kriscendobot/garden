---
ts: 2026-05-22T02:15:45Z
kind: result
role: cleaner
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 351
worktree: dispatches/cleaner--969786
---

# Result: cleaner on endo-but-for-bots#351 (mirror of endo#2422 host module exits)

Dispatch root: `dispatches/cleaner--969786/`. Branch: `mirror/2422-host-module-exits`. Arrived at head `a61ec6051`, departed at `1318da27b`.

## Mergeability and pre-flight

PR was `MERGEABLE` against `master` on arrival; no weaver needed.

## Targeted package

`packages/compartment-mapper` (the PR's primary subsystem; `packages/import-bundle` and `packages/ses` are touched only via a single test and a single type declaration respectively, so coverage there has nothing additional to grow).

## Baseline coverage

`yarn cover` on arrival, src/ only:

- `policy.js`: 92.07% stmts / 87.64% branch / 90.91% func
- `link.js`: 92.88 / 82.35 / 70
- `import-hook.js`: 97.25 / 93.04 / 85.71
- `import-archive-lite.js`: 94.64 / 85.41 / 100
- All files: 94.48% stmts / 89.83% branch

Same files on `master` baseline (run before the PR's commits applied):

- `policy.js`: 94.09 / 89.53 / 90.47
- `link.js`: 93.13 / 81.25 / 77.77
- `import-hook.js`: 97.24 / 93.04 / 85.71
- `import-archive-lite.js`: 94.67 / 85.41 / 100

The PR shipped a small net-negative on `policy.js` (-2.02pp stmt) and a sliver on `link.js`, driven by two new code regions: the `'source' in moduleDescriptor` branch in `attenuateModule` (policy.js L545-560) and the `archiveOnly && urlish.test(...)` synthetic-source branch in `makeModuleMapHook` (link.js L137-152).

## Coverage delta

Added one test, `policy - exitModules import returning a strict module descriptor`, parallel to the existing `policy - exitModules import` scaffold but returning a `{source: VirtualModuleSource}` shape from `importHook`. The new test fans out across 11 scaffold variants (loadLocation, importLocation, makeArchive/parseArchive, writeArchive/importArchive, etc.) and is load-bearing: a deliberate `throw new Error('regression-evidence: source branch reached')` in the new branch failed 10 of the 11 variants under the new test while leaving every other test (including the original `policy - exitModules import`, which exercises the legacy bare-virtual-source path via the `else if` arm) green. Source restored.

Post-test coverage on policy.js: **94.49% stmts / 88.88% branch / 90.91% func** (+2.42pp stmt, +1.24pp branch). Overall src/ moved 94.45 → 94.58.

## What remains uncovered, by category

- `policy.js` line 574 (the `throw new Error('Can only attenuate virtual module source descriptors')` introduced by this PR) and lines 601-606 (the pre-existing `!policyValue` builtin-missing throw): both are defensive guards reachable only by out-of-contract caller arguments (an importHook returning a descriptor with neither `source` nor `imports/exports/execute`, or a policy that omits a named builtin entirely). Per `coverage-driven-testing` § Threshold for "dead", these are category-2 (configuration the public API cannot trigger); a contortion test to exercise them does not improve quality and would not parallel any existing pattern in `policy.test.js`. Left as-is.
- `link.js` lines 146-148 (the synthetic execute `throw new Error('Cannot import an application loaded strictly for analysis')` in the new urlish/archiveOnly branch): the surrounding L137-145 ARE exercised (hit twice by the new exit.test.js fixtures); only the inner `execute()` body is unreached because nothing then attempts to *execute* an `archiveOnly: true` synthesised source. This is a defensive guard against an internal bug in the analyser, not a public-API failure mode. Left as-is.

## Dead-code audit

`attenuateVirtualModuleSource` (the new helper extracted from the old `attenuateModule` body) has two live call sites inside `policy.js` and is not exported; not dead. `urlish` regex has one live call site in `link.js`; not dead. No deletions warranted.

## CI status on cleaner HEAD `1318da27b`

All 18 checks pass: browser-tests, build, check-action-pins, cover, lint, test (22.x/24.x ubuntu/macos), test-async-hooks (18/22), test-hermes, test-ocapn-python, test-xs, test262 (22.x/24.x), viable-release, zizmor. PR remains DRAFT (judge un-drafts after the panel-fixer loop).

## Commit

`1318da27b test(compartment-mapper): Policy attenuates a strict module descriptor exit` (+37 lines, single file, no yarn.lock churn).

## Judge readiness

Ready. PR is MERGEABLE, CI is green on the cleaner HEAD, the new exit-path branch is now under a load-bearing test, and remaining uncovered lines are pre-existing or PR-introduced defensive guards documented above so the panel does not need to re-litigate them. Steward should proceed to judge `351`; expect a code panel (source-touching PR).

Self-improvement: nothing this time. The cleaner skill, the coverage-driven-testing skill, and the dispatch prompt template all aligned cleanly; the four-criterion dead-code threshold and the regression-evidence step in particular gave clear answers on every borderline call (the synthetic execute throw, `attenuateVirtualModuleSource`, the throw at policy.js L574).
