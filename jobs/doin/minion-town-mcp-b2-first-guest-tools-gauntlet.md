---
role: gardener
handler-timeout: 7200
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-09-01T23:02:30Z cleared=deadline-overrun=1 -->

handler-timeout: 7200
<!-- liaison 2026-08-06: this job was DOOMED by the reaper after a
     deterministic deadline overrun at the 2400s default. It carried no
     handler-timeout: header and its role does not qualify for the 7200s
     builder default (landed 2026-08-01), so it was SIGTERM-killed at the
     wall on every requeue. The budget is the fix; the work is wanted.
     If it overruns 7200s too, that is a REAL overrun -- diagnose it, do
     not raise the budget again. -->

---
role: gardener
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-01T09:01:50Z cleared=none -->

---
role: gardener
auto_gauntlet: true
build_job: minion-town-mcp-b2-first-guest-tools
pr: https://github.com/kriscendobot/minion.town/pull/17
---

Automatic gauntlet handoff for completed feature build minion-town-mcp-b2-first-guest-tools.

The build opened https://github.com/kriscendobot/minion.town/pull/17 and it remains an OPEN draft PR. Run the full gardening
state machine now: clean, panel, fixer loop as needed, CI, then un-draft only when
the panel terminates cleanly. This handoff was posted by the build completion edge,
not inferred by a watcher.


<!-- garden-transient-elapsed: kind=signature through=0 values=3 -->

<!-- garden-reaped: 1 -->

<!-- garden-outage-cycle -->
<!-- garden-provider-quota-backoff: type=session reset-at=2026-09-02T08:50:00Z -->
---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-02T05:01:06Z
