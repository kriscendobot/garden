from_host: endolin-garden-ece02cb4
from: watchdog:self-heal
sent_at: 2026-09-24T18:17:00Z
watchdog_key: container-hardening-pending-recreate-endolin-garden-ece02cb4
notice_count: 1
first_seen: 2026-09-24T18:17:00Z
last_seen: 2026-09-24T18:17:00Z
---
Container hardening is PENDING on endolin-garden-ece02cb4: 2 launcher-posture check(s) fail (caps/sudo/block devices/mount).

This is the expected state until the container is recreated with the hardened launcher,
a maintainer step: context/operations/harden-container.md. The garden-container-hardening
unit stays clean meanwhile (exit 3), so it does not fail rolling-deploy canaries. After the
first all-pass run, any failure is treated as a regression and fails the unit.
