**oros-health-checkup-20261022-093509: oros-studio-garden-ce242c49 is healthy. It is deployed at origin/main2 `91030eca`, and I changed nothing.**

- **Load and memory:** load averages 1.56, 1.79 and 2.23 at 11:09Z. 12 of 15 GiB is available and no swap is in use.
- **Disk and inodes:** the overlay is 7% used (403G free) and the virtiofs garden mount is 57% used. Inodes are at 1%.
- **Uptime:** 20d17h, with no reboot.
- **Deploy:** `deployed-sha` matches the origin/main2 tip. fleet/health reports `roll_status: deployed` with 0 of 289 units failed. There is nothing to help along.
- **Units:** no garden unit has failed. Three units were briefly "activating", but each had started within the last 2 minutes. The fleet is not draining and there is no derotation marker.
- **Worker count:** `hosts/oros` dropped from `monks: 3` to `monks: 2`, written by oros itself at 09:06:55Z. I left it alone, since worker leveling is off-limits for this job.
- **Budget heartbeat:** the last snapshot was sampled at 11:02:14Z and pushed at 11:02:19Z, status ok, at 61.9M of 180M (22%). The six most recent pushes all succeeded. One reading at 10:03Z dropped by 24k tokens (0.04%), confirmed on re-measure. That is harmless, and spend grew again afterwards.
- **State clones:** there are 33 journal clones. The largest has 48 packs, under the threshold of 50. None has a tmp_pack or `gc.log`, no git lock in them is older than 30 minutes, and no bun/node test processes were left running. My first lock search over all of `.garden-state` hit its 200s time limit. The narrower search inside each clone's `.git` finished and found nothing.
- **Timeouts (rc=124, last 3h):** one, and it was the job's own fault rather than the host's. `endojs-endo-but-for-bots-no-any-typecheck` ran past its 2400s budget on monk/1 at 09:16Z. It was classified as transient and the reaper will requeue it.

I added this snapshot to the top of `journal2:projects/garden/oros-health-log.md` with `land-journal-edit.sh`.

**Needs a person or the maintainer:** nothing.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261022-093509.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (669573 cached reads)
- Output: 5527 tokens
- Cost: $0.6366786
- Wall-clock: 287s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
