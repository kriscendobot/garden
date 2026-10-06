---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/foreman-claude.sh
`scripts/jobs/handlers/foreman-claude.sh:319-340` turns an exhausted provider order into `die`, causing repeated foreman FATALs at 2026-10-06T02:04:25Z through 02:39:21Z while Claude was already known at high water. Persist an all-providers-unavailable cooldown keyed to provider order/quota state, skip inference until its bounded re-probe, and return the transient status so the timer remains healthy.
