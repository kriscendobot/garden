<<<GARDEN-ORCHESTRATION-FAILED>>>

# Clean stage for PR #1568: failed, CI is red, but none of the failures are in this PR's packages

`ci-wait-merge.sh` returned **rc 3 (RED)** at head `49531a3590`, so the stage did not succeed and there is no `clean=done` marker.

**Coverage pass.** I made no changes and pushed nothing.
- I ran c8 over `packages/git/test/native-git-backend.test.js` in an isolated checkout. All 18 tests pass, and every line of the new `readStructuredDiff`, `readShow` and `show`/`showText` code is covered.
- The tests cover root commits, merge commits, SHA-256 repositories, blob rejection, `showText` and the textconv guard. In exo-git, `showText` and the not-yet-implemented stub are tested.
- One branch is never hit: the `committedAt` fallback that sets it to undefined. Git always emits the commit time, so the branch can't run. It is new code that repeats the existing `log` parsing pattern for an optional field, not code the change left behind, so I left it.

**Failing checks.** Six are red, from two causes:
- **Five checks fail on the same two sandbox tests:** `test (22.x/24.x, ubuntu-latest)`, `cover (22.x/24.x, ubuntu-latest)` and `sandbox-drivers`. The tests are `bwrap › prlimit nproc cap is enforced inside the slice` (the runner's `/bin/sh` rejects `ulimit -u`) and `bwrap › bwrap parent death leaves no owned process group`. This is a known red that also fails on unrelated branches, and there is a `fix/ci-runner-bwrap-and-graphviz` branch in progress for it.
- **`test (24.x, macos-15)`** fails because `packages/floot/test/factory-system-prompt.test.js` exits with code 1. There is also an in-flight `fix/floot-client-destroyed-error-node24` branch for floot.

The PR touches none of those packages (`sandbox`, `floot`). Re-running or pushing to this PR won't help. The gauntlet can move forward once the CI fixes for the bwrap runner and floot land on the base and the PR is re-run, or if the maintainer decides to waive these known reds.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1568-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1705131 cached reads)
- Output: 7841 tokens
- Cost: $1.0470701999999998
- Wall-clock: 2078s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
