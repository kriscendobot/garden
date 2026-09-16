---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-16T06:01:07Z cleared=none -->

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

CHILD 2 of 4 — MANUAL GAUNTLET TRIGGER. The investigation's named recommendation:
adopt the proposed manual-gauntlet-trigger design so gauntlets are not mass-staged
autonomously. The 2026-08-30 hourly design-pr-gauntlet-coverage-audit timer staged
69 gauntlets in one pass and cost $482 on one host.

Find the existing proposed design if one is already in designs/ (search before
writing a new one). Design and implement the trigger, and say explicitly what
happens to the autonomous coverage-audit timer — whether it is retired, reduced
in cadence, or made to propose rather than stage. Include a regression test.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-16T06:01:23Z
