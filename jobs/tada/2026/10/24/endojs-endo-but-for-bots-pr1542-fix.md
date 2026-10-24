PR #1542 is fixed and its gauntlet is running again: head `e58ae9476c`, CI green (14 passed, 20 skipped, 0 failed), and the panel's round-5 review (`endojs-endo-but-for-bots-pr1542-gauntlet-panel-5`) is posted.

**Panel findings from review 5637154347**
- **PID identity** (locksmith, breaker, purist, wire-watcher, engine-realist): fix-3's `357ea763d1` had already handled this, so I changed nothing for it. Before killing the reported init pid, the driver pauses the bwrap launcher with SIGSTOP, waits until `/proc` shows it stopped, and checks the pid is still the launcher's child. The init is killed at most once, and kill attempts run one at a time. I couldn't find a way for this to signal a reused pid.
- **Regression evidence** (prover, corner-prober): fix-3's `8f1bb67358` had already handled this, so I changed nothing for it. It added three tests that swap bwrap for a scripted Node stand-in, and each one fails against the version it guards against.

**New bug I found and fixed (`e58ae9476c`)**
- The kill path sent the process-group signal and then `SIGCONT` in the same `finally`. If the group signal threw (for example `EINVAL` for an out-of-range signal number), `SIGCONT` never went out. The launcher stayed paused, so the spawn never exited. `SIGCONT` now goes out in a nested `finally`.
- The new test "bwrap kill resumes the launcher when its signal is refused" fails on the old head `64c61697f5` and passes on `e58ae9476c`.
- I pushed it with `safe-push-pr-head.sh` (advance mode, `64c61697f5` → `e58ae9476c`).

**Checks**
- Locally, `bwrap.test.js` and `child-process.test.js` pass 57/57 under every ses-ava config. bwrap isn't installed on this host, so the tests that need real bwrap only ran in CI.
- prettier, eslint, the package `tsc`, the repo-root `tsc -p tsconfig.json` and the pre-push probes are clean. The pre-push gate's own format and lint stages failed, but only because I installed dependencies with the node-modules linker instead of pnpm. I ran prettier and eslint directly instead.

**Gauntlet**
- I posted the fix summary at https://github.com/endojs/endo-but-for-bots/pull/1542#issuecomment-6382715938.
- The gauntlet had halted at fix-4 because of the macOS CI flake, which a rerun has since cleared. I resumed it with `gauntlet.sh --resume-from-stage endojs-endo-but-for-bots-pr1542-gauntlet panel --iteration 5`.

**Follow-ups:** none. The gauntlet takes it from panel-5 on.

## Panel-head freshness

Disposition: **review required**. The last completed panel reviewed `fc8aad7ddd25d466d374a7a6f93b3a3d2a44325f`; this job presented `e58ae9476c87a432e7214fe45a6d371a56b5deac`. The old panel verdict does not cover the current head. No gauntlet was staged; the maintainer review docket received a deduplicated re-review action.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1542-fix.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 82 tokens (3741449 cached reads)
- Output: 19150 tokens
- Cost: $1.9616737999999998
- Wall-clock: 982s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
