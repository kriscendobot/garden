**Verdict: degraded, on disk only.** The garden mount is 92% full with 41.6 GiB free. It has held flat for about 85 minutes, after falling about 1.2 GiB/h. Everything else checked is healthy:
- **Units and deploy:** 0 failed units, with oros deployed at `dd1eb97`. Main2 is ahead only by a docs change and this run's fix.
- **Workers:** 4 monks running, and no drain or derotation marker.
- **Budget heartbeat:** the last 9 pushes were all ok, the latest at 06:33Z.
- **Timeouts:** one rc=124 in 12h, classed as transient. This job's own first attempt also died (rc=75 after 18s), classed as transient and requeued.

**What changed**
- **False maintainer alert fixed (`1653f78`, comment corrected in `790ddd2`):** `requirements-watch` told the maintainer at 06:07Z that this job had been unclaimed for 1801s and no live host met its requirements.
  - **What actually happened:** oros claimed it at 05:44Z, and the reaper requeued it at 06:03Z with a retry back-off. The dwell timer had survived the claim, so **that notice can be ignored**.
  - **The fix:** the dwell timer now restarts when a job leaves todo, and a job in retry back-off doesn't count as waiting.
  - **Testing:** `host-requirements-gating-test.sh` passes 25 of 25, and 5 of the new checks fail against the old script. It runs on the leader and takes effect at the next deploy.
- **Health log:** the note is in `journal2:projects/garden/oros-health-log.md`.
- **On-host:** I removed no files by hand and touched no units, drains, leveling, budgets or schedules. Two `pkill -f` calls of mine matched their own shell and ended my diagnostic commands; nothing else was affected.

**Dep-cache eviction (`dd1eb97`), first run on real data**
- **Progress:** it works, removing 7 entries over 3 ticks. 11 renamed entries remain, about 2.5 more hours at that rate.
- **Free space:** there was no jump, and the "about 1 GiB each" estimate in the last note was too high. In one sampled entry, 681 of 693 MiB was in files with other hardlinks, so deleting it frees little.
- **Flat disk:** the timing fits eviction, but over only about an hour, so that isn't proven.

**Noise or not investigated**
- **Harmless:** the `overdue-holder ... worktree-sweeper` log lines are just the contention watch seeing the sweeper hold its private clone's lock, and they predate eviction.
- **Not investigated:** the published budget spend sat at 19997940 from 04:31 to 05:50Z because the scaler's readings were below it. It has since moved on.
- **Not read or re-measured:** I didn't read the report from `oros-health-watch-20261103-053509`, which had left doin by 06:38Z, or re-measure scratch.

**Needs a person at the Mac:** find what is using the roughly 300 GiB outside the garden tree (an estimate from the 03:08Z run's accounting). Eviction won't recover much on its own, and about 41 GiB is left.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261103-053509.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s) (1 unmetered)
- Input: 44 tokens (1755400 cached reads)
- Output: 27693 tokens
- Cost: $1.7031319999999999 (1 engagement(s) unpriced)
- Wall-clock: 1673s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
