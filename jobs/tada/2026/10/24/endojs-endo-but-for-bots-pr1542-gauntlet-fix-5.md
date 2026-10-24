Fix round 5 for endojs/endo-but-for-bots#1542 is pushed (commit `43998e611f`) and CI is green: all 34 checks pass.

**Source of the fixes:** the job had no pre-pass block, so I worked from the latest panel verdict, review 5637814164 on `e58ae947`. Five jurors asked for changes: assessor, saboteur, breaker, spec-keeper and pruner.

**Changes in `packages/sandbox/src/drivers/bwrap.js`:**
- **Only terminating signals kill the sandbox init** (the one item marked must-fix). Before, any `kill()` call SIGKILLed the whole sandbox, including the existence probe `kill(0)` and signals like SIGCONT or SIGUSR1. Now only SIGHUP, SIGINT, SIGQUIT, SIGKILL and SIGTERM do that. Every other signal goes straight to the launcher's process group without waiting for bwrap's `--info-fd` report.
- **The init's pid is read as soon as the report is complete.** Before, the driver waited for the stream to close. If the init kept that descriptor open, every kill was delayed by 1 s and the fix quietly stopped working.
- **The first error is kept.** If the kill fails and then signalling the group or resuming the launcher also fails, the original error is no longer replaced. The launcher is still always resumed.
- **Smaller fixes:**
  - The wait for the launcher to stop is now a count of polls rather than a `Date.now()` deadline.
  - `raceBound` now handles a rejected promise.
  - `readProcStat` now notes that it relies on Linux `/proc` and falls back to the group signal when `/proc` can't be read.
  - Comments that restated other comments were removed, and the `signalSlice` JSDoc was cut down.

**Tests (`bwrap.test.js`):**
- New: `kill(0)` and `SIGCONT` leave both the sandbox init and the launcher running.
- New: a launcher that keeps the report descriptor open is still killed, in under 500 ms.
- The test for a launcher that never reports now checks that teardown takes under 1.9 s.
- The refused-signal test was renamed: an out-of-range signal now never stops the launcher.
- The test section header was shortened.

**PR body:** cut from about 660 words to about 200, as the pruner asked.

**Checks before pushing:** prettier and eslint are clean, and all 48 tests in `bwrap.test.js` pass. The package type check (`tsc -p packages/sandbox`) passes. The repo-wide `tsc` reports 17 lines of errors, none in sandbox files.

**CI:** the first run failed one job, `test (24.x, macos-15)`, with an uncaught exception in `restore-context.test.js`. That is a known flake that hits other PRs on the macOS legs and has nothing to do with this change. I re-ran the failed job and everything passed. I did not re-run the panel; the driver posts panel-6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1542-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2386255 cached reads)
- Output: 16387 tokens
- Cost: $1.509991
- Wall-clock: 1379s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
