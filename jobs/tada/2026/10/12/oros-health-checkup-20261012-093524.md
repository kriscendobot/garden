## oros-health-checkup-20261012-093524: **degraded**

oros is still 15 commits behind main2. The deploy gate passed, but the deploy itself was blocked, and this check-up job was one of the two in-flight gardener jobs blocking it. I couldn't land the health-log note, so it is in this report instead.

**Snapshot (10:22–10:45Z):**
- **Load and memory:** load 5.3/4.7/4.8; 12 of 15 GiB available; swap 341 MiB used. IO pressure is low (some avg300 2.2%).
- **Disk and inodes:** disk 6% used (405 GB free), inodes 1%. Uptime 10d17h, no recent reboot.
- **Deployed vs main2:** deployed `78f9dacc`, origin/main2 is `8da29934` (15 behind).
- **Deploy timeline:**
  - **09:25:** self-deploy started toward `3935f665`. deploy-garden then waited about 39 min on `producer/journal.lock` and was killed by the 2400s self-heal timeout at 10:04.
  - **10:18:** the leader marked oros's canary FAILED and drained it.
  - **10:17:** a new attempt toward `8da29934` started. Its candidate gate **passed** at 10:28 (about 11 min).
  - **10:38:** that attempt **aborted** because the 600s quiesce timed out with 2 jobs still running, this check-up being one of them. The drain was gone by 10:43.
  - **10:39:** another attempt started its gate. It was still running when I finished.
- **Failed units:** 2. `worktree-sweeper` failed because the hard reset of its journal clone hit the 120s git bound. `regenerate-sections-index` failed on the same journal-git slowness.
- **Budget meter:** last claude-oros snapshot at 10:05:40; 56.6M of 180M (22%); status ok.
- **Fleet/health:** the root journal copy, which may be stale, shows `deferred` for `563e6db8` as of 07:36. The other hosts' rows are from Oct 9.
- **Workers:** 5 monks running. I touched no derotation markers.
- **rc=124 timeouts:** 348 in the last 3h, almost all journal-clone git operations hitting the 120s bound (self-heal, unblock, sysop, state-clone-keeper, gardener-scaler).
- **State clones:** 232 journal clones or seeds under `$GARDEN_STATE`, including 89 `inbox/` dirs. They aren't exhausting inodes yet. Each journal checkout is about 100k files (a 9.4 MB index), so every `reset --hard` on this bind mount takes minutes. That is the root of the timeouts and lock contention.

**What I changed:**
- Ran `reset-failed` on the 2 failed units.
- Re-synced the worktree-sweeper's journal clone with a longer bound; it succeeded.
- Nothing else. I did not touch drains, worker leveling, derotation, budget pools or schedules.

**Not done:**
- **Health-log note:** I could not land it. `land-journal-edit.sh` timed out twice (400s, then 240s) waiting on the `producer/journal` clone lock, which is the same contention the log describes. The note's content is the snapshot above.
- **Clone-size survey:** stopped. The `du` over the state clones hit its background time limit, so I have no per-clone sizes or pack counts this run.

**Needs the maintainer:**
1. **This check-up blocks oros's deploy.** It is pinned to oros and runs 30–45 min, which outlasts deploy-garden's 600s quiesce window, so a deploy that starts during a check-up aborts. Options: skip or yield the check-up while oros has a pending roll release or a drain, or make deploy-garden not count this job as mid-job. I haven't posted a fix; this needs a decision.
2. **Every journal sync on oros is slow.** Each state clone checks out the full ~100k-file journal2 tree on the bind mount, so syncs and resets regularly exceed 120s. That starves the shared `producer/journal` lock: self-deploy lost 39 min to it, and this run's log edit lost 11 min. A sparse checkout for state clones, or moving `$GARDEN_STATE` off the bind mount, would be the structural fix. That is a design decision, not an on-host fix.
3. **Deploy still unconfirmed:** the 10:39 attempt to reach `8da29934` was still running when I finished. The next check-up should confirm whether it landed.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261012-093524.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (1976803 cached reads)
- Output: 13768 tokens
- Cost: $1.2617366000000003
- Wall-clock: 1607s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
