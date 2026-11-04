**Verdict: degraded.** oros is working again after a 10.5-hour drain, but it hasn't deployed: it's still on `746d220507c`, and main2 is `36a2080657e`.

**Health**
- **Load and memory:** load 3.78, 12 GiB of 15 GiB available, swap full (unchanged), no memory pressure.
- **Uptime and units:** up 34 days with no reboot; 0 of 289 units failing. Monks 1–3 are running, with no derotation marker on the journal.
- **Disk:** 36.7 GiB free on the garden mount (93%), below the 37.7 GiB low in the 08:32Z note; I didn't trace what used it. Inodes are at 3%.
- **Budget meter:** the last push was 22:46Z and the recent pushes are all ok. Spend reads 20% and was flat from 12:32Z only because the host was drained.
- **Clones and locks:** no bloated clones or `gc.log` files. Root `.git` has 50 packs, up from 13 at 08:32Z, with no stale locks at shallow depth. The `$GARDEN_STATE` lock search timed out with no match, so it's partial.
- **Timeouts:** no `rc=124` in the last 3h.

**The drain**
- The leader's roll drained oros at 12:16Z after canary `7f0c3f7cd1c` failed validation, and endolin sent `drain off` at 22:48Z and 22:52Z.
- `unblock-oros-canary-drain-20261104` on endolin owns why the canary failed, so I didn't diagnose it or post a duplicate.
- oros was reporting `deferred` around that halt, so check whether the leader counted a deferral as a canary failure. I didn't confirm that.

**What's blocking the deploy**
- The candidate gate for `1f59625d7b3` passed at 23:05:30Z after about 4.5 minutes. `deploy-garden` then deferred one second later because monk 3 was 446s into a job.
- That job is health check-up `185019`, so the check-up backlog itself is holding the deploy. The drain queued several check-ups, and they took all three monks when it lifted.
- The deploy needs a moment when no monk is over 300s mid-job. It should retry as these jobs finish, but one more check-up, the 22:05 run, was still queued at the 23:05Z note.
- `fleet/health` still read `deferred` from 23:05:32Z at 23:14Z.

**What I changed**
- **Host:** nothing; I found nothing that needed gc, lock clearing or a restart. I also left the 252 `/tmp/deploy-www-*` directories alone (tidiness only).
- **Journal:** I added a short note to `projects/garden/oros-health-log.md` on top of the two sibling notes; the full snapshot is in the 23:05Z one. It says delivery to `185019` was unconfirmed, but that message has since arrived (23:13Z).
- **Sibling check-ups:** I asked `155009` and `185019` to finish quickly. My message said this run would handle the log note and cleanup, but `155009` had already landed the full snapshot and neither needed doing.
- **Code:** no garden code changes.

**For the maintainer or the unblock job**
- **Check-up pile-up:** the scheduler kept dispatching this pinned check-up while oros was drained, so the backlog then competed with the deploy. Schedules are out of scope for this job, so I left that alone; the fix would be not stacking runs for a drained host.
- **Minion.town `/tmp` residue:** this is still open from the 08:32Z note.

Nothing needs a person at the machine right now.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261104-123510.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (859173 cached reads)
- Output: 13436 tokens
- Cost: $1.0487386
- Wall-clock: 964s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
