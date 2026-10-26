---
orchestration-failed: true
---
orchestration-failed: CI is RED at head `3a61d1af74`. My change pushed cleanly, but none of the failures come from this PR's code.

**What I did**
- **Coverage pass on the touched packages.**
  - `packages/git`: `parse-diff.js` went from 95.5% to 99.65% statement coverage. The one line still uncovered is a comment inside an empty branch.
  - `packages/git`: the lines this PR changed in `native-git-backend.js` were partly uncovered (the base/head/paths handling in `diffArguments`). They are all covered now.
  - `packages/exo-git`: `resolveDiffOptions`, which `Git.diff` and `Git.diffText` share, had no tests in its own package. It is now covered except the `entries` branch, which needs a real mount; I didn't confirm whether the daemon test reaches it.
- **Tests added** in one commit, `3a61d1af74` ("test(git,exo-git): cover structured diff option and parse failure paths"):
  - `packages/git/test/parse-diff.test.js`: three tests for the error paths (a raw record missing its path or rename target, an unexpected section line, an unexpected hunk line, a hunk that overruns its counts, an unsupported status letter).
  - `packages/git/test/native-git-backend.test.js`: one test that narrows `diff` and `diffText` by revision range and path, and checks that an empty path and an option-shaped revision are rejected.
  - `packages/exo-git/test/diff-options.test.js` (new): two tests that `diff` and `diffText` pass the same options to the backend, including turning a ref object into its name.
- **Checks:** the new tests pass locally, and eslint, prettier and each package's `tsc` are clean.
- **Dead code:** the change left nothing orphaned.
- **Push:** went to `build-daemon-git-next-steps-structured-diff` via `safe-push-pr-head.sh` (`1cb4ade14e` → `3a61d1af74`).

**CI result:** `ci-wait-merge.sh` returned rc 3 (RED), with 6 of 35 checks failing:
- **`cover` (22.x, 24.x), `test` (22.x, 24.x ubuntu) and `sandbox-drivers`:** all fail only in `packages/sandbox` bwrap tests, which this PR doesn't touch. The tests are "prlimit nproc cap is enforced inside the slice" (`/bin/sh: ulimit: Illegal option -u`), "bwrap parent death leaves no owned process group", and once "bwrap timeout and repeated cancellation reap process groups". The same bwrap failures were already there on this PR's previous head (`1cb4ade14e`), and the same cover/test/sandbox-drivers jobs failed today in unrelated PRs (`build/exo-agent-factory-*`). That points to a breakage in the sandbox runner environment or on the base branch.
- **`test (24.x, macos-15)`:** the runner lost contact with GitHub ("The hosted runner lost communication with the server"). That's a GitHub infrastructure problem; re-running it should clear it.

**Follow-ups**
- Someone needs to fix or quarantine the bwrap tests in `packages/sandbox` (the runner's `/bin/sh` doesn't support `ulimit -u`). That fix belongs outside this PR. Once those checks pass, re-run the macOS leg and this stage.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1565-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (4259903 cached reads)
- Output: 17870 tokens
- Cost: $1.9468126000000006
- Wall-clock: 3146s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
