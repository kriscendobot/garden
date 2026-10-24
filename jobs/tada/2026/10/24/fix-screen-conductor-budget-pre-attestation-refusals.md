I fixed the conductor budget in the screener, and the fix is pushed to main2 as commit `30037a3dada`. Conductors that the panel-freshness gate refused before a head had an exact panel no longer count toward that head's 3-attempt budget.

**How it decides.** Conductor reports don't carry a completion time, so I couldn't compare against `screened_at`. Instead `conductor()` in `scripts/jobs/screening/driver.py` reads the `## Panel-head freshness` / `Disposition: **review required**` section that `gardener.sh` stamps into a refused conductor's report. If the panel named there differs from the `panel_head` on the attestation, that conductor ran before the exact panel existed and never really tried to merge. It is skipped, and the screen posts the next free name (`-r4`, `-r5`, …).

**What still stalls.** All other finished conductors count: genuine failures, and refusals that name the attested panel. Three of those still produce the STALLED notice. I also added a hard ceiling of 10 conductor names per head, so no report shape can make re-posting unbounded. The STALLED notice now states how many conductors actually failed.

**Tests.** I added two regression tests to `scripts/jobs/test/minion-town-screening-test.py`:
- Three pre-attestation refusals plus an exact attestation: `-r4` is posted with no stall notice. Three more failures after that (`-r4` to `-r6`) give exactly one STALLED notice.
- Three refusals that name the attested panel head: no conductor is posted, and one STALLED notice is sent.

The full screening suite passes (37 tests). Shellcheck on the screening shell scripts shows only SC1091 "not following `common.sh`" info notes, in files this change doesn't touch.

**For #218.** kriscendobot/minion.town#218 at `5e2b623` should get `screen-minion-town-pr218-5e2b623-conduct-r4` on the first screen tick after this commit reaches the deployed root checkout. If it doesn't, check whether the deploy has caught up before looking further.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fix-screen-conductor-budget-pre-attestation-refusals.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (662769 cached reads)
- Output: 7197 tokens
- Cost: $0.7988458
- Wall-clock: 164s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
