**Verdict: healthy.** oros-studio-garden-ce242c49 is running the main2 tip, `484008b`, and I changed nothing.

- **Load and memory:** load is 2.64 / 2.86 / 2.96. 13 GiB of 15 GiB memory is free. Swap use is 874M, the same as in earlier check-ups.
- **Disk:** the main disk is 7% used and the shared garden disk is 54% used. Inode use is 1% on both.
- **Uptime:** 23 days 17 hours, with no reboot.
- **Deploy:** this host runs the latest main2 and the fleet health page shows `roll_status: deployed`, so there is nothing to help along.
- **Services:** no garden units have failed. Three monk workers are running, the host is not draining, and there is no derotation marker.
- **Budget meter:** it published every 15 minutes from 09:03Z to 10:18Z, and every publish succeeded. Spend is 88.84M of the 180M cap (49.4%), so the meter is not stuck.
- **Journal clones:** there are 33. The largest have 47, 45 and 39 packs, all under the limit of 50. None has leftover temporary packs or a failed-cleanup log.
- **Locks:** no git lock is stuck. The scan did turn up ten `*.lock` files older than 30 minutes, but they are ordinary lock files that the garden scripts keep on disk on purpose.
- **Timeouts (last 3h):** no timed-out or failed runs. The log has 208 lines where a script gave up waiting for the repo lock; that is normal.

**Recorded:** today's note is now at the top of `journal2:projects/garden/oros-health-log.md` (landed with `land-journal-edit.sh`, rc=0).

**Needs a person at the machine or the maintainer:** nothing.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/oros-health-checkup-20261025-102008.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (998875 cached reads)
- Output: 5991 tokens
- Cost: $0.7282910000000001
- Wall-clock: 853s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
