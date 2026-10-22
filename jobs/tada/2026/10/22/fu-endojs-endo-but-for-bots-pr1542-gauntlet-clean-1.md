## Completion report: `fu-endojs-endo-but-for-bots-pr1542-gauntlet-clean-1`

I fixed the third test in endojs/endo-but-for-bots#1542 ("bwrap timeout and repeated cancellation reap process groups") with a change to the bwrap driver, and CI is now green. The PR title and description still need updating: this host's bot token gets a 403 on PR edits, so I posted a separate job to apply them.

**What was wrong.** The test was flaky, not broken: it failed in 1 of 4 ses-ava configs on Ubuntu 26.04 with `process group 7735 survived bounded cleanup`. The real problem is a containment bug in the bwrap driver:
- The host process group of a bwrap slice holds only the outer bwrap process, because the inner bwrap starts its own session (`setsid()` for `--new-session`).
- Everything inside the slice therefore dies only through `--die-with-parent`. bwrap's source shows it arms that only after the outer process finishes namespace setup.
- If any signal kills the outer bwrap during setup, the inner bwrap is left running. It either stays blocked in our process group (the case the test caught) or carries on past `setsid()` and runs the command with nothing left to kill it.
- By then Node has reaped the outer process, so `killProcessGroup` refuses every later SIGKILL.

I installed bubblewrap 0.9 here and reproduced it. A stress harness left 3 of 150 process groups alive and 18 inner bwrap processes stranded in their own sessions; the test can't see the stranded ones at all.

**The fix** (pushed to `fix/sandbox-ubuntu-2604-bwrap-tests` as f5f6ec662):
- **Driver** (`packages/sandbox/src/drivers/bwrap.js`): bwrap is now launched with `--info-fd 3`, so it reports the host pid of the slice's init process. `kill()` and teardown SIGKILL that pid first, which kills the whole slice, then signal the process group. A kill waits at most 1 s for that report, and falls back to the group signal alone if none arrives. Today a soft signal like SIGTERM never reaches the command anyway, so nothing observable changes.
- **New test**, "bwrap cancellation during launcher setup strands no sandbox init": it cancels 40 spawns at different points during setup and scans `/proc` for survivors. Against the old driver it fails with dozens of stranded processes; with the fix it passed every local run. The stress harness went to 0 of 300 leaks with 0 stranded processes.
- **Changeset**: a patch for `@endo/sandbox`.

**Checks:**
- **Locally:** `bwrap.test.js` passes 42/42 in all four configs. Lint, types and prettier are clean. The full sandbox suite passes except for one uncaught exception in `generated-files.test.js` in one config; that file then passed 12 of 12 reruns, and this change doesn't touch it.
- **CI on f5f6ec662:** `sandbox-drivers`, both `cover` jobs, all four `test` jobs, `lint`, `familiar-bundle` and `zizmor` all pass. Both bwrap cancellation tests pass in every config.

**Still open:**
- **PR title and description.** `gh pr edit` returned 403 here. I posted job `endojs-endo-but-for-bots-pr1542-gauntlet-clean-1-pr-body`, pinned to `endolin-garden-ece02cb4`, with the new title ("fix(sandbox): make bwrap tests pass on Ubuntu 26.04 and kill the sandbox init on cancel") and the full body embedded. The new body covers all three tests, adds a security note on the containment fix, and lists the driver file for review. Until that job runs, the description still says only the test file changed.
- **Separate 26.04 breakages.** The missing `tred` in `build` and the ironhorse-oracle corpus failures are not addressed here.
- I added a line about this 403 to the existing memory note on the bot token's missing PR permissions.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-endojs-endo-but-for-bots-pr1542-gauntlet-clean-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 108 tokens (5297150 cached reads)
- Output: 41033 tokens
- Cost: $2.9723939999999995
- Wall-clock: 1847s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
