The job was already finished before the reaper requeue. Commit `a6b75fe4c08` is on `origin/main2` and the worktree is clean.

**What changed**
- **`scripts/jobs/root-repo-guard.sh`:** the guard now checks free disk bytes as well as free inodes (documented as invariant D2). It runs on every tick, right after the inode check.
  - **Threshold:** it reads free space from `df -Pk`, taking the block size from df's header, and alerts when it drops below `GARDEN_ROOT_GUARD_MIN_FREE_BYTES`. The default is 5 GiB; `0` turns the check off.
  - **Alert state:** the alert key is `root-repo-low-disk-bytes-$GARDEN`, and it clears itself on recovery.
  - **Unreadable `df` output:** this is counted tick by tick and pages after `GARDEN_ROOT_GUARD_BYTES_UNKNOWN_ALERTS_AT` consecutive misses, under the key `root-repo-bytes-check-unknown-$GARDEN`.
  - **Healthy line:** "root repo healthy" is now logged only when there is enough byte headroom too.
- **`scripts/jobs/test/root-repo-guard-test.sh`:** the fake `df` now answers `-Pk` separately. New CASE 20 covers alerting, recovery, 512-byte units, the off switch and repeated unreadable output. The test directory can be overridden with `ROOT_GUARD_TEST_DIR`, because the default under home is read-only in the monk sandbox and `/dev/shm` doesn't allow running scripts.

**Verification:** the full test suite passed, 89 checks with no failures. Running the guard against the real `df` on this host raised the alert correctly: 176.1 MiB available, below the 5 GiB threshold.

**Follow-ups**
- **The disk on host endolin-garden-ece02cb4 is nearly full now.** It had about 176 MiB free at the last check and briefly hit zero during the job. I messaged the maintainer to free space by hand under `.garden-state`, `scratch/` and `worktrees/`.
- **The alert only starts once this commit is deployed** to each host.
- **The 5 GiB floor is one setting for every host.** A host with a small disk may need its own `GARDEN_ROOT_GUARD_MIN_FREE_BYTES` to avoid constant alerts.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-byte-capacity-guard.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 4 tokens (85834 cached reads)
- Output: 1031 tokens
- Cost: $2.216258 (1 engagement(s) unpriced)
- Wall-clock: 389s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
