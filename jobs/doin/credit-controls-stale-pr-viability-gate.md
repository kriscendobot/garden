---
tier: mentor
---
<!-- garden-promoted-from-plan: gate=orchestrated priority=normal at=2026-09-16T06:22:09Z cleared=none -->

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

CHILD 3 of 4 — PRE-GAUNTLET VIABILITY GATE FOR STALE PRs. Part of the $482 went
to stale and superseded PRs churning to iteration 6/6 of the panel/fix loop
before anyone noticed the premise was dead.

Add a viability gate that runs BEFORE a gauntlet spends its budget: check the PR
is open, not merged, not superseded, and that its premise still stands; refuse and
report rather than entering the loop when it does not. Per the standing garden
norm, when a premise is overtaken the gate should surface "close as superseded"
explicitly as an option, naming the deciding question, rather than silently
refusing. Include a regression test.

<!-- garden-reaped: 1 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-16T10:23:48Z
