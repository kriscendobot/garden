`approval-reconciler.sh` now kills leftover `git` processes in its control group every time it exits, whether the tick ends cleanly or is stopped by a signal. The fix is pushed to `main2` as `0fa4e171b93`, and the reconciler's tests pass (21 passed, 0 failed).

**What changed**
- **`scripts/jobs/approval-reconciler.sh`:** I copied `reap_cgroup_stragglers` and `_straggler_alive` over from `dependabot-watcher.sh`. `cleanup()` still sends TERM, waits, then sends KILL to the `setsid` process group. After that it runs the new sweep, so helpers that escaped the group are caught too.
  - The sweep keeps re-reading `/sys/fs/cgroup<leaf>/cgroup.procs` and SIGKILLs any live process that isn't the script itself or one of its parents.
  - It only runs when the script is inside its own `garden-approval-reconciler*.service` control group. Otherwise it does nothing.
  - It stops after two reads in a row find nothing left, or after `GARDEN_AR_CGROUP_REAP_DEADLINE_SECS` (default 3s). If the deadline hits first, it logs a warning describing what survived.
  - Tests can point it at a fake process list with `GARDEN_AR_CGROUP_PROCS_FILE`, which is only honoured in a test context.
- **`scripts/systemd/garden-approval-reconciler@.service`:** I added `ExecStopPost=-… cgroup-drain.sh %n`, which the dependabot, comment, triager, CI and issue-inbox units already have. It holds the unit until its control group is actually empty. I also updated the unit's comments.
- **`scripts/jobs/test/approval-reconciler-test.sh`:** New section S covers two cases:
  - two leftover processes, each in its own session, are killed on a clean exit;
  - a process that appears only after an empty read is still killed.

  Both checks fail against the old script (19 passed, 2 failed) and pass with the fix. Shellcheck reports nothing new; the two remaining notices were already there.

**Follow-up:** I posted `improve-ci-pages-watcher-cgroup-straggler-reap` to give `ci-watcher.sh` and `pages-watcher.sh` the same sweep and tests. It also adds the `ExecStopPost` drain to the pages-watcher unit if that unit doesn't have one; the CI unit already does.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-approval-reconciler-cgroup-straggler-reap.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1172093 cached reads)
- Output: 10414 tokens
- Cost: $0.9440266000000002
- Wall-clock: 128s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
