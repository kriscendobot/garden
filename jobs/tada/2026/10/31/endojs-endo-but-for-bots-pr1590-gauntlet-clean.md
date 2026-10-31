I added two tests to PR #1590, but CI hadn't finished by the 3600s deadline, so this stage ends as **still-pending**. One check is red, which I believe is a flake I couldn't rerun yet.

**The coverage pass.** The PR's changed files were already well covered by tests: the daemon's `makeFromMount` (picking between a package.json root and a compartment map, rejecting bad options, failing roots, the offline and registry paths) and the CLI's `--mount`/`--registry`/`--offline` flags (the flag checks, help text, and full runs against a test daemon). I found no dead code left over from the change. I added two tests for paths that had none:
- `makeFromMount reports an unknown source name`, in `packages/daemon/test/make-from-package.test.js`.
- `endo run --mount refuses arguments beyond its entry`, in `packages/cli/test/run-mount.test.js`. This check fails before the CLI connects to a daemon, so the test needs no daemon.

Both pass locally. The daemon tests have to run under Node 24 (`/usr/local/n/versions/node/24.21.0`), because the shared `better-sqlite3` build was compiled for Node 24 and the default Node 22 can't load it. ESLint shows no errors on either file (its three warnings were there before this change), and Prettier passes. The commit is `9f0a7a65c0`, pushed with `safe-push-pr-head.sh` (it advanced the branch from `0fceeee4ea`, no rewind).

**CI on `9f0a7a65c0`, at 12:32Z:**
- 18 checks passed and 10 were skipped.
- `test (22.x, macos-15)` and `test (24.x, macos-15)` sat in the queue for about 30 minutes and were still running at the deadline.
- `sandbox-drivers` failed on one test, `bwrap › bwrap timeout and repeated cancellation reap process groups`. That suite ran four times in the job and passed three. This PR doesn't touch the sandbox drivers, so I believe it's a flake. GitHub won't allow a rerun until the whole run finishes, and the macOS legs were still going.
- My background `ci-wait-merge.sh` was killed at the 600s background limit, so I polled the PR checks in the foreground in chunks of under 600s instead. When the deadline passes with checks still running, that script returns 4 (still pending) even if one check has failed, and that is what I'm reporting here.

**For the next claimant:** once run 41195268283 completes, run `gh run rerun 41195268283 --failed -R endojs/endo-but-for-bots`, then wait for CI again. If `sandbox-drivers` passes on the rerun and the macOS legs are green, this stage is done.

<!-- gauntlet-stage-result: clean=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1590-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (3049812 cached reads)
- Output: 11188 tokens
- Cost: $1.4828664000000005
- Wall-clock: 5955s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
