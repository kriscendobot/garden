Done. Both test suites pass and the fix is pushed to `main2`.

## Completion report

**Commit:** `8732885a200` on `main2` (rebased from local `d7077e4462c`).

**What I did**

The bug: `local-verify.sh` always resolved its runner to `yarn`/`npx corepack yarn` unless `GARDEN_YARN` was set, so npm-only repos (minion.town) failed every step with *"doesn't seem to be present in your lockfile"* and every gauntlet had to pass `GARDEN_YARN=npm`.

- **New shared library `scripts/jobs/package-manager.sh`** — lifted pre-push-gates' detection (from `0389ac0130`) into `detect_package_manager` / `package_manager_runner` / `package_manager_exec_prefix`. Sourceable, no side effects. Detection order: `packageManager` field → lockfile (`yarn.lock`/`pnpm-lock.yaml`/`package-lock.json`) → default Yarn. `GARDEN_YARN` (and `GARDEN_PACKAGE_MANAGER`/`GARDEN_PACKAGE_RUNNER`) still win.
- **`local-verify.sh`** now sources the library and selects the runner per project. `<runner> run <script>` is universal across npm/yarn/pnpm/bun. A selected-but-unavailable manager fails loud (`PACKAGE MANAGER PARITY`, exit 3).
- **`pre-push-gates.sh`** refactored to call the same helpers (deleted its ~70-line duplicate), so both gates select identically.
- **Yarn-only spellings mapped per manager:** `root-types`' bin invocation (endo CI's `corepack yarn tsc`) now goes through `package_manager_exec_prefix` (`npx tsc` on npm); the workspace split (a Yarn `workspaces foreach` concern) is skipped on non-Yarn managers, falling back to the project's own root `test` aggregator.
- **Docs reconciled:** `skills/local-verify/SKILL.md`, `skills/pre-push-gates/SKILL.md`, and a `field-notes.md` entry; dropped the `GARDEN_YARN=npm`-mandatory framing.
- **Tests:** added a 5-assertion npm regression group to `local-verify-test.sh` (stubbed `npm` runner, a `yarn` stub proven never invoked, `package-lock.json` detection → silent pass, and the `GARDEN_YARN` override still winning).

**Verification:** `local-verify-test.sh` → 100 passed / 0 failed; `pre-push-gates-test.sh` → all ok; `bash -n` + `shellcheck -x` clean on all four scripts.

**Paths that still assume Yarn (by design):** none unconditionally. The only Yarn-specific paths remaining — the `root-types` bin exec and the workspace enumeration — are now guarded/mapped per manager. Comments describing endo's CI command (`corepack yarn tsc`) remain as accurate descriptions of that Yarn repo's CI, not harness assumptions.

**Follow-ups:** none required. Other fleet scripts that do their own detection (`ensure-project-worktree.sh`, `safe-rebase.sh`) could later adopt the same library, but that's out of scope for this job.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-local-verify-package-manager-detection.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (5573631 cached reads)
- Output: 36361 tokens
- Cost: $5.019130499999998
- Wall-clock: 485s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
