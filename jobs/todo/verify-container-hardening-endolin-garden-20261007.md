---
role: fixer
tier: mentor
requires: host=endolin-garden-ece02cb4
arc: garden-upkeep
handler-timeout: 1800
fallback-tier: minion
dispatch: automatic
---
**Role: fixer.** On **endolin-garden-ece02cb4**, run `bash scripts/check-container-hardening.sh` from the deployed garden root. Note that `/tmp` is noexec here. Report the full PASS/FAIL list and the exit code.

**Context (liaison muster, 2026-10-07):** both endolin containers were recreated this week after a host software update stopped them. On endolin-garden2 the same probe now passes 6 of 7 checks. The one failure is `lsblk` listing the host's loop devices through the read-only `/sys/block`. `/dev` has no block nodes, a block-device mount fails, CapEff is empty, and sudo is absent. A separate job is fixing that probe false positive.

**Disposition:**
- If this host shows the **same picture** (only the lsblk/sysfs line fails), report "hardened; sysfs false positive only". Send no notice.
- If **anything else** fails (caps, sudo, `/dev` block nodes, mountable device, reachable maintainer credentials, SSH agent), send ONE maintainer notice with `scripts/jobs/watchdog-notice.sh`, key `container-rebuild-needed-endolin-garden-ece02cb4`. Its message: **we need to rebuild our containers with the hardened launcher** (`context/operations/harden-container.md`), naming each failing check.
