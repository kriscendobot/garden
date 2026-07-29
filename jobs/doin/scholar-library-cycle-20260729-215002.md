---
role: scholar
---

# Hourly scholar library cycle

Wear the scholar role for one bounded library cycle. Sync the journal, drain the
scholar inbox and `role/scholar` topic, then process queued library ingestion or
writeback work oldest-first within the role's section budget (about 3–5 source
documents or 25 section writes). Update all affected library indexes, run the
required integrity checks, regenerate projected indexes, and journal a `result`.
Post a precisely scoped follow-on scholar job for any remaining backlog. If no
actionable work is present, record that cleanly and complete the cycle.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: cleric
  claimed_at: 2026-07-29T21:50:46Z
