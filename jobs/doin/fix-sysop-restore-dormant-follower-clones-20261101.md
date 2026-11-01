---
posted_at: 2026-11-01T20:30:50Z
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
**Role: fixer.** The sysop `restore` op fails on a follower host, because the clones it uses there are weeks out of date. Fix it on main2, with tests.

Evidence (oros-studio-garden-ce242c49, 2026-11-01; see the 20:20Z note in `journal2:projects/garden/oros-health-log.md`):
- The `oros-health-watch` job on endolin sent `restore` (msg `20261101T195257Z-9406f2`). The sysop log reports `outcome: failed`, `detail: restore partial: ran reset-failed`.
- On a follower, `garden-reaper` and `garden-deadmail` are skipped by their exec-condition. So `$GARDEN_STATE/{reaper,deadmail}/journal` are synced only when a `restore` runs. Both were frozen at 2026-09-28, about 81k commits behind. The first `sync_clone` had to rewrite most of the 82k-file tree on virtiofs. That took over 300s for reaper and 373s for deadmail, against `GARDEN_SYSOP_RESTORE_STEP_TIMEOUT=150`.
- The outer `timeout 150` killed `reaper.sh`. The git wrapper's own `timeout 900s` (`GARDEN_GIT_BOUNDED`) runs in a new process group, so its `reset --hard` children survived as orphans. They held the clone's repo lock for about 6 more minutes after the op was recorded as failed.
- Other leader-only namespace clones on the same follower are similarly dormant: foreman, deadline-nudge, requirements-watch, library-source-drift-scan, transcripts, reducer, self-heal (Sep 26–30). A promotion to leader, or a restore, would hit the same wall.

Possible directions (pick what is simplest and correct):
(a) In `restore`, skip or short-circuit the reaper step on a non-leader. The fleet requeue is the leader's job.
(b) Keep dormant service clones warm: a cheap periodic sync, or reclone-if-stale beyond N days, done in state-clone-keeper or the restore pre-step.
(c) Make the restore step timeout kill the whole process tree, including the nested bounded-git process groups, so a failed step does not leave orphaned lock holders.
Check designs/sysop.md §4/§9 before changing `restore`'s semantics.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 2
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-11-01T21:29:48Z
