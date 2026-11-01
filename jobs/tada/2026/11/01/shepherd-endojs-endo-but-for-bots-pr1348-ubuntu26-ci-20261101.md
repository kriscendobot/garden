PR #1348 (endojs/endo-but-for-bots) is green at head `e223cb1aa0`: 19 checks passed, 14 skipped as not affected, none failed. The PR is mergeable and not a draft. Green run: https://github.com/endojs/endo-but-for-bots/actions/runs/41265759044

**Starting point.** When I claimed the job, the head had already moved past `eb7ce77af1` to `84fd63f796`. Three commits had been added:
- `5e1849bc2`: the bwrap tests read `/proc/self/limits` and use `t.notThrowsAsync`, which fixes the "finishes without assertions" failure.
- `729a133bd`: Graphviz 14 dependency checks, which greened `build` and fixes the missing `tred`.
- A cleanup bound for the CI job that runs the sandbox drivers.

The remaining Ubuntu red was test 22/24: "bwrap parent death leaves no owned process group" failing intermittently with "bwrap child did not become ready".

**What I pushed** (only test code in `packages/sandbox/test` changed):
1. **`103efaf98`**: the parent-death test's helper script now keeps reading stdout until the `ready` marker arrives, instead of trusting the first read. If the marker never comes, it reports bwrap's exit status, stdout and stderr. The next CI run showed the real cause: `bwrap: Creating new namespace failed: Resource temporarily unavailable`.
2. **Root cause:** the sandbox driver's default process limit (`RLIMIT_NPROC`) is 512, and that limit counts every task the user owns, not just the sandbox's. On a busy CI runner, with other packages' tests running in parallel, bwrap fails to start. I reproduced this locally by holding about 800 tasks on the user: the old tests fail 4 cases with the CI error.
3. **`f3914b0b4` and its fixup `e223cb1aa`**: a new helper, `test/fixtures/shared-uid-limits.js`, gives the bwrap tests that run real sandboxes, and the parent-death helper script, a process limit equal to the process's own hard limit. A fixed 65,536 failed on CI with `prlimit ... Operation not permitted`, because the runner's hard limit is lower. Locally, 36/36 bwrap tests pass under the 800-task load, both with an unlimited hard limit and with `prlimit --nproc=8000:8000`.

**What stayed the same:** the driver's default limit of 512 is unchanged, and the "prlimit nproc cap is enforced" test still sets its own cap and checks it. The confined-command and workspace-catalog changes are untouched.

**macOS failures on the intermediate head:** daemon-teardown failed on macOS 22 and the hosted-agent provider-worker test timed out on macOS 24. Neither is in my diff, and both passed on the final head, so I'm treating them as flakes.

**Not done / follow-ups:**
- I did not post the green-run summary comment on the PR, because this host's bot token gets 403s on endojs PR writes.
- **Needs a maintainer decision:** the default limit of 512 counts all of the user's tasks, so the product will hit the same EAGAIN failure on any busy host, such as a desktop running the daemon. Changing that default is a separate design question and I did not change it here.
- Other PRs on frozen bases will need these test commits, by weave or cherry-pick, to stop flaking.
- I added this root cause to the garden memory note on the ubuntu-26.04 CI breakage.

next: none (CI green; return to the PR's existing review flow).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr1348-ubuntu26-ci-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s) (2 unmetered)
- Input: 8 tokens (576918 cached reads)
- Output: 2675 tokens
- Cost: $2.487578799999999 (2 engagement(s) unpriced)
- Wall-clock: 4850s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
