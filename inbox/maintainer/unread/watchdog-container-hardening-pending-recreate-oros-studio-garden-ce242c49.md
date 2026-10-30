from_host: oros-studio-garden-ce242c49
from: watchdog:self-heal
sent_at: 2026-10-30T18:17:03Z
watchdog_key: container-hardening-pending-recreate-oros-studio-garden-ce242c49
notice_count: 2
first_seen: 2026-10-23T06:17:01Z
last_seen: 2026-10-30T18:17:03Z
---
WATCHDOG notice — occurrence #2 (first seen 2026-10-23T06:17:01Z, latest 2026-10-30T18:17:03Z).
The SAME condition (`container-hardening-pending-recreate-oros-studio-garden-ce242c49`) has now been observed 2 times; this is ONE
coalesced notice that updates in place, not 2 messages. Latest detail:

Container hardening is PENDING on oros-studio-garden-ce242c49: 2 launcher-posture check(s) fail (caps/sudo/block devices/mount).

This is the expected state until the container is recreated with the hardened launcher,
a maintainer step: context/operations/harden-container.md. The garden-container-hardening
unit stays clean meanwhile (exit 3), so it does not fail rolling-deploy canaries. After the
first all-pass run, any failure is treated as a regression and fails the unit.
