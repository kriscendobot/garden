## Completion report: `improve-issue-inbox-cgroup-reap-single-pass`

I replaced the one-pass cgroup cleanup in `scripts/jobs/issue-inbox-watcher.sh` with the bounded loop from comment-watcher.sh. `dependabot-watcher.sh` had the same one-pass cleanup, so it got the same fix. The change is pushed to `main2` as `84d6fb858d6`. It reaches the watchers on the next rolling deploy.

**What changed**
- **`issue-inbox-watcher.sh`:** `reap_cgroup_stragglers()` now works like the one in comment-watcher.sh:
  - On every pass it re-reads `cgroup.procs`, force-kills any leftover child, and returns only when none are left. That closes both gaps: a git helper forked after the first read is caught on the next pass, and the watcher no longer exits before a killed process has actually gone.
  - The loop stops after `GARDEN_ISSUE_CGROUP_REAP_DEADLINE_SECS` (default 3s). If a process can't be killed by then, it logs a WARN and returns.
  - A new `_straggler_alive` helper reads the process state from `/proc`, so a dead but unreaped (zombie) process no longer counts as left over.
  - It still does nothing outside its own `garden-issue-inbox*.service` cgroup, and it never kills itself or its parent processes.
  - There is a test-only override, `GARDEN_ISSUE_CGROUP_PROCS_FILE`, which only takes effect when `_in_test_context` is true.
- **`dependabot-watcher.sh`:** the same port, with `GARDEN_DEPENDABOT_CGROUP_{PROCS_FILE,REAP_DEADLINE_SECS}`.
- **Tests:**
  - New case REAP in `test/issue-inbox-watcher-test.sh` and case R in `test/dependabot-watcher-test.sh`. Each starts two leftover processes in their own sessions, lists them in a fake `cgroup.procs`, runs one tick, and checks that both are dead when the watcher returns.
  - I ran the issue-inbox test against the old one-pass code and it fails, so it catches this bug.

**Checks run**
- `issue-inbox-watcher-test`: 45/45 pass.
- `dependabot-watcher-test`: 52/52 pass.
- `issue-inbox-tick-bounds`, `issue-inbox-journal-linkage` and `dependabotany-preflight` tests all pass.
- shellcheck at warning level shows no new findings in the four touched files.

**Other watchers**
- **Already fixed:** `receipt-watcher.sh` and `triager.sh` already have the bounded loop.
- **No cgroup cleanup at all:** `ci-watcher.sh`, `pages-watcher.sh` and `approval-reconciler.sh` only kill their own process group. That group kill doesn't reach a git helper that has moved into a different group, and nothing sweeps the cgroup when a tick ends normally. So they can in principle leak the same way. No failure has been seen from them, so I left them alone and did not post a job. Adding the same loop would be a small follow-up if they ever show the "left-over process" warning.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-issue-inbox-cgroup-reap-single-pass.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 34 tokens (1090159 cached reads)
- Output: 12406 tokens
- Cost: $1.0461277999999998
- Wall-clock: 211s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
