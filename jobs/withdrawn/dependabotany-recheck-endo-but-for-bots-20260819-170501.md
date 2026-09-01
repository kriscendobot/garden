---
withdrawn: true
withdrawn_reason: superseded: 35 later dependabotany-recheck ticks have since completed for this repo; a stale recheck tick has no value (2026-09-01 muster)
withdrawn_by: producer
withdrawn_at: 2026-09-01T20:05:50Z
withdrawn_from_gate: go-ahead
---

---
gate: go-ahead
priority: normal
role: botanist
tier: mentor
token-budget: 250000
doomed: true
doom_signature: requeue-exhausted
doom_count: 1
requeue_cycles: 5
deadline_overruns: 0
elapsed_constancy_confirmations: 0
doomed_at: 2026-08-19T18:03:05Z
doomed_on: endolin-garden-ece02cb4
posted_by: reaper:endolin-garden-ece02cb4
posted_at: 2026-08-19T18:03:05Z
---

---
role: botanist
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Daily dependabotany backstop for endo-but-for-bots

Wear roles/botanist/AGENT.md. Recover the cumulative Dependabot ledger from journal message entries whose body contains both "# Dependabotany" and "project: endo-but-for-bots". Re-evaluate every due open row, including https://github.com/endojs/endo-but-for-bots/pull/923, against live base state, advisories, source maturity, and CI; execute terminal dispositions through the conductor spine.
