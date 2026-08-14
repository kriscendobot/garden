---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
role: builder

# Make review-miss recurrence escalation deterministic

A prosecutor recurrence is a high-value signal that a previously closed improvement failed, but the current path still depends on the scoped prosecutor writing it in the job report and a supervising gardener carrying it to the maintainer. `review-miss-record.sh` already computes `recurrence=1` only after the CAS write that reopens the cluster, and it is the stable plain-code point shared by every caller.

Move or add the recurrence notification at the committed writer path, with a per-cluster dedup key so a lost CAS race or re-run cannot double-alert. Preserve the information-hiding rule: do not grant the scoped prosecutor a general maintainer-inbox capability. Keep `drain_reopen` distinct from a genuine post-improvement recurrence so backlog drain does not false-alert. Update the role/skill wording to name the deterministic carrier and add hermetic coverage for genuine recurrence, drain reopen, CAS retry/idempotency, and notification failure remaining best-effort.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-14T05:57:18Z
