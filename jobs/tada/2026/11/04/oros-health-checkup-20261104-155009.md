**Verdict: degraded.** oros-studio has been back in service since about 22:49Z, but it's still on `746d220507c`, behind main2 `36a2080657e`. No units are failing.

**Findings**
- **Drain:** the rolling deploy drained oros at 12:16Z after canary `7f0c3f7cd1c` failed ("retries exhausted"). endolin sent `drain off` at 22:48Z and 22:52Z, so that was about 10.5 hours with no work; spend stayed flat from 12:32Z.
- **Canary failure cause:** I didn't establish it. `unblock-oros-canary-drain-20261104` owns that and has asked check-up `185019` for the evidence.
- **Deploy:** the gate for `1f59625d7b3` started at 23:00:57Z, then deferred at 23:05:46Z behind monk 3 (446s). The deferred status was published and nothing advanced.
- **Cause of the deferral:** monk 3 is on check-up `185019`, one of three queued check-ups (`123510`, `155009`, `185019`) claimed at 22:57–22:58Z, which took all three monks. `220524` is still in todo, so it could hold up the deploy again.
- **Host health:**
    - Load is 2.05, with 12 GiB of 15 GiB memory available.
    - Swap is still full.
    - Inodes are at 3%, and there has been no reboot in 34 days.
- **Budget heartbeat:** last push was 22:46:43Z and the recent pushes are all ok. Spend is 20% of the cap.
- **Timeouts:** no `rc=124` lines in the last 8 hours.
- **Worth watching:**
    - The garden mount is at 93% with 37 GiB free, the low end of the past day's range. I didn't trace what's using it.
    - The root `.git` has 51 packs, up from 13 at 08:32Z, with no `gc.log`. I left it alone.
    - My `*.lock` search of `$GARDEN_STATE` hit its time limit, so that check is incomplete.

**Changed**
- **Health log:** I added one note to `journal2:projects/garden/oros-health-log.md`. It says the gate was still running and that check-ups could defer the deploy; the deferral above is newer than the note.
- **Host and code:** I changed nothing on the host and landed no garden code. I also left the 96 old `/tmp/deploy-www-*` directories in place, because `123510` is doing the on-host cleanup and asked the other check-ups to finish quickly.

**Needs follow-up (nobody needed at the machine yet)**
- **Deploy:** it should retry once the long check-ups finish. `123510` is watching it, and `unblock-oros-canary-drain-20261104` needs to confirm the canary passes.
- **Maintainer, check-up backlog:** the scheduler kept dispatching this pinned check-up while oros was drained. The backlog then filled every worker slot and deferred the deploy it was meant to help. I didn't read how the scheduler handles this, and schedules are out of scope for this job.
- **Maintainer, stale alert:** the inbox notice `rolling-deploy-canary-failed` still says this is a confirmed regression, which nothing here has confirmed. The notice also says the canary was retried three times.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261104-155009.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (1252236 cached reads)
- Output: 18664 tokens
- Cost: $1.3866872000000001
- Wall-clock: 531s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
