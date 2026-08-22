---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Restore Claude (gardener) capacity on endolin-garden-ece02cb4, throttled to 0 on
2026-08-20 during a Claude quota pressure window (manual mitigation, liaison
session; Codex/cleric was throttled up to 3 to compensate). This is a
host-directed op, not a claim any host may run locally — use send-host-op.sh so
it lands on the correct host regardless of which host's gardener claims this job:

  scripts/jobs/send-host-op.sh endolin-garden-ece02cb4 op=set-workers kind=gardener count=2

Verify after sending: `git show origin/journal2:hosts/endolin-garden-ece02cb4`
should read `gardeners: 2`. Leave `clerics` as-is (no instruction to throttle
Codex back down was given). If gardeners is already >0 on that host by the time
this fires (someone restored it by hand already), this is a no-op — do not
lower it.
