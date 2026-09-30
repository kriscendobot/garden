---
orchestration-failed: true
---
orchestration-failed: true

# Clean stage for endojs/endo-but-for-bots#774: failed, CI is red on one macOS leg

**Result:** The coverage part of this stage passed with nothing to change. The stage still fails because CI stayed red on `test (22.x, macos-15)` after one re-run. The failure is in `@endo/daemon`, which this PR does not touch or feed into.

**Coverage and dead code**
- I ran c8 with ava on the only touched package, the new `@endo/sturdyref`, in an isolated checkout at head `ef4662f04b`. All 22 tests passed, with 100% statements, branches, functions and lines across `shim.js`, `src/sturdyref-shim.js` and `src/sturdyref-pony.js`.
- Nothing is orphaned. The package is new, nothing else depends on it, `@endo/harden` is still used by `sturdyref-shim.js`, and every devDependency is imported by the tests.
- I pushed nothing to the PR head.

**CI** (`ci-wait-merge.sh --no-merge`, rc=3, RED)
- 32 of 33 checks are green or skipped. The one failure is `test (22.x, macos-15)`.
- **First run** (job 109768893751): `@endo/daemon` › `daemon-teardown › an orphaned daemon shuts itself down instead of lingering` failed.
- **Re-run** (job 109778800145): a different `@endo/daemon` failure, `test/endo.test.js exited with a non-zero exit code: 1`.
- Why I think it's not this PR:
  - The PR changes only `packages/sturdyref/**`, the root `tsconfig.composite.json` and `yarn.lock`.
  - No package, including `@endo/daemon`, depends on `@endo/sturdyref`.
  - The root file changes put the whole monorepo in CI's affected set, which is why the daemon suite ran at all.
  - The two runs failed in different daemon tests, which looks like a macOS timing flake.
- The `llm` branch's own CI also went red on `8e53cc0f89` earlier today, which suggests `llm` has its own instability right now.

**Follow-ups**
- The gauntlet needs a decision on this red leg. Either re-run `test (22.x, macos-15)` again and re-post this clean stage, or get the flaky daemon tests on macOS/Node 22 (`daemon-teardown`, `endo.test.js`) looked at separately. Nothing in #774 needs fixing.
- No project changes were pushed and no PR was opened.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/ebfb-sturdyref-layer1-shim-build-20260930-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 60 tokens (1866841 cached reads)
- Output: 8336 tokens
- Cost: $1.0851202000000002
- Wall-clock: 3926s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
