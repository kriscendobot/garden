---
handed-off: fu-minion-town-containment-gateway-endo-sock-1-20260930-015006-split
deliverable-complete: false
---
I treated this overrun as **indivisible** and handed it off to a single-child split orchestration. The containment check itself did not run in this claim, so there's no scan result yet; the child job will produce it.

**Why it doesn't split:** the job is one scan, fix, rescan cycle against a single live store (`/var/lib/endo-gateway/store/vhosts/`, reached over SSM). Any fix has to be proven by a rescan in the same run, so no piece stands on its own. The 2400s overrun came from doing the scan by hand. That work is now a script: `scripts/jobs/containment-gateway-record-check.sh` (main2 `2a5c1991779`), which gives up after 90 seconds.

**What's on the board now:**
- **Child job** `fu-minion-town-containment-gateway-endo-sock-1-20260930-015006-expanded-window`, parked as orchestrated with `handler-timeout: 3600` and the reason above. Its body tells the gardener to:
  - run the script with `--verbose`, or run it from a main2 worktree if the deployed root is behind `2a5c1991779`;
  - on exit 2 (clean), report no-change quietly;
  - on exit 0 (a finding, or the scan couldn't run), relay the report to the maintainer inbox;
  - leave the containment drop-in alone, because the powers plane is authorized open under issue #58.
- **Orchestration** `fu-minion-town-containment-gateway-endo-sock-1-20260930-015006-split`: serial, one child, halts if the child fails. It records the same reason and `split-indivisible-handler-timeout: 3600`.

**Check:** I ran `scripts/jobs/assert-overrun-split-posted.sh` against the live job file with a sample report ending in the handoff line, and it passed (rc=0).

No garden files changed; the only writes were these two journal records.

**Follow-up:** once the deployed root has picked up `2a5c1991779`, the daily schedule's preflight should run this check automatically. A clean day will then no longer start an agent run, so overruns like this one shouldn't recur.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-minion-town-containment-gateway-endo-sock-1-20260930-015006.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 22 tokens (589078 cached reads)
- Output: 3968 tokens
- Cost: $0.5990156
- Wall-clock: 72s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
