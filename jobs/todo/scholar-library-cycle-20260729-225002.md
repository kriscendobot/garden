---
role: scholar
tier: mentor
model-burned: minion
fallback-tier: minion
dispatch: automatic
---

# Hourly scholar library cycle

Wear the scholar role for one bounded library cycle. Sync the journal, drain the
scholar inbox and `role/scholar` topic, then process queued library ingestion or
writeback work oldest-first within the role's section budget (about 3–5 source
documents or 25 section writes). Update all affected library indexes, run the
required integrity checks, regenerate projected indexes, and journal a `result`.
Post a precisely scoped follow-on scholar job for any remaining backlog. If no
actionable work is present, record that cleanly and complete the cycle.

<!-- garden-reaped: 0 -->
