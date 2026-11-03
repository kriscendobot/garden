**Verdict: degraded.** Disk is the standing problem, and two new bursts of slow journal fetches appeared today. Otherwise healthy: 0 failed units, 4 monks running, no drain or derotation marker. Budget pushes are ok (last at 12:33Z), and spend read 4.39M of 180M after the 11:00Z weekly reset.

**Findings**
- **Disk:** about 40 GiB free (92%), down about 4 GiB since 09:10Z.
- **Deploy:** oros runs `790ddd2691b` with `roll_status: deployed`. origin/main2 is now `40e4859456a`, this run's fix, and I found nothing blocking the roll.
- **Slow-fetch bursts:** 11:20–11:29Z and 12:10–12:19Z.
    - Two journal fetches hit rc=124, and five self-heal handlers hit the 600s limit, with none earlier in the 24h journal window.
    - My own fetch took 4s at 12:39Z, between bursts.
    - I did not find the trigger.
- **Defect:** the contention watch retried failed clone rebuilds a tick or two later, with no backoff.
    - Each attempt moves the live clone aside and writes about 83k files. It then gets killed at about 150s and restores the clone.
    - Today that was 9 attempts and 0 finished rebuilds. On 11-01 it was 18 attempts and 3 finished.
    - The leader clone was missing during an attempt at 12:39Z and was back by 12:42Z.
    - Whether these attempts prolong the slowness is not proven.
- **Not a host fault:** 12 `run-u*.service` failures at 10:47 and 10:57Z came from a `sudo` probe of `GUEST_RECOVERY_KEY` whose environment file is missing. I did not trace which job ran it.

**Changed**
- **Fix landed on main2 (`40e4859456a`):** a failed rebuild now waits `GARDEN_CONTENTION_REMEDY_FAIL_BACKOFF` (1h) before retrying, and its leftover seed directory is queued for cleanup. `journal-contention-watch-test.sh` passes and its new check fails against the old script. It takes effect on oros at the next deploy, so it has not run on real data yet.
- **On the host:** I removed three seed directories whose owner process was dead (library-link-check, state-clone-keeper, leader). I touched no units, drains, leveling or schedules.
- **Health log:** note landed in `journal2:projects/garden/oros-health-log.md`.

**Not checked:** scratch size, lock files in `$GARDEN_STATE` outside the monk and monitor clones, the spend steps after the reset, and the sibling `oros-health-watch` report (still in doin).

**Needs the maintainer:** someone at the Mac should find what is using the roughly 300 GiB outside the garden tree.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261103-115009.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1617216 cached reads)
- Output: 28357 tokens
- Cost: $1.8456471999999997
- Wall-clock: 1329s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
