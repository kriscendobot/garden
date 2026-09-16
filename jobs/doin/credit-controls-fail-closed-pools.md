---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-16T05:46:04Z cleared=none -->

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Source: reports/credit-investigation-endolin-garden2-20260905.md (mentat job
mentat-endolin-garden2-credit-investigation-20260905). Findings it established:
all liaison numbers reproduce exactly ($1,257.19 recorded, no dedup/cumulative
defect). $1,090.65 of it burned in the ~19h window from 2026-09-04T04:00Z when
the host ran on a temporary API key with its budget pool marked UNMETERED, so
pool_admits failed OPEN and nothing throttled. Multipliers: a backlog of 69
gauntlets mass-staged 2026-08-30 by the hourly design-pr-gauntlet-coverage-audit
timer ($482, including stale/superseded PRs churning at iteration 6/6);
everything on opus-4-8; and panel juror seats plus state-machine decision calls
being unmetered subprocess `claude -p` calls, so the ledger covers only ~15-21%
of the host meter-measured billable tokens (true spend plausibly 2-5x recorded).

This is one of four serial children of orchestration
credit-controls-20260916. Authorized by kriskowal via liaison muster 2026-09-16.

CHILD 1 of 4 — FAIL CLOSED ON AN UNMETERED POOL. This is the highest-value fix
and runs first because it bounds the blast radius of every other gap.

Today `pool_admits` fails OPEN when a budget pool's provenance is 'unmetered' or
'uncalibrated', so a host with live workers and no calibrated cap throttles
nothing. Change it to fail CLOSED, or to admit only under an explicit credit
ceiling the operator must set deliberately. Reckon with the operational cost of
failing closed (a mis-set pool silently halts a host) and choose a shape that
makes the halt loud and the remedy obvious rather than mysterious. Include a
regression test pinning both the refusal and the explicit-ceiling escape hatch.

Related live signal: two watchdog notices are open RIGHT NOW for exactly this
condition — pools anthropic:endolin-garden2-5bcdff64 (cap=385000000) and
anthropic:endolin-garden-ece02cb4 (cap=595000000) are both UNCALIBRATED, seen 32
and 87 times. Say in your report whether your change would have refused those.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-16T05:46:37Z
