Done. My commit is on `origin/main2` and FF3 passes (the single remaining failure is the pre-existing, unrelated gauntlet-record assertion — confirmed present on the base HEAD before my change).

---

## Completion report

**Job:** `improve-comment-watcher-child-reaping` — make `comment-watcher.sh` subprocess cleanup reliably leave the service cgroup empty across stop/restart races, closing the residual leak where a `gh` child survived into the next watcher invocation despite the existing process-group and cgroup cleanup.

**Root cause.** The EXIT-path cgroup sweep (`reap_cgroup_stragglers`) was a single snapshot-then-kill pass. Two races it couldn't close:
1. **Fork-after-snapshot** — `gh --paginate` forks a fresh git credential helper per page, so a child spawned after we read `cgroup.procs` escaped the one snapshot.
2. **Exit-before-teardown** — `kill -KILL` only *queues* the signal; a pid stays in the cgroup until the kernel tears it down. Exiting immediately after signalling raced the next `systemctl start`'s "left-over process in control group" check.

**Fix (`scripts/jobs/comment-watcher.sh`).**
- Rewrote `reap_cgroup_stragglers` into a **bounded wait-until-empty loop**: each pass **re-reads** `cgroup.procs` (catching a fork-after-snapshot), SIGKILLs every straggler still holding the cgroup, and returns only once none remain — so the cgroup is genuinely empty of descendants before the watcher exits.
- Liveness is gated on `/proc` state via a new `_straggler_alive` helper: a SIGKILLed pid leaves the cgroup the instant it exits (even as an unreaped zombie), so a zombie correctly counts as gone and never wedges the loop.
- Added a deadline knob `GARDEN_COMMENT_CGROUP_REAP_DEADLINE_SECS` (default **3s**) so an un-killable D-state pid can't wedge the exit; 10s `--kill-after` + 3s stays well inside `TimeoutStopSec=20s` (verified in the unit).
- This also hardens the stop path: the negated-PGID group-KILL's members are now confirmed gone by the same loop.

**Test (`scripts/jobs/test/comment-watcher-test.sh`).** New **FF3** case exercises the loop deterministically via a test-only fixture override `GARDEN_COMMENT_CGROUP_PROCS_FILE` (honored only under `_in_test_context`; the `$$`+ancestors keep-set still protects the runner and the production service-cgroup guard is untouched). Two stragglers in a separate process group are felled and confirmed gone by the time the watcher exits.

**Verification.** `bash -n` + `shellcheck -S warning` clean. Full suite: **360 passed, 1 failed** vs base **358 passed, 1 failed** — my change adds 2 passing assertions and no regression. The 1 failure ("gauntlet record does not start at stage: clean") is pre-existing and unrelated (reproduced on unmodified HEAD). Committed and pushed to `main2` (`a6f6b82e0bd`).

**Follow-ups.** None for this job. Noted-in-passing: the pre-existing gauntlet-record test failure ("does not start at stage: clean") is unrelated to child reaping and worth a separate look.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-comment-watcher-child-reaping.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 66 tokens (3129911 cached reads)
- Output: 32589 tokens
- Cost: $3.5193974999999997
- Wall-clock: 797s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
