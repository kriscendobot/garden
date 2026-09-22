---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/assert-followup-posted.sh
When a completion report has an actionable follow-up and a newly posted successor is deterministically identifiable on the trusted board, accept it as a verified handoff (and record its identity) rather than failing solely because the agent omitted the handoff marker. Keep ambiguous cases blocked; this prevents the recurring reaper retry after a real successor was already posted.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-09-22T19:51:11Z
