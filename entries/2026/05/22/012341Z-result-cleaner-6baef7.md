---
ts: 2026-05-22T01:23:41Z
kind: result
role: cleaner
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
worktree: dispatches/cleaner--8f3e09/project
issues:
  - repo: endojs/endo
    issue: 2981
refs:
  - entries/2026/05/22/010659Z-dispatch-liaison-d85e99.md
---

# Result: cleaner skipped on PR #346 (carve-out: single bug-fix with in-diff test fixture)

PR #346 (`fix(bundle-source): bind aliased exports correctly in nestedEvaluate
format (fixes endojs/endo#2981)`) on `endojs/endo-but-for-bots@fix/bundle-source-aliased-exports-2981`, base `master`, DRAFT, MERGEABLE.

Head SHA unchanged: `6a72d10f0`. No cleaner push.

## Why skipped

The PR matches the cleaner's documented skip carve-out (`roles/cleaner/AGENT.md` § Operating norms):

> Skip the cleaner pass when the PR is pure documentation, lockfile-only churn, a one-file format sweep, or a **single bug-fix line whose test fixture is already in the diff.**

Diff shape (3 files, +48 / -8):

- `packages/compartment-mapper/src/bundle-mjs.js`: single-function fix to `importsCellSetter`. The pre-fix body emitted one object-literal property per export name keyed by the local binding; when one local binding had multiple aliases, JS literal semantics silently dropped all but the last property. The fix groups exports by local binding and emits a single fan-out setter per local. Surgical, scoped to one function in one file.
- `packages/bundle-source/test/export-alias.test.js`: flips `test.failing` to `test`. The test (existing on `master`, landed via the same family of bundle-failing tests as endojs/endo#2980) exercises every aliased-export shape via the `packages/bundle-source/demo/exports.js` fixture: re-export with two aliases (`stringValue as string1, stringValue as string2`), local-const + alias chain (`number1, number1 as number2`), destructured + alias (`numberValue3 as number3`), multi-alias on imported binding (`bigint as bigint1, bigint as bigintValue3` then `bigint1, bigint1 as bigint2`). The fixture is exactly the coverage surface the cleaner would otherwise add.
- `.changeset/bundle-source-aliased-exports.md`: changeset entry per project convention.

The fix's load-bearingness is already proven structurally: `test.failing` → `test` only flips green when the underlying bug is fixed, and the formerly-failing test now passes locally (`yarn ava test/export-alias.test.js`: `1 test passed`).

## Local validation

- `yarn install` from `project/`: completed with the usual workspace peer-dep warnings, no errors.
- `cd packages/bundle-source && yarn ava test/export-alias.test.js`: `✔ export alias (244ms) — 1 test passed`.

No further test additions are warranted; the in-diff fixture is the right coverage instrument for this bug and adding parallel tests would duplicate it.

## CI status

CI on `6a72d10f0` is mid-run (mix of `queued` and `in-progress`); `check-action-pins` already passed in 33s. The cleaner does not block on CI convergence when no cleaner-push lands (no new head to gate). Judge dispatch can proceed; the judge's own pre-panel CI check will see the same matrix converging.

## Judge readiness

Yes, ready for judge dispatch. Per `roles/cleaner/AGENT.md`:

> There is no procedural no-op cleaner stage in the new flow; the cleaner is skipped, not run-as-a-no-op.

The orchestrator's next step in the gauntlet is the judge (barrister; first code-panel round on a builder-shaped PR), followed by the fixer-loop and `gh pr ready 346` on jury termination.

Self-improvement: nothing this time. The cleaner's *skip the cleaner pass* carve-out fired exactly as documented, including the "test fixture already in the diff" sub-case for a `test.failing` → `test` flip.
