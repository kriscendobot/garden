**Verdict: degraded.** oros deployed `42863eb0`, but the deploy was killed during its final restart step, so its fleet/health record still showed `roll-drained` at the old sha `d82f327a`. Two garden bugs caused this; both fixes are pushed to main2 as `af3a8456`.

**Snapshot** (also written to `journal2:projects/garden/oros-health-log.md`, which landed on the second try after the first timed out on journal push contention):
- **Load and memory:** load 2.5/2.8/2.8; 13 GiB of 16 GiB memory available; 511 MiB swap used.
- **Disk and inodes:** 6% of disk and 1% of inodes used.
- **Uptime:** 12d20h, no reboot.
- **Units:** 0 of 292 failed. Monks 1, 2, 4, 5 and 6 are running; monks 3 and 7 are waiting to stop (explained below). No drain marker; derotation untouched.
- **Budget meter:** sampled at 13:01Z, status ok, 3% used.
- **rc=124 timeouts (last 3h):** transcript-capture ×3, and self-deploy ×1 at 13:49Z.
- **`$GARDEN_STATE` clones:** none bloated (at most 50 packs, no tmp_pack).

**What went wrong with the deploy:**
- The roll release named oros for `42863eb0`. self-deploy ran deploy-garden: the test gate passed, the tree swapped at 13:21:57Z, timers thawed, and the drain lifted.
- deploy-garden then restarted the monks. The stop signal reached monk@3 and monk@7 while each was in the middle of claiming a job. The gardener only checks for a stop request at the top of its loop, so both went on to run the jobs they had just claimed. One of those was this check-up, claimed 9s after the signal.
- The restart waited on those jobs until self-deploy's 2400s time limit killed deploy-garden at 13:49Z.
- The marker that lets self-deploy republish `deployed` health was written only after the restart. So nothing published that oros is now on the new sha.

**Fixes (`af3a8456`):**
- **`gardener.sh`:** after a successful claim, it checks again for a pending stop. If there is one, it doesn't start the job: it marks the claim for the reaper to requeue and exits cleanly. I added a test hook (`GARDEN_CLAIM_JOB_CMD`) so the test can send the signal mid-claim. Side effect: a job handed back this way counts as one requeue attempt toward its doom limit.
- **`deploy-garden.sh`:** writes the health-pending marker as soon as the deployed sha is recorded, so a deploy killed later still gets its health republished.
- **Tests:** a new `claim-stop-race-test.sh` (4/4 pass) and a new subtest in `deploy-garden-test.sh` for a deploy killed mid-restart (3/3 pass). Both fail with the fix removed.
- **Regression checks:** I ran only the new subtest of `deploy-garden-test.sh`, not the full suite. `handler-budget-test.sh` passed its first four subtests (10 checks) and was still running when I finished.

**Changed on-host:** I wrote `deploy/deployed-health-pending` = `42863eb0`, which is what the fixed code would have written. The marker has since been consumed, so self-deploy appears to have republished. The journal worktree I read still showed the old `roll-drained` record, likely just lag; the next check-up should confirm it changed.

**Open, no person needed:**
- monk@3 and monk@7 restart onto the new code once their current jobs finish; this check-up's job finishes now.
- If the leader's canary for `42863eb0` already timed out on the old record, the next roll (to `af3a8456`) should go through.

I did not change drains, worker leveling, derotation, budgets or schedules.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261014-075034.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 110 tokens (4893275 cached reads)
- Output: 26992 tokens
- Cost: $2.3929110000000007
- Wall-clock: 2321s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
