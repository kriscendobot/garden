The receipt watcher now clears leftover processes from the previous run before it starts the PR source, as well as on exit. The fix and a regression fixture are pushed to main2 as `c9bfa87823e`.

**What changed** (`scripts/jobs/receipt-watcher.sh`)
- `reap_cgroup_stragglers` takes a new `startup` mode, and the watcher calls it just before starting the PR source. The existing guards stay: it only acts inside a `garden-receipt-watcher@*.service` cgroup, and it never signals the watcher or its ancestors.
- A process only counts as a leftover from the previous run if it started strictly before the oldest ancestor of the watcher that is still in the cgroup (the `self-heal-run.sh` main process). Everything the current run starts is younger than that, so it is spared: the watcher's own children and the wrapper's concurrent `tee`.
- A kill loop with the same deadline confirms the kill, and it logs `reaped prior-run cgroup straggler(s) at startup: <pids>`.
- I tried to also skip anything descended from the watcher's ancestors, but dropped it. An orphaned old `git` gets reparented to the systemd user manager, which is also the parent of the new run's main process. That check would therefore have spared exactly the leftover processes this job is about, as it did in the first version of the test.

**Test** (`scripts/jobs/test/receipt-watcher-test.sh`)
- The new fixture uses a fake `cgroup.procs` containing:
  - an orphaned `sleep`, standing in for a git process left by the previous run;
  - a wrapper standing in for the main process, which lists itself;
  - a younger `tee`-like sibling started by that wrapper.
- The PR source records what it sees when it runs. The test expects the orphan to be dead and the sibling alive at that point, which shows the sweep ran before the source and not only on exit.
- I checked the test against a broken version: with the startup call removed, it fails.
- `run_watch` has a new optional `WATCH_WRAP` prefix. shellcheck reports no warnings on either file.

**Test results:** 15 passed, 2 failed. The two failures ("fresh-clone outage lost its warning/cooldown" and "empty-stderr prerequisite exit lost its WARN/no-diagnostic wording…") also fail on a clean checkout of origin/main2, so this change didn't cause them. They are worth a separate fix job.

**Follow-up:** the fix only takes effect on a host after the next deliberate deploy.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-receipt-watcher-startup-stragglers.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1150909 cached reads)
- Output: 17096 tokens
- Cost: $1.1302538
- Wall-clock: 204s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
