## PR #1557 CI fix: completion report

CI on endojs/endo-but-for-bots#1557 is green: every check on the new head `931f5ea398` passed (26 success, 10 skipped, 0 failures). The 31 cancelled entries are older runs that were superseded when I moved the PR's base.

**Cause.** None of the seven failing checks came from the PR's own changes. They were problems in its old frozen base, `llm-d5ac419`:
- **`build` / Check for cycles:** exited 127 because `tred` was missing. Ubuntu 26.04's Graphviz doesn't include it.
- **`test (22.x/24.x, ubuntu)`, `cover (22.x/24.x)`, `sandbox-drivers`:** two bwrap tests failed. One was `ulimit: Illegal option -u` under `/bin/sh`; the other was "parent death leaves no owned process group".
- **`test (24.x, macos-15)`:** the known `claude-sandbox` `restore-context.test.js` flake that shows up on many PRs.

The live `llm` branch already fixes the first two: `depcheck.yml` now pins `runs-on: ubuntu-24.04` for `tred`, and `packages/sandbox/test/bwrap.test.js` was made portable across runners. That means #1566, which is still open, is no longer needed to unblock this PR.

**What I did (moved the PR onto a newer frozen base).**
- Rebased the PR's single commit from `llm-d5ac419` onto the current `llm` tip `9a14ddf`. There were no conflicts. `git diff --stat` shows the same 11 files as before (+932/−73): the `daemon` and `exo-git` Git capability URL changes, the help text and the changeset.
- The frozen base `llm-9a14ddf` already existed on the remote. I force-pushed the head with a lease on the old SHA (`4539c71f2c` → `931f5ea398`) and changed the PR's base to `llm-9a14ddf`.
- I made no code edits, so the capability-boundary design is unchanged.

**Local checks before pushing.**
- `exo-git`: 75 tests passed.
- `daemon` `git-capability-url`, `git-remote` and `git` tests: 180 passed, but only with `GIT_CONFIG_GLOBAL=/dev/null`. This host's global gitconfig enables `rerere` with `autoupdate`, which resolves the tests' intentional merge conflicts automatically. Without the override, 5 conflict, cherry-pick and reword tests fail locally. This is a quirk of this machine, not a problem in the PR; CI runs all of these tests and they pass there.

**Follow-ups**
- #1566 (graphviz/bwrap CI fix) looks redundant now that `llm` has its own fixes. The maintainer may want to close it or check whether anything in it is still needed.
- The PR is still a draft. The gauntlet or review step is next.
- Any garden job that runs the daemon git tests locally on this host should isolate the global gitconfig, because the `rerere` setting makes those tests fail for no real reason.

No garden (`main2`) changes were made.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-endojs-endo-but-for-bots-pr1557-ci.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2059061 cached reads)
- Output: 9412 tokens
- Cost: $1.1600762000000002
- Wall-clock: 4526s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
