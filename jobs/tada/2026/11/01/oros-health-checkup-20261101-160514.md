**Verdict: degraded, now fixed.** The garden's shared disk (the virtiofs mount) was 91% full, with only 43G free. I freed 47.5G by deleting leftover build files, and it is now at 81% with 88G free. Everything else checked out healthy.

- **Disk:** the space went to `scratch/tenth-target-test/`, a 46G Rust build cache, plus its 1.5G sibling `scratch/tenth-target/`. Both were left behind by `ironhorse-test262-ratchet-coverage-crank-tenth-slice-20261101`. That job finished at 14:52Z, and the follow-up job that opened its PR finished on endolin at 15:02Z. Nothing had written to the cache since 14:41Z, and no running process was using it, so I deleted both. This also explains most of the growth the 13:20Z check-up flagged.
- **Deploy:** oros is running `d1e41a9`, the current tip of main2: 0 of 290 units failing, roll status `deployed`. The stuck deploy pause (drain) from the 13:20Z check-up has cleared, and the host is no longer draining.
- **Workers and units:** all four workers are running. The worker setting is still `4 0`, there is no derotation marker, and no units have failed.
- **Budget heartbeat:** the last push was at 16:04Z. Every push in the past two hours succeeded, about every 15 minutes. Spend is 10.0M of 180M.
- **Load and memory:** load is about 3.4, the usual level; 12 GiB of 15 GiB memory is free. Uptime is 31 days with no reboot.
- **Journal clones:** 84 clones; the biggest is at 50 packs, the cleanup threshold but not over it. No failed-gc log (`gc.log`), and the four git locks present were all under 5 minutes old, so in use. A deeper scan for leftover locks and temporary pack files timed out on the shared disk and did not finish.
- **Timeouts (last 3 hours):** one harmless deferred notice from `journal-contention-watch`. No killed processes and no failed services.

**Changed:** I deleted the two leftover build caches and added this run's note to `projects/garden/oros-health-log.md` on `journal2`. I made no code changes and did not touch drains, worker settings, budgets or schedules.

**Follow-up for the maintainer:** jobs that build ironhorse leave multi-gigabyte build caches in `scratch/` after they finish. Older ones are still there: `cargo-target-pr1379`, `-pr1527`, `-pr1531`, `-pr1533`, `-pr1535`, `-pr1535-188` and `-hostcall` (from Sep–Oct), plus `cargo-target-pr1614` from today. I did not measure their sizes because measuring is slow on the shared disk. It may be worth having the worktree sweeper delete `scratch/` build caches whose job has finished.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261101-160514.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (1681974 cached reads)
- Output: 9460 tokens
- Cost: $0.9922828
- Wall-clock: 2023s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
