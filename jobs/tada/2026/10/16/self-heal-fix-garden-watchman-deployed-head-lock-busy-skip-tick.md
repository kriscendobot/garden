Fixed and pushed to `main2` as `9bad5343691`. The watchman no longer exits FATAL when the root repo lock is busy for the whole retry window. It logs `WARN: root repo lock busy; skipping tick` and exits 0, so the next timer tick retries. Both affected test suites pass: wedge-resolve-test 45/0 and main-host-test 54/0.

**What changed in `scripts/jobs/watchman.sh`**
- I chose the stderr-matching option rather than a new exit code from `common.sh`. The wrapper's 124 can't be told apart from git's own 124 timeout kill, and other callers (common.sh ~L5005, ~L5517) already check for 124. Changing it would have been more invasive.
- A new helper, `watchman_rev_parse`, captures rev-parse's stderr and flags lock contention when it sees `garden repo lock: timeout after …` or `lock file kept being replaced`.
- If HEAD is still unresolved after the 3 attempts and the last failure was lock contention, the tick is skipped with exit 0. A HEAD that fails with no lock contention still hits `die`.
- The `origin/$GARDEN_MAIN_BRANCH` rev-parse gets the same skip-on-busy treatment. Without contention it still falls back to the local SHA, as before.
- The optional holder logging is in: the wrapper's lock lines are logged, plus a `root repo lock holder pid=N: <cmdline>` line read from `/proc/N/cmdline`, so a long-held exclusive lock (deploy, repack) shows its command.

**What changed in `scripts/jobs/test/wedge-resolve-test.sh`**
- New `WATCHMAN/LOCK-BUSY-SKIP` cases:
  - HEAD busy on every attempt gives rc 0, the skip line, no FATAL, all 3 attempts made, and the holder command logged.
  - `origin/main2` busy gives rc 0 and the skip line.
  - An unresolvable HEAD with no lock contention is still FATAL.
- Three existing problems stopped the suite from running on this host, so I fixed them in the same commit:
  - **Hardcoded path:** the scratch directory was `/home/kris/.garden-wedge-test`. It now uses `mktemp -d` under `$TMPDIR`.
  - **Infinite recursion:** the existing lock-retry fixture's git shim called whatever `command -v git` found, which on a gardener's PATH is the fleet `bin/git` wrapper. The wrapper calls the shim again, so it never ended; my first test run hung until it was killed. The shim now calls the first git on PATH that isn't the wrapper.
  - **Fixture clones failing:** clones aborted with `hardlink different from source` on this filesystem. They now use `--no-hardlinks`.

**Follow-ups:** none required. The holder logging should name what held the lock in the next incident like pid 1843294's; if it's repeatedly maintain/repack or deploy, those holds may be worth shortening.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-watchman-deployed-head-lock-busy-skip-tick.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 46 tokens (1588823 cached reads)
- Output: 14022 tokens
- Cost: $1.2049565999999998
- Wall-clock: 2303s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
