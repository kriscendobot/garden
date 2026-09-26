from_host: oros-studio-garden-ce242c49
from: watchdog:self-heal
sent_at: 2026-09-26T18:17:04Z
watchdog_key: container-hardening-pending-recreate-oros-studio-garden-ce242c49
notice_count: 1
first_seen: 2026-09-26T18:17:04Z
last_seen: 2026-09-26T18:17:04Z
---
Container hardening is PENDING on oros-studio-garden-ce242c49: 2 launcher-posture check(s) fail (caps/sudo/block devices/mount).

This is the expected state until the container is recreated with the hardened launcher,
a maintainer step: context/operations/harden-container.md. The garden-container-hardening
unit stays clean meanwhile (exit 3), so it does not fail rolling-deploy canaries. After the
first all-pass run, any failure is treated as a regression and fails the unit.
