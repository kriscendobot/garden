---
role: fixer
tier: mentor
fallback-tier: minion
arc: garden-upkeep
dispatch: automatic
---
**Role: fixer.** Fix a false positive in `scripts/check-container-hardening.sh` (garden repo; push to `main2`).

**The defect (observed 2026-10-07 on endolin-garden2, after the container was recreated with the hardened `garden` launcher):** the block-device check (~line 304) fails because `lsblk -nro NAME` lists the host's loop devices (`loop0…loop20`). It reads them from the **read-only sysfs** `/sys/block`, which every Docker container sees. Meanwhile `/dev` has no block nodes and the probe's own mount test fails as intended. So a properly hardened container stays "PENDING RECREATE" forever, and the maintainer is told to rebuild containers that are already rebuilt.

**Fix:** make the check match the threat it guards, a block **device node** that could be mounted. Enumerate `/dev` block nodes (`find /dev -type b`) as the authority. Treat `lsblk` output as a finding only when a listed device has a reachable node, or drop it. Keep the mount test as the backstop.
- Do not weaken any other check.
- If you conclude that sysfs visibility is itself an exposure the design meant to close, say so, propose masking `/sys/block` in the `garden` launcher instead, and do not change the probe.

Add a test, and update `context/operations/harden-container.md` if its wording implies lsblk must be empty. Once deployed, the first all-pass run writes the hardened-verified marker and closes the pending notice.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-07T22:08:28Z
