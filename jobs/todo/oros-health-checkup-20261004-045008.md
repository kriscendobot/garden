---
handler-timeout: 3600
---

---
role: fixer
requires: host=oros-studio-garden-ce242c49
handler-timeout: 3600
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: fixer.** **Recurring oros-studio host health check-up (every 3h, pinned to oros).** Assess and improve the health of **oros-studio-garden-ce242c49** from the inside. A sibling watcher, `oros-health-watch`, pinned to the leader and staggered after you, checks that you were claimed and are making progress. If you stall, it intervenes through the sysop bridge.

Standing maintainer request (kriskowal, 2026-10-02). Background is in the 2026-10-01 diagnosis `fix-oros-heartbeat-canary-drain-20261001` (its tada report):
- heartbeat gaps come from journal CAS push losses under load;
- deploy-gate suites time out under load;
- self-deploy's leaderless fallback lifted a roll drain;
- fixes landed on main2 as `25e98fcd` and `2e8aedf5`, but oros still runs `e036bb8e`.

**Each run (keep it bounded; this recurs):**
1. **Snapshot health and record it** (one short note appended to `journal2:projects/garden/oros-health-log.md` via `scripts/jobs/land-journal-edit.sh`, newest first):
   - load average and memory;
   - disk and inodes;
   - container uptime and recent reboots;
   - deployed sha vs origin/main2;
   - unit failures;
   - the age of the last `budget/live/claude-oros/oros-studio-garden-ce242c49` snapshot and its last few push results;
   - the fleet/health roll_status;
   - the worker count, and drain/derotation state;
   - `$GARDEN_STATE` journal-clone sizes and stale locks;
   - recent rc=124 timeouts.
2. **Improve what is safely fixable on-host:**
   - gc or re-clone bloated state clones;
   - clear stale locks;
   - `reset-failed`;
   - restart a stuck garden timer or service;
   - prune the inode leak (per-id journal clones);
   - restart the meter publication if it is stuck.
3. **Help oros deploy.** If oros is behind main2 and a roll release names it, check why self-deploy is deferring or aborting (gate timeouts, long jobs). When safe, help the deploy along, for example by waiting for the gate during a quiet moment. Do not hand-edit drains or worker leveling; report what blocks the deploy.
4. **Garden code bugs:** land them on main2 with tests. Don't post duplicates if a fix already exists.
5. **Report:** one line of verdict (healthy / degraded / unhealthy), what you changed, and what needs a person at the machine or the maintainer. Keep the run under about 45 minutes. If it is healthy and there is nothing to fix, say so and finish quickly.

Do not change drains, worker leveling, derotation markers, budget pools or schedules. The maintainer's 90% quota policy stands.
