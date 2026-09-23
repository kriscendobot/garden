---
role: fixer
priority: high
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: triager-pacing fail-open branch still records a decision every tick

Repo: the garden itself (`kriscendobot/garden`, branch `main2`, push direct — no PR, per CLAUDE.md § Conventions).

## Problem
74461976fd ("fix(triager): stop recording no-op pacing decisions") made the triager
record `triager-pacing` decisions only on a cadence transition (+ a 6h heartbeat).
That gate does NOT cover the **fail-open** branch in `scripts/jobs/triager.sh`
(~line 333–343): when the projection is not `paced` (e.g. reason
`missing-role-cost-samples`), it calls `record_decision --loop triager-pacing
--decision current-cadence --outcome fail-open-skipped` on EVERY tick, unconditionally.

Evidence (journal2, leader endolin-garden-ece02cb4, after it deployed 74461976fd at
14:53Z on 2026-09-23): 28 `decision(...) triager-pacing:current-cadence` commits in
~80 min (~500/day), 100% `outcome: fail-open-skipped`, `reason:
missing-role-cost-samples`, from/to null, across 11 repo slugs. Each is a journal
commit — the same churn shape the journal was just truncated to escape.

## Ask
- Apply the same record-only-on-change discipline to the fail-open branch: record a
  fail-open decision when the (status, reason) state *changes* for that slug (e.g. paced
  → fallback, or reason changes), plus at most the same 6h heartbeat — not per tick.
  Reuse the existing pace marker / heartbeat machinery from 74461976fd rather than a
  parallel mechanism; per-slug state, since the triager is per-repo.
- Keep `triager_pace_note_warning` behavior (the latched warning) intact.
- Quick scope check of the sibling fail-open emitters `scripts/jobs/budget-level.sh:161`
  and `scripts/jobs/claim-job.sh:227` — if either also records per tick in steady state,
  fix it the same way in this job; if not, just say so in the report.
- Add/extend a test under `scripts/jobs/test/` (see the one 74461976fd added) asserting
  that N consecutive fail-open ticks with an unchanged reason produce exactly one
  decision record, and a reason change produces a second.
- Run the relevant `scripts/jobs/test/*` suites; push to `main2`. Deploy rolls via the
  normal upgrade-ready path — do not run deploy-garden.sh yourself.

Report: commit sha, the before/after rate estimate, and the sibling-emitter verdict.
