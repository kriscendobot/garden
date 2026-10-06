---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deadmail.sh
At scripts/jobs/deadmail.sh:210-220, when a promote fails with rc=124 (timeout) or rc=75 (EX_TEMPFAIL: offline, post deadline, or env failure, per common.sh:648-660), the script logs and `continue`s to the next dead-mail. It then retries every remaining entry against the same host-wide fault. On 2026-10-06 one tick produced a 120s timeout at 18:17:04 and then seven rc=75 failures in a row between 18:17:22 and 18:18:36, and the next tick (18:20:12) hit the same failure again on 5746045908. Treat 124 and 75 as tick-wide failures. On the first one, log once, keep the tempfail rc, and `break` out of the loop so the tick stops early instead of running down the 120s-per-item budget. Exit with rc 75 so systemd and the watchdog see a transient failure, not a clean pass. Other nonzero rcs, which are failures specific to one item, keep the current per-item `continue`.
