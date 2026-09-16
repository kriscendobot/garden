---
gate: orchestrated
orchestrated_by: credit-controls-20260916
priority: normal
posted_by: producer
posted_at: 2026-09-16T05:44:45Z
---

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

CHILD 4 of 4 — CLOSE THE PANEL-SEAT METERING HOLE, AND TIER SEATS OFF OPUS.
Two coupled changes:

(a) METERING. Panel juror seats and gardening state-machine decision calls are
unmetered subprocess `claude -p` invocations, so the ledger sees only ~15-21% of
a host's meter-measured billable tokens. Route them through the usage meter so
recorded spend approximates real spend. Until this lands, every budget control
built by children 1-3 is regulating a fraction of the true burn — say in your
report how much closer the ledger gets.

(b) TIERING. The investigation recommends tiering juror seats off Opus. The
canonical role/tier map is skills/model-selection/SKILL.md (designer and builder
ride the latest Opus; every other role the fleet default). Propose and implement
a seat tiering that preserves review quality — justify per-seat where a cheaper
tier is and is not safe, rather than demoting all 35 seats uniformly. If you judge
some seats genuinely need Opus, say which and why.
