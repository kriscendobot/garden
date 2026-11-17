## FIX round 2: endojs/endo-but-for-bots#1591 (pushed, CI green)

**What I fixed:** The pre-pass had one failing probe, `spell-out-identifiers`, which flagged `anchorArgs` and `args` in `packages/sandbox/test/bwrap.test.js`. I renamed `anchorArgs` to `anchorArguments`. I renamed the spawn stub's `args` parameter, and its JSDoc `@param`, to `spawnArguments`. The test behaves exactly as before.

**Commit:** `8708f56194` "test(sandbox): spell out bwrap anchor spawn argument names (#1591)". It was pushed with `safe-push-pr-head.sh` in advance mode, moving the head from `aa8b19b8ae` to `8708f56194` on `fix/sandbox-bwrap-leader-exit-group-sweep`.

**Advisory comment (not changed):** The pruner flagged the 9-line comment at `packages/sandbox/src/drivers/bwrap.js:74`. I kept it because it explains things the code doesn't show:
- why the background shell ignores HUP, INT and TERM (so the process group stays owned);
- why the watchdog compares the start time, not just the pid (pids get reused);
- why the `not-applicable` watchdog is skipped;
- that the shell's own `kill` is used, so no `/bin/kill` is needed;
- that a bwrap killed by signal N reports exit code 128+N.

**CI:** It took two reruns of the same macOS leg, `test (22.x, macos-15)`, to get green. No code changed between them.
- **First run:** that leg was cancelled after 15 minutes because GitHub never assigned it a macOS runner ("not acquired by Runner of type hosted"). That is a GitHub capacity problem, not this PR.
- **First rerun:** that leg failed in the `@endo/hosted-agent` suite. `yarn test` exited 1 with no failing assertion in the log. The same tests passed on the Node 24 macOS leg and on all the Ubuntu legs. My change only renames identifiers in a sandbox test, so I took it for a flake.
- **Second rerun:** all 35 checks passed (`ci-wait-merge.sh` rc 0).

**Follow-up:** It may be worth watching for that silent `@endo/hosted-agent` exit on Node 22 macOS. If it comes back, it is a flake shared across PRs, not a problem with this one.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1591-gauntlet-20261117-r2-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 52 tokens (1677608 cached reads)
- Output: 6660 tokens
- Cost: $0.9996976
- Wall-clock: 2924s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
