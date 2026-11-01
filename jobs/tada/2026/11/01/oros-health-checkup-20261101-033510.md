**Verdict: healthy.** oros-studio-garden-ce242c49 is running `d45a2d7`, the current origin/main2 tip. I changed nothing on the host.

- **Load and memory:** load is 5.61/5.43/4.81, above the usual ~3.4. A job's Rust build (ironhorse rustc and ld) is the cause; the host itself is fine. 12 of 15 GiB is available, and swap shows its usual steady level.
- **Disk:** the overlay is 7% used and the garden mount 64% (170G free). Inodes are at 1%.
- **Uptime:** 30d10h, no reboot.
- **Deploy:** the fleet/health record shows `roll_status: deployed` at `d45a2d7`, with 0 of 290 units failing. No units are failed now. `garden-monk@1..4` are running, the host is not draining, worker leveling is `4 0`, and there is no derotation marker.
- **Budget meter:** the last push was at 04:03Z. The twelve pushes from 01:18Z on were all ok, about every 15 minutes. Spend is 6.57M of the 180M cap.
- **State clones:** there are 43 journal clones. The largest is fork-watch at 50 packs, which is at the repack threshold but not over it, so I left it alone. There is no `gc.log`, no leftover `tmp_pack` file, and no git lock older than 30 minutes.
- **Timeouts (last 3h):** one, `shepherd-endojs-endo-but-for-bots-pr1348-ubuntu26-ci-20261101`. It ran out its own 2401s handler time limit, was classified transient, and was left for the reaper to requeue, as designed.

I added a newest-first entry to `journal2:projects/garden/oros-health-log.md` through `land-journal-edit.sh`.

**Needs a person or the maintainer:** nothing.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261101-033510.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (731700 cached reads)
- Output: 5080 tokens
- Cost: $0.6384839999999999
- Wall-clock: 339s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
