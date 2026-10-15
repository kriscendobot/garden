**Verdict: degraded.** Writes to journal2 through the shared producer clone take about 45s per push attempt. So even though only about 2 commits a minute land on journal2, these writes keep losing the push race. The host itself is otherwise fine. The note is on journal2 in `projects/garden/oros-health-log.md`.

**Snapshot**
- **Load and memory:** load 3.1/3.3/3.7, 12 of 15 GiB available.
- **Disk and inodes:** disk 6% used (405G free), inodes 1%.
- **Uptime:** 13d13h, no reboot.
- **Units:** 0 failed of 292. Monks 1 to 6 are running. The host is not draining, and the only derotation marker is endolin-garden2's.
- **Deploy:** oros runs `cbef9daa`; origin/main2 is `e646acc3`, one commit ahead. fleet/health shows `roll_status: deferred` because monk 3 has a long job (1796s at 06:47Z). That is the normal long-job rule and nothing is blocking, so I didn't step in.
- **Budget heartbeat:** claude-oros was sampled at 06:32Z, status ok, 11% used. Pushes are landing every 15 minutes. It is unaffected because it already pushes without resetting a working copy.
- **State clones:** 76 clones, all at or below the 50-pack gc threshold, with no tmp_pack and no `gc.log`. The `.lock` files are long-lived flock files, not stale locks.
- **rc=124 (last 3h):** one monk/4 gauntlet job hit its 7200s wall clock and was classed as transient. The rest are the contention-watch deferrals below.

**What I found**
- From 05:18Z, `garden-journal-contention-watch` failed on every tick (rc=124) to deliver a "cleared" notice for the root journal. The original alert sat unread in the maintainer inbox.
- The cause is in `watchdog-notice.sh`. It refreshes the shared producer clone with `git reset --hard origin/journal2`, and right now each reset takes 20–30s. The resets also run one at a time behind the clone's repo lock. A delivery attempt costs about 45–60s, and the watch only gives deliveries about 80s per tick, so one lost race uses up the window.
- A read-only index refresh of that clone takes 1.8s. So the time goes to the reset's write path or to waiting for the lock, not to checking files.
- `post-job.sh` has the same problem: my first post lost 7 races and hit its 300s deadline (rc=75). This matches the 10-01 diagnosis that heartbeat gaps come from lost pushes under load.

**What I changed**
- **Stuck notice:** delivered it by hand with a 900s limit. It took 188s and 3 attempts, and the notice now reads RECOVERED. The watch's next tick cleared its own pending state.
- **Orphaned reset:** killed a `git reset` I had started for diagnosis and left behind when my own command timed out. It briefly held the producer clone's `index.lock`.
- **Follow-up job:** posted `watchdog-notice-worktreeless-cas` (fixer, todo/) to switch `watchdog-notice.sh` to the same no-reset push the usage meter, fleet health and journal-entry writers already use (`ec4cc369`, `0411ed9f`, `bdc2943c`, `ca5aa15d`). No such job existed. It took a second try with `GARDEN_POST_DEADLINE_SECS=540` to post.
- No garden code changed on main2 this run, and I didn't touch drains, worker leveling, derotation, budgets or schedules.

**Needs a person:** nothing new. The open question from 10-14 about how long to keep `journal-worktree-keeper/backups` still stands. If `post-job.sh` keeps hitting its deadline on oros, raising its default deadline or switching it to the no-reset push too would be the next step.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261015-062034.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 100 tokens (3617312 cached reads)
- Output: 24717 tokens
- Cost: $1.9168183999999995
- Wall-clock: 2576s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
