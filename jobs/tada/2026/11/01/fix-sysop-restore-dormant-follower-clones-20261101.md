**Completion report: fix-sysop-restore-dormant-follower-clones-20261101**

I fixed the sysop `restore` failure on followers and pushed it to main2 as `a60ae08cc14`. The full `scripts/jobs/test/sysop-test.sh` suite passes (62 PASS, 0 FAIL), including the new cases. I chose directions (a) and (c); (b) is left as a follow-up below.

**Root cause:**
- **Stale clones:** on a follower, `garden-reaper` and `garden-deadmail` never run because their units only start on the leader. Their state clones therefore sat weeks out of date, and `restore` ran both anyway. Each one's first sync of the stale clone took longer than the 150s step budget, so the op failed.
- **Orphaned git processes:** the restore step's `timeout 150` only signals its own process group. The git wrapper runs each git command under a second `timeout` in a new process group, so killing `reaper.sh` left its `reset --hard` children running, still holding the clone's repo lock. I reproduced this on its own: the nested child survives a plain outer `timeout`.

**Changes in `scripts/jobs/sysop.sh`:**
- **(a) Follower skip:** `restore` now runs `reaper.sh` and `deadmail.sh` only when `is_main_host` says this host is the leader. A follower runs `reset-failed`, reports `accepted-and-applied`, and the detail says the two steps were skipped because the leader owns them. This matches designs/sysop.md §4/§9: the op still runs only the scripted recovery steps, never the judgement half of restore.
- **(c) Whole-tree kill:** a new `restore_step <secs> <cmd…>` helper runs each step in the background with a wall-clock budget. When the budget runs out, it kills the step's whole process tree using the existing `reap_process_tree` from common.sh, including git's separate process groups. It returns 124 on expiry, so the op is still recorded as failed and the next step still runs.

**Tests (`scripts/jobs/test/sysop-test.sh`):**
- The existing restore tests now run the target as leader.
- New: a follower restore runs only `reset-failed`, skips reaper and deadmail, reports applied and notes the skip.
- New: when a step runs out of time, a child in its own process group (the same shape as the git wrapper) is killed and the op reports failed.

**Docs:** I updated the `restore` row in `designs/sysop.md` §4 and the `restore` note in `context/operations/host-operations.md`.

**Follow-ups (not done):**
- **(b) Stale clones on promotion:** if a follower is promoted to leader, the first runs of its stale leader-only services will still hit the same slow first sync. That covers reaper, deadmail, foreman, deadline-nudge, requirements-watch, library-source-drift-scan, transcripts, reducer and self-heal. The fix would be to keep those clones synced on followers, or re-clone any that are stale beyond N days, in state-clone-keeper.
- **Old processes:** the change takes effect when the deploy reaches oros-studio. Any orphaned processes from the 2026-11-01 run have long since exited, because the git wrapper's own 900s limit stops them.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-sysop-restore-dormant-follower-clones-20261101.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1275145 cached reads)
- Output: 14490 tokens
- Cost: $1.081317
- Wall-clock: 360s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
